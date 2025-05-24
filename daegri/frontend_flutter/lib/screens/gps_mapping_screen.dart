import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart'; // Import geolocator
import 'dart:async'; // Import for StreamSubscription
import 'crop_management_screen.dart'; // Import for navigation
import '../models/parcel.dart'; // Import Parcel model

class GpsMappingScreen extends StatefulWidget {
  @override
  _GpsMappingScreenState createState() => _GpsMappingScreenState();
}

class _GpsMappingScreenState extends State<GpsMappingScreen> {
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  String _enteredCoordinates = 'Entered Coordinates: Lat: , Lon: ';

  // Controllers for Parcel Details Dialog
  final TextEditingController _parcelNameController = TextEditingController();
  final TextEditingController _parcelTaskController = TextEditingController();

  // State variables for parcel mapping
  List<LatLng> _currentParcelPoints = [];
  List<Parcel> _definedParcels = [];
  bool _isMappingParcelMode = false;

  // State variables for GPS tracking
  Position? _currentPosition;
  StreamSubscription<Position>? _positionStreamSubscription;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _latitudeController.addListener(_updateCoordinates);
    _longitudeController.addListener(_updateCoordinates);
    _determinePositionAndListen(); // Call GPS listening method
  }

  @override
  void dispose() {
    _latitudeController.removeListener(_updateCoordinates);
    _longitudeController.removeListener(_updateCoordinates);
    _latitudeController.dispose();
    _longitudeController.dispose();
    _parcelNameController.dispose(); // Dispose parcel dialog controllers
    _parcelTaskController.dispose(); // Dispose parcel dialog controllers
    _positionStreamSubscription?.cancel(); // Cancel stream subscription
    super.dispose();
  }

  Future<Map<String, String>?> _showParcelDetailsDialog() async {
    _parcelNameController.text = "Parcel ${_definedParcels.length + 1}"; // Default name
    _parcelTaskController.clear(); // Clear previous task input

    return showDialog<Map<String, String>>(
      context: context,
      barrierDismissible: false, // User must tap button!
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Enter Parcel Details'),
          content: SingleChildScrollView( // In case of small screens
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: _parcelNameController,
                  decoration: InputDecoration(labelText: 'Parcel Name'),
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _parcelTaskController,
                  decoration: InputDecoration(labelText: 'Task (e.g., Treat, Harvest)'),
                  textInputAction: TextInputAction.done,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop(null);
              },
            ),
            ElevatedButton(
              child: Text('Save'),
              onPressed: () {
                if (_parcelNameController.text.isNotEmpty) {
                  Navigator.of(dialogContext).pop({
                    'name': _parcelNameController.text,
                    'task': _parcelTaskController.text,
                  });
                } else {
                  // Optionally show a small validation message within the dialog
                  // For now, just preventing close if name is empty.
                  // Or, could disable Save button until name is filled.
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _determinePositionAndListen() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled.');
      // Optionally show a snackbar or dialog
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location services are disabled. Please enable them.')),
        );
      }
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Location permissions are denied.')),
          );
        }
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('Location permissions are permanently denied');
      if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text('Location permissions are permanently denied. Please enable them in app settings.')),
         );
      }
      return;
    }

    try {
      _currentPosition = await Geolocator.getCurrentPosition();
      setState(() {}); // Update UI with initial position

      _positionStreamSubscription = Geolocator.getPositionStream().listen((Position position) {
        setState(() {
          _currentPosition = position;
          // Optional: _mapController.move(LatLng(position.latitude, position.longitude), _mapController.camera.zoom);
        });
      });
    } catch (e) {
      print('Error getting location: $e');
    }
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
            // 1. Map Display
            Container(
              height: 300, // Fixed height for the map
              child: FlutterMap(
                mapController: _mapController, // Pass mapController
                options: MapOptions(
                  initialCenter: LatLng(46.2276, 2.2137), // Center of France
                  initialZoom: 5.0,
                  onTap: (tapPosition, latLng) {
                    if (_isMappingParcelMode) {
                      setState(() {
                        _currentParcelPoints.add(latLng);
                      });
                    }
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'dev.daegri.app',
                  ),
                  PolygonLayer(
                    polygons: _definedParcels.map((parcel) {
                      return Polygon(
                        points: parcel.boundaryPoints,
                        color: Colors.blue.withOpacity(0.3),
                        borderColor: Colors.blue,
                        borderStrokeWidth: 2,
                        isFilled: true,
                      );
                    }).toList(),
                  ),
                  MarkerLayer( // For parcel definition points
                    markers: _currentParcelPoints.map((point) {
                      return Marker(
                        point: point,
                        width: 8,
                        height: 8,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.red, // Color for parcel definition points
                            shape: BoxShape.circle,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  if (_currentPosition != null) // For current GPS location
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                          width: 80,
                          height: 80,
                          child: Icon(Icons.my_location, color: Colors.redAccent, size: 30.0),
                        ),
                      ],
                    ),
                ],
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
            SizedBox(height: 10), // Adjusted space

            // Parcel Mapping Toggle Button
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (!_isMappingParcelMode) {
                    _isMappingParcelMode = true;
                    _currentParcelPoints.clear();
                  } else { // Finalizing or cancelling
                    if (_currentParcelPoints.length >= 3) {
                      final parcelDetails = await _showParcelDetailsDialog();
                      if (parcelDetails != null && parcelDetails['name']!.isNotEmpty) {
                        final newParcel = Parcel(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          name: parcelDetails['name']!,
                          task: parcelDetails['task']!,
                          boundaryPoints: List.from(_currentParcelPoints),
                        );
                        _definedParcels.add(newParcel);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Parcel "${newParcel.name}" created with task: "${newParcel.task}"'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Parcel creation cancelled.'),
                            backgroundColor: Colors.amber,
                          ),
                        );
                      }
                      _currentParcelPoints.clear();
                      _isMappingParcelMode = false;
                    } else { // Less than 3 points
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Parcel mapping cancelled, not enough points (min 3).'),
                          backgroundColor: Colors.orange,
                        ),
                      );
                      _currentParcelPoints.clear();
                      _isMappingParcelMode = false;
                    }
                  }
                });
              },
              child: Text(
                !_isMappingParcelMode
                    ? 'Start Mapping Parcel'
                    : (_currentParcelPoints.length >= 3
                        ? 'Finalize Parcel'
                        : 'Stop Mapping (Need >=3 pts)'),
              ),
            ),
            SizedBox(height: 10),

            // Center on GPS Button
            ElevatedButton.icon(
              icon: Icon(Icons.gps_fixed),
              label: Text("Center on GPS"),
              onPressed: () {
                if (_currentPosition != null) {
                  _mapController.move(
                    LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                    _mapController.camera.zoom > 15 ? _mapController.camera.zoom : 15.0
                  );
                }
              },
            ),
             SizedBox(height: 10), // Added space

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
