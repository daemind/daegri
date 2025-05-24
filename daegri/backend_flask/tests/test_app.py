import os
import sys
import unittest
import json

# Add the parent directory (backend_flask) to the Python path
# This allows us to import 'app' from the parent directory
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from app import app

class TestApp(unittest.TestCase):

    def setUp(self):
        """Set up test client and other test variables."""
        app.config['TESTING'] = True
        self.client = app.test_client()

    def test_hello_endpoint_status_code(self):
        """Test the /api/hello endpoint for a 200 status code."""
        response = self.client.get('/api/hello')
        self.assertEqual(response.status_code, 200)

    def test_hello_endpoint_response_data(self):
        """Test the /api/hello endpoint for correct content type and JSON data."""
        response = self.client.get('/api/hello')
        
        # Check content type
        self.assertEqual(response.content_type, 'application/json')
        
        # Check JSON data
        expected_data = {"message": "Hello from Daegri Backend (Flask)"}
        # response.data is a byte string, so we need to decode it and then parse as JSON
        actual_data = json.loads(response.data.decode('utf-8'))
        self.assertEqual(actual_data, expected_data)

    # --- Parcel Endpoint Tests ---

    def test_get_parcels_endpoint_success(self):
        """Test the GET /api/parcels endpoint for success and data structure."""
        response = self.client.get('/api/parcels')
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.content_type, 'application/json')
        
        responseData = json.loads(response.data.decode('utf-8'))
        self.assertIsInstance(responseData, list)
        self.assertEqual(len(responseData), 2) # Based on dummy data in app.py
        
        # Check structure of the first parcel
        if len(responseData) > 0:
            first_parcel = responseData[0]
            self.assertIn('id', first_parcel)
            self.assertIn('name', first_parcel)
            self.assertIn('task', first_parcel)
            self.assertIn('boundaryPoints', first_parcel)
            self.assertIsInstance(first_parcel['boundaryPoints'], list)

    def test_post_parcels_endpoint_success(self):
        """Test the POST /api/parcels endpoint for successful data submission."""
        sample_data = {
            "name": "Test Parcel From Post", 
            "task": "Watering", 
            "boundaryPoints": [{"lat": 47.0, "lon": 3.0}]
        }
        response = self.client.post('/api/parcels', json=sample_data)
        
        self.assertEqual(response.status_code, 201)
        self.assertEqual(response.content_type, 'application/json')
        
        responseData = json.loads(response.data.decode('utf-8'))
        self.assertEqual(responseData['message'], "Parcel data successfully received")
        self.assertEqual(responseData['received_data'], sample_data)

    def test_post_parcels_endpoint_no_data(self):
        """Test the POST /api/parcels endpoint when no JSON data is sent."""
        response = self.client.post('/api/parcels', data=None, content_type='application/json')
        # Assuming app.py returns 400 if no data is provided
        self.assertEqual(response.status_code, 400) 
        
        responseData = json.loads(response.data.decode('utf-8'))
        self.assertIn('error', responseData)
        self.assertEqual(responseData['error'], "No input data provided")


if __name__ == '__main__':
    unittest.main()
