import 'package:engineer/models/sintering_model.dart';
import 'package:engineer/models/user_model.dart';
import 'package:engineer/services/authenticate_api.dart';
import 'package:engineer/services/form_all_api.dart';
import 'package:flutter/material.dart';

class ramming3screen extends StatefulWidget {
  const ramming3screen({super.key});

  @override
  State<ramming3screen> createState() => _ramming3screenState();
}

class _ramming3screenState extends State<ramming3screen> {
  UserModel user = UserModel(); //เรียกใช้ api user สำหรับ user
  AuthenticateApi authenticateApi = AuthenticateApi(); // เรียกใช้ modul api

//ส่วนของ list
  final ApiService _apiService = ApiService(); // เรียกใช้ modul api
  Future<List<ListItem>>? _sinteringItems;

  void initState() {
    super.initState();
    _sinteringItems =
        _apiService.fetchListItem('25'); // ดึงข้อมูล FormID ของตัวเอง
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('The condition before Installation'),
      ),
      body: FutureBuilder<List<ListItem>>(
        future: _sinteringItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No items found.'));
          }

          final items = snapshot.data ?? [];
          if (items.isEmpty) {
            return const Center(child: Text('No type names available.'));
          }

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                title: Text(
                  item.typeName ?? 'Unknown Type Name',
                  style: const TextStyle(fontSize: 16),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
