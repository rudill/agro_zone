import 'package:agro_zone/models/geo_data.dart';
import 'package:agro_zone/models/user_plot_data.dart';
import 'package:agro_zone/services/polygon_decoder.dart';
import 'package:agro_zone/supabase/dbdata.dart';
import 'package:agro_zone/widgets/drawer.dart';
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

  List<LatLng> selectedPolygon = [];
  List<LatLng> drawingPolygon = [];

  bool isDrawing = false;
  dynamic polygonData;

  @override
  void initState() {
    super.initState();
    selectedPolygon = PolygonDecoder().decodePolygon();
  }

  @override
  Widget build(BuildContext context) {
    final geoData = GeoData();

    return Scaffold(
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'draw',
            child: Icon(isDrawing ? Icons.check : Icons.edit),
            onPressed: () {
              setState(() {
                isDrawing = !isDrawing;
                if (isDrawing && drawingPolygon.isNotEmpty) {
                  polygonData = PolygonDecoder().polygonToGeoJson(
                    drawingPolygon,
                  );
                  //show using alert
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Geometry Data'),
                        content: Text(polygonData),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Close'),
                          ),
                        ],
                      );
                    },
                  );
                }
              });
            },
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'clear',
            child: Icon(Icons.clear),
            onPressed: () {
              setState(() {
                isDrawing = !isDrawing;
                if (isDrawing) {
                  drawingPolygon.clear();
                }
              });
            },
          ),
          FloatingActionButton(
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
                            // final geometryData = PolygonDecoder()
                            //     .polygonToGeoJson(drawingPolygon);
                            final newPlot = UserPlotData(
                              name: plotNameController.text,
                              cropType: cropTypeController.text,
                              notes: notesController.text,
                              geometry: polygonData,
                            );

                            await SupabaseDataBaseData().insertUserPlots(
                              newPlot,
                            );
                            print('name: ${plotNameController.text}');
                            print('cropType: ${cropTypeController.text}');
                            print('notes: ${notesController.text}');
                            print('geometry: $polygonData');
                            // ignore: use_build_context_synchronously
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
        ],
      ),
      drawer: drawerWidget(geoData),
      appBar: AppBar(title: const Text('Map View')),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(7.8731, 80.7718),
          initialZoom: 7,
          onTap: (tapPosition, point) {
            if (isDrawing) {
              setState(() {
                drawingPolygon.add(point);
              });
            }
          },
        ),

        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
          ),
          PolygonLayer(
            polygons: [
              if (drawingPolygon.isNotEmpty)
                Polygon(
                  points: drawingPolygon,
                  color: Colors.blue.withOpacity(0.3),
                  borderStrokeWidth: 2,
                  borderColor: Colors.blue,
                ),
              // Polygon(
              //   points: selectedPolygon,
              //   // ignore: deprecated_member_use
              //   color: Colors.blue.withOpacity(0.3),
              //   borderStrokeWidth: 2,
              //   borderColor: Colors.blue,
              // ),
            ],
          ),
        ],
      ),
    );
  }

  Drawer drawerWidget(GeoData geoData) {
    return Drawer(
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
    );
  }
}
