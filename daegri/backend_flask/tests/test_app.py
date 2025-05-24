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

if __name__ == '__main__':
    unittest.main()
