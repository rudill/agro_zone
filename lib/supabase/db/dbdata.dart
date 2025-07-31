import 'package:agro_zone/models/user_plot_data.dart';
import 'package:flutter/material.dart';
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

  Future insertUserPlots(
    UserPlotData userPlotData,
    BuildContext context,
  ) async {
    final response = await supabase.rpc(
      'insert_plot',
      params: userPlotData.toJson(),
    );
    if (response != null && response.error != null) {
      throw Exception(response.error!.message);
    }
    return ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('successfully inserted')));
  }
}
