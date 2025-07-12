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

  //   Future insertUserPlots() async {
  //     await supabase
  //     .from('user_plots_new')
  //     .insert({
  //       'name':'ruvi',
  //       'crop_type':'apple',
  //       'notes':'Drawn from GeoJSON'
  //     })
  //   }
}
