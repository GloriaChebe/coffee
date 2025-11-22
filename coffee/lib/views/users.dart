import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
  });

  factory User.fromJson(Map<String, dynamic> j) {
    return User(
      id: (j['id'] ?? j['user_id'] ?? '').toString(),
      firstName: (j['first_name'] ?? j['firstName'] ?? j['fname'] ?? '').toString(),
      lastName: (j['last_name'] ?? j['lastName'] ?? j['lname'] ?? '').toString(),
      email: (j['email'] ?? '').toString(),
      phone: (j['phone'] ?? j['phoneNo'] ?? j['phone_no'] ?? '').toString(),
    );
  }
}

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final Uri _uri = Uri.parse('https://sanerylgloann.co.ke/coffeeInn/readUsers.php');
  bool _loading = true;
  String? _error;
  List<User> _users = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final resp = await http.get(_uri).timeout(const Duration(seconds: 15));
      if (resp.statusCode != 200) {
        throw Exception('HTTP ${resp.statusCode}');
      }

      final body = resp.body.trim();
      final decoded = jsonDecode(body);

      List items = [];
      if (decoded is List) {
        items = decoded;
      } else if (decoded is Map) {
        
        if (decoded['data'] is List) {
          items = decoded['data'];
        } else if (decoded['users'] is List) {
          items = decoded['users'];
        } else {
          // try to find first List value
          final listVal = decoded.values.firstWhere(
            (v) => v is List,
            orElse: () => <dynamic>[],
          );
          if (listVal is List) items = listVal;
        }
      } else {
        throw Exception('Unexpected response format');
      }

      final parsed = items.map((e) {
        if (e is Map<String, dynamic>) return User.fromJson(e);
        return User.fromJson(Map<String, dynamic>.from(e));
      }).toList();

      setState(() {
        _users = parsed;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        backgroundColor: Colors.brown.shade800,
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : (_error != null)
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          children: [
                            Text('Error: $_error', style: const TextStyle(color: Colors.red)),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: _load,
                              child: const Text('Retry'),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
                            )
                          ],
                        ),
                      )
                    ],
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: _users.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final u = _users[i];
                      final initials = ((u.firstName.isNotEmpty ? u.firstName[0] : '') +
                          (u.lastName.isNotEmpty ? u.lastName[0] : '')).toUpperCase();
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.brown.shade700,
                          child: Text(initials, style: const TextStyle(color: Colors.white)),
                        ),
                        title: Text('${u.firstName} ${u.lastName}'),
                        subtitle: Text('${u.email}\n${u.phone}', maxLines: 2, overflow: TextOverflow.ellipsis),
                        isThreeLine: true,
                        onTap: () {
                          // optional: show details or use in app
                        },
                      );
                    },
                  ),
      ),
    );
  }
}