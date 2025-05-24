import 'package:flutter/material.dart';
import '../models/crop_plot.dart';

class CropManagementScreen extends StatefulWidget {
  @override
  _CropManagementScreenState createState() => _CropManagementScreenState();
}

class _CropManagementScreenState extends State<CropManagementScreen> {
  final List<CropPlot> _cropPlots = [];

  // Controllers for the AlertDialog TextFields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cropTypeController = TextEditingController();
  final TextEditingController _surfaceAreaController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _cropTypeController.dispose();
    _surfaceAreaController.dispose();
    super.dispose();
  }

  void _addCropPlot() {
    if (_nameController.text.isEmpty ||
        _cropTypeController.text.isEmpty ||
        _surfaceAreaController.text.isEmpty) {
      // Maybe show a little snackbar error here in a real app
      return;
    }
    final String name = _nameController.text;
    final String cropType = _cropTypeController.text;
    final double? surfaceArea = double.tryParse(_surfaceAreaController.text);

    if (surfaceArea == null) {
      // Maybe show a little snackbar error for invalid number
      return;
    }

    final newPlot = CropPlot(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      cropType: cropType,
      surfaceArea: surfaceArea,
    );

    setState(() {
      _cropPlots.add(newPlot);
    });

    // Clear controllers and close dialog
    _nameController.clear();
    _cropTypeController.clear();
    _surfaceAreaController.clear();
    Navigator.of(context).pop(); // Close the dialog
  }

  void _showAddPlotDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Add New Crop Plot'),
          content: SingleChildScrollView( // Added to prevent overflow if keyboard appears
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Plot Name'),
                  textInputAction: TextInputAction.next,
                ),
                TextField(
                  controller: _cropTypeController,
                  decoration: InputDecoration(labelText: 'Crop Type'),
                  textInputAction: TextInputAction.next,
                ),
                TextField(
                  controller: _surfaceAreaController,
                  decoration: InputDecoration(labelText: 'Surface Area (e.g., 1.5)'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _addCropPlot(), // Allow submitting with keyboard done
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                // Clear controllers before closing
                _nameController.clear();
                _cropTypeController.clear();
                _surfaceAreaController.clear();
                Navigator.of(dialogContext).pop();
              },
            ),
            ElevatedButton( // Changed to ElevatedButton for better visibility
              child: Text('Add'),
              onPressed: _addCropPlot,
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crop Management'),
      ),
      body: _cropPlots.isEmpty
          ? Center(
              child: Text('No crop plots added yet.'),
            )
          : ListView.builder(
              itemCount: _cropPlots.length,
              itemBuilder: (context, index) {
                final plot = _cropPlots[index];
                return ListTile(
                  title: Text(plot.name),
                  subtitle: Text('Crop: ${plot.cropType}, Area: ${plot.surfaceArea} sq units'),
                  // You could add more details or an onTap here if needed
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddPlotDialog(context),
        tooltip: 'Add Crop Plot',
        child: Icon(Icons.add),
      ),
    );
  }
}
