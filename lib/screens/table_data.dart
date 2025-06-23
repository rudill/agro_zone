import 'package:agro_zone/supabase/dbdata.dart';
import 'package:flutter/material.dart';

class TableData extends StatefulWidget {
  const TableData({super.key});

  @override
  State<TableData> createState() => _TableDataState();
}

class _TableDataState extends State<TableData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: SupabaseDataBaseData().getName(),
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
    );
  }
}
