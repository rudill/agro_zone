import 'package:agro_zone/models/dbdata.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const supabaseUrl = 'https://iddmbqmmwnglamblsyjt.supabase.co';
const supabaseKey = String.fromEnvironment(
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlkZG1icW1td25nbGFtYmxzeWp0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTA0NDE1NTgsImV4cCI6MjA2NjAxNzU1OH0.VPPFor_D3fS8cvibkj8Uqs5OilL9XIfBNrW5i8sfsGw',
);

Future<void> main() async {
  try {
    await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
    print('connected to supabase');
  } catch (e) {
    print('error connecting to supabase');
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: FutureBuilder(
          future: SupabaseDataBaseData().getName(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error'));
            }
            final data = snapshot.data as List<dynamic>;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final name = data[index]['name'];
                return ListTile(title: Text(name));
              },
            );
          },
        ),
      ),
    );
  }
}
//Lgg*XM+E&s34b!q
//Lgg*XM+E&s34b!q