import 'package:flutter/material.dart';
import 'crop_management_screen.dart'; // Import for navigation

class GpsMappingScreen extends StatefulWidget {
  @override
  _GpsMappingScreenState createState() => _GpsMappingScreenState();
}

class _GpsMappingScreenState extends State<GpsMappingScreen> {
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  String _enteredCoordinates = 'Entered Coordinates: Lat: , Lon: ';

  @override
  void initState() {
    super.initState();
    _latitudeController.addListener(_updateCoordinates);
    _longitudeController.addListener(_updateCoordinates);
  }

  @override
  void dispose() {
    _latitudeController.removeListener(_updateCoordinates);
    _longitudeController.removeListener(_updateCoordinates);
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  void _updateCoordinates() {
    setState(() {
      _enteredCoordinates =
          'Entered Coordinates: Lat: ${_latitudeController.text}, Lon: ${_longitudeController.text}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GPS Mapping'), // Updated title
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // 1. Map Placeholder
            Container(
              height: 250, // Adjusted height
              color: Colors.blueGrey,
              child: Center(
                child: Text(
                  'Map Placeholder',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 20),

            // 2. Latitude Input
            TextField(
              controller: _latitudeController,
              decoration: InputDecoration(
                labelText: 'Latitude',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            SizedBox(height: 10),

            // 3. Longitude Input
            TextField(
              controller: _longitudeController,
              decoration: InputDecoration(
                labelText: 'Longitude',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            SizedBox(height: 20),

            // 4. Display Entered Coordinates
            Text(
              _enteredCoordinates,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20), // Added space

            // 5. Navigation Button
            ElevatedButton(
              child: Text('Go to Crop Management'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CropManagementScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
