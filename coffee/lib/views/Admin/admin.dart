import 'package:coffee/configs/constants.dart';
import 'package:flutter/material.dart';

class AdminPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        backgroundColor: primaryColor,
      ),
      body: GridView.count(
        padding: EdgeInsets.all(24),
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _buildAdminTile(
            context,
            'Manage Products',
            Icons.coffee,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ManageProductsPage())
            )
          ),
          // _buildAdminTile(
          //   context,
          //   'Manage Orders', 
          //   Icons.shopping_bag,
          //   () => Navigator.push(
          //     context,
          //     MaterialPageRoute(builder: (_) => ManageOrdersPage())
          //   )
          // ),
          // _buildAdminTile(
          //   context,
          //   'Manage Users',
          //   Icons.people,
          //   () => Navigator.push(
          //     context,
          //     MaterialPageRoute(builder: (_) => UsersPage())
          //   )
          // ),
          // Add more admin functions as needed
        ],
      )
    );
  }

  Widget _buildAdminTile(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: primaryColor),
            SizedBox(height: 16),
            Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class ManageProductsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Products'),
        backgroundColor: primaryColor,
      ),
      body: Center(
        child: Text('Products Management'),
      ),
    );
  }
}