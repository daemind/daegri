import 'package:flutter_test/flutter_test.dart';
import '../../lib/models/crop_plot.dart'; // Corrected path

void main() {
  group('CropPlot Tests', () {
    test('CropPlot properties are correctly assigned', () {
      final plot = CropPlot(
        id: 'test_id_123',
        name: 'My Test Plot',
        cropType: 'Test Crop',
        surfaceArea: 1.23,
      );

      expect(plot.id, 'test_id_123');
      expect(plot.name, 'My Test Plot');
      expect(plot.cropType, 'Test Crop');
      expect(plot.surfaceArea, 1.23);
    });
  });
}
