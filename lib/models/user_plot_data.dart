import 'dart:convert';

class UserPlotData {
  // final String id;
  final String name;
  final String cropType;
  final String notes;
  final dynamic geometry;

  UserPlotData({
    // required this.id,
    required this.name,
    required this.cropType,
    required this.notes,
    required this.geometry,
  });

  factory UserPlotData.fromJson(Map<String, dynamic> json) {
    return UserPlotData(
      // id: json['id'],
      name: json['name'],
      cropType: json['crop_type'],
      notes: json['notes'],
      geometry: json['geometry'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // 'id': id,
      'name': name,
      'crop_type': cropType,
      'notes': notes,
      'geojson': jsonDecode(geometry), // Assuming geometry is a GeoJSON string
    };
  }
}
