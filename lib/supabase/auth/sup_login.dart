import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseLogin {
  final supabase = Supabase.instance.client;

  Future<User?> login(String email, String password, String userName) async {
    try {
      final AuthResponse res = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {'username': userName},
      );
      return res.user;
    } on AuthException catch (e) {
      print('Auth error: ${e.message}');
      return null;
    } catch (e) {
      print('Unknown error: $e');
      return null;
    }
  }
}
