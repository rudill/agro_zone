import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthService {
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

  Future<User?> signIn(String email, String password) async {
    try {
      final AuthResponse res = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
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

  Future<void> signOut() async {
    await supabase.auth.signOut();
  }
}
