import 'package:flutter/material.dart';

import 'package:daegri/screens/crop_management_screen.dart';
import 'package:daegri/screens/gps_mapping_screen.dart'; // Import GpsMappingScreen
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daegri GPS App', // Reverted title
      theme: ThemeData(
        primarySwatch: Colors.blue, // Reverted theme
      ),
      home: GpsMappingScreen(), // Set home back to GpsMappingScreen
      // We can define routes here for more complex navigation later if needed
      // routes: {
      //   '/crop-management': (context) => CropManagementScreen(),
      //   // other routes
      // },
    );
  }
}

// GpsMappingScreen class definition is now removed from this file.
// It is located in daegri/frontend_flutter/lib/screens/gps_mapping_screen.dart
