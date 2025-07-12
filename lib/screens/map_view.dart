import 'package:agro_zone/models/geo_data.dart';
import 'package:agro_zone/models/user_plot_data.dart';
import 'package:agro_zone/services/polygon_decoder.dart';
import 'package:agro_zone/supabase/dbdata.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  TextEditingController plotNameController = TextEditingController();
  TextEditingController cropTypeController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  TextEditingController geometryController = TextEditingController();

  List<LatLng> selectedPolygon = [];

  @override
  void initState() {
    super.initState();
    selectedPolygon = PolygonDecoder().decodePolygon();
  }

  @override
  Widget build(BuildContext context) {
    final geoData = GeoData();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          //show dialog to add new plot
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Add New Plot'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    buildTextFields(plotNameController, 'Plot Name'),
                    SizedBox(height: 10),
                    buildTextFields(cropTypeController, 'Crop Type'),
                    SizedBox(height: 10),
                    buildTextFields(notesController, 'Notes'),
                    SizedBox(height: 10),
                    buildTextFields(geometryController, 'Geometry Data'),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      // Handle adding new plot
                      try {
                        final newPlot = UserPlotData(
                          name: plotNameController.text,
                          cropType: cropTypeController.text,
                          notes: notesController.text,
                          geometry: geometryController.text,
                        );

                        await SupabaseDataBaseData().insertGeometryData(
                          newPlot,
                        );
                        Navigator.pop(context);
                      } catch (e) {
                        print('Error: $e');
                      }
                    },
                    child: Text('Add'),
                  ),
                ],
              );
            },
          );
        },
      ),
      drawer: Drawer(
        child: FutureBuilder(
          future: SupabaseDataBaseData().userPlots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
              return const Center(child: Text('No data found.'));
            }
            final data = snapshot.data as List;
            return ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(color: Colors.blue),
                  child: Text(
                    'Agro Zone',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
                ...data.map<Widget>(
                  (item) => ListTile(
                    title: Text(item['name'].toString()),
                    onTap: () async {
                      geoData.setData(item['the_geom'].toString());

                      final coords = PolygonDecoder().decodePloygonFromDataBase(
                        item['the_geom'],
                      );
                      setState(() {
                        selectedPolygon = coords;
                      });
                      Navigator.pop(context);

                      print(geoData.getGeoCoords());
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
      appBar: AppBar(title: const Text('Map View')),
      body: FlutterMap(
        options: const MapOptions(
          initialCenter: LatLng(7.8731, 80.7718),
          initialZoom: 7,
        ),

        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
          ),
          PolygonLayer(
            polygons: [
              Polygon(
                points: selectedPolygon,
                color: Colors.blue.withOpacity(0.3),
                borderStrokeWidth: 2,
                borderColor: Colors.blue,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildTextFields(TextEditingController controller, String hintText) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(),
      ),
    );
  }
}
