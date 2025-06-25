import 'dart:convert';

import 'package:latlong2/latlong.dart';

class PolygonDecoder {
  final String geoJsonString = '''
  {
    "type": "FeatureCollection",
    "features": [
      {
        "type": "Feature",
        "properties": {},
        "geometry": {
          "coordinates": [
            [
              [80.99926699825852, 7.942971679180758],
              [80.99724899198571, 7.93715279598193],
              [81.00621507048334, 7.93715279598193],
              [81.00414597544506, 7.943123475029964],
              [80.99926699825852, 7.942971679180758]
            ]
          ],
          "type": "Polygon"
        }
      }
    ]
  }
  ''';

  List<LatLng> decodePolygon() {
    final geoJson = jsonDecode(geoJsonString);
    final coordinates = geoJson['features'][0]['geometry']['coordinates'][0];
    return coordinates
        .map<LatLng>((coord) => LatLng(coord[1], coord[0]))
        .toList();
  }

  List<LatLng> decodePloygonFromDataBase(dynamic geometryData) {
    Map<String, dynamic> geoJson = jsonDecode(geometryData);
    final coordinates = geoJson['coordinates'][0];
    final polygonPoints =
        coordinates.map<LatLng>((coord) => LatLng(coord[1], coord[0])).toList();
    return polygonPoints;
  }
}
