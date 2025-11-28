import 'package:latlong2/latlong.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mp;

class AreaCalculator {
  /// Calculates the area of a polygon in square meters.
  static double calculateArea(List<LatLng> points) {
    if (points.length < 3) return 0.0;

    final List<mp.LatLng> mpPoints =
        points.map((p) => mp.LatLng(p.latitude, p.longitude)).toList();

    return mp.SphericalUtil.computeArea(mpPoints).toDouble();
  }

  /// Converts square meters to hectares.
  static double toHectares(double areaInSqMeters) {
    return areaInSqMeters / 10000.0;
  }

  /// Converts square meters to acres.
  static double toAcres(double areaInSqMeters) {
    return areaInSqMeters * 0.000247105;
  }
}
