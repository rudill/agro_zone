import 'package:agro_zone/models/user_plot_data.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseDataBaseData {
  final supabase = Supabase.instance.client;

  Future userPlots() async {
    final data = await supabase.from('user_plots_new').select();
    return data;
  }

  Future getGeometryData(String id) async {
    final response = await supabase
        .from('user_plots_new')
        .select('ST_AsGeoJSON(the_geom) as the_geom')
        .eq('id', id);
    final data = response.isNotEmpty ? response : 'no id';
    return data;
  }

  Future insertGeometryData(UserPlotData userPlotData) async {
    final response = await supabase
        .from('user_plots_new')
        .insert(userPlotData.toJson());
    return response;
  }

  // Future insertUserPlots() async {
  //   await supabase.rpc(
  //     'insert_user_plots',
  //     params: {
  //       'name': 'Test Plot',
  //       'crop_type': 'Rice',
  //       'notes': 'Test notes',
  //       'geometry':
  //           '{"type":"Polygon","coordinates":[[[80.99926699825852,7.942971679180758],[80.99724899198571,7.93715279598193],[81.00621507048334,7.93715279598193],[81.00414597544506,7.943123475029964],[80.99926699825852,7.942971679180758]]]}',
  //     },
  //   );
  // }
}
