import 'package:latlong2/latlong.dart';

class GeoData {
  List<LatLng> coordinates;

  GeoData([this.coordinates = const []]);

  List<LatLng> get getCoordinates => coordinates;

  set setCoordinates(List<LatLng> newCoordinates) {
    if (newCoordinates.isNotEmpty) {
      coordinates.clear();
      coordinates.addAll(newCoordinates);
    }
  }
}
