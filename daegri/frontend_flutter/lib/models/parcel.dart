import 'package:latlong2/latlong.dart';

class Parcel {
  final String id;
  final String name;
  final String task;
  final List<LatLng> boundaryPoints;

  const Parcel({
    required this.id,
    required this.name,
    required this.task,
    required this.boundaryPoints,
  });
}
