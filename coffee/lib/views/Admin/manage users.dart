import 'package:coffee/configs/constants.dart';
import 'package:coffee/views/Admin/admin.dart' show AdminPage;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class ManageUsersPage extends StatefulWidget {
  @override
  _ManageUsersPageState createState() => _ManageUsersPageState();
}

class _ManageUsersPageState extends State<ManageUsersPage> {
  late Future<List<Map<String, String>>> _usersFuture;
  List<Map<String, String>> _allUsers = [];
  List<Map<String, String>> _filteredUsers = [];
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _usersFuture = _fetchUsers();
  }

  Future<List<Map<String, String>>> _fetchUsers() async {
    final url = Uri.parse('https://sanerylgloann.co.ke/coffeeInn/totalUsers.php');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['data'] != null && data['data'] is List) {
          final List<dynamic> users = data['data'];
          final userList = users.map((user) {
            return {
              'id': (user['userID'] ?? 'N/A').toString(),
              'name': '${user['firstName'] ?? ''} ${user['lastName'] ?? ''}'.trim(),
              'email': (user['email'] ?? 'N/A').toString(),
              'contacts': (user['phoneNo'] ?? 'N/A').toString(),
              'role': (user['role'] == '1') ? 'Admin' : 'User',
            };
          }).toList();

          _allUsers = userList;
          _filteredUsers = userList;
          return userList;
        } else {
          throw Exception('Invalid response structure: "data" key not found');
        }
      } else {
        throw Exception('Failed to load users: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching users: $e');
      return [];
    }
  }

  void _filterUsers(String query) {
    final filtered = _allUsers.where((user) {
      final lowerQuery = query.toLowerCase();
      return user['name']!.toLowerCase().contains(lowerQuery) ||
          user['email']!.toLowerCase().contains(lowerQuery) ||
          user['contacts']!.toLowerCase().contains(lowerQuery) ||
          user['role']!.toLowerCase().contains(lowerQuery);
    }).toList();

    setState(() {
      _filteredUsers = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color:appwhiteColor),
          onPressed: () {
            Get.to(() => AdminPage());
          },
        ),
        title: !_isSearching
            ? Text('Users', style: TextStyle(color: appwhiteColor))
            : TextField(
                controller: _searchController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search users...',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
                onChanged: _filterUsers,
              ),
        backgroundColor: primaryColor,
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search, color: Colors.white),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                _searchController.clear();
                _filteredUsers = _allUsers;
              });
            },
          )
        ],
      ),
      body: FutureBuilder<List<Map<String, String>>>(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No users found.'));
          } else {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('User ID', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Email', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Contacts', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Role', style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                rows: _filteredUsers.map((user) {
                  return DataRow(cells: [
                    DataCell(Text(user['id'] ?? 'N/A')),
                    DataCell(Text(user['name'] ?? 'N/A')),
                    DataCell(Text(user['email'] ?? 'N/A')),
                    DataCell(Text(user['contacts'] ?? 'N/A')),
                    DataCell(Text(user['role'] ?? 'N/A')),
                  ]);
                }).toList(),
              ),
            );
          }
        },
      ),
    );
  }
}
