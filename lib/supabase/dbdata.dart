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
    final data = response.isNotEmpty ? response[0]['the_geom'] : null;
    return data;
  }
}
