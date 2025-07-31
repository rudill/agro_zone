import 'package:agro_zone/screens/login/signup.dart';
import 'package:agro_zone/screens/map_view.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://iddmbqmmwnglamblsyjt.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlkZG1icW1td25nbGFtYmxzeWp0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTA0NDE1NTgsImV4cCI6MjA2NjAxNzU1OH0.VPPFor_D3fS8cvibkj8Uqs5OilL9XIfBNrW5i8sfsGw',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Signup());
  }
}

//Lgg*XM+E&s34b!q
//Lgg*XM+E&s34b!q

//SfZMwBaxcK1TZT2I
