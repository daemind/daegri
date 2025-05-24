from flask import Flask, jsonify, request # Added request

app = Flask(__name__)

@app.route('/api/hello', methods=['GET'])
def hello():
    return jsonify({"message": "Hello from Daegri Backend (Flask)"})

# Placeholder for parcel data
# In a real application, this would come from a database.
dummy_parcels_db = [
    {"id": "parcel_1", "name": "North Field", "task": "Seeding", "boundaryPoints": [{"lat": 46.5, "lon": 2.5}, {"lat": 46.6, "lon": 2.5}]},
    {"id": "parcel_2", "name": "South Plot", "task": "Fertilizing", "boundaryPoints": [{"lat": 46.0, "lon": 2.0}, {"lat": 46.1, "lon": 2.1}]}
]

@app.route('/api/parcels', methods=['GET'])
def get_parcels():
    """Endpoint to get all parcels."""
    return jsonify(dummy_parcels_db)

@app.route('/api/parcels', methods=['POST'])
def add_parcel():
    """Endpoint to add a new parcel."""
    data = request.get_json()
    
    if not data:
        return jsonify({"error": "No input data provided"}), 400
        
    # For now, just print and return confirmation.
    # In a real app, you would validate, generate an ID, and store the data.
    print(f"Received parcel data for POST: {data}")
    
    # Simulate adding to our dummy_parcels_db for demonstration if needed for other tests,
    # but for this subtask, we're just confirming receipt.
    # Example: data['id'] = f"parcel_{len(dummy_parcels_db) + 1}"
    # dummy_parcels_db.append(data)

    return jsonify({"message": "Parcel data successfully received", "received_data": data}), 201

if __name__ == '__main__':
    app.run(debug=True)
