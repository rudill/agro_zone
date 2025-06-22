import 'package:agro_zone/models/dbdata.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// const supabaseUrl = 'https://iddmbqmmwnglamblsyjt.supabase.co';
// const supabaseKey = String.fromEnvironment(
//   'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlkZG1icW1td25nbGFtYmxzeWp0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTA0NDE1NTgsImV4cCI6MjA2NjAxNzU1OH0.VPPFor_D3fS8cvibkj8Uqs5OilL9XIfBNrW5i8sfsGw',
// );

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://iddmbqmmwnglamblsyjt.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlkZG1icW1td25nbGFtYmxzeWp0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTA0NDE1NTgsImV4cCI6MjA2NjAxNzU1OH0.VPPFor_D3fS8cvibkj8Uqs5OilL9XIfBNrW5i8sfsGw',
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _future = Supabase.instance.client.from('user_plots_new').select();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: FutureBuilder(
          future: _future,
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
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: ((context, index) {
                final name = data[index];
                return ListTile(title: Text(name['name'].toString()));
              }),
            );
          },
        ),
      ),
    );
  }
}
//Lgg*XM+E&s34b!q
//Lgg*XM+E&s34b!q