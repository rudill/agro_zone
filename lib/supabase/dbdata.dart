import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseDataBaseData {
  final supabase = Supabase.instance.client;

  Future getName() async {
    final data = await supabase.from('user_plots_new').select();
    return data;
  }
}
