import 'dart:convert';

import 'package:coffee/configs/constants.dart';
import 'package:coffee/views/Item.dart';
import 'package:coffee/views/aboutUs.dart';
import 'package:coffee/views/Admin/admin.dart';
import 'package:coffee/views/contactUs.dart';
import 'package:coffee/views/login.dart';
import 'package:coffee/views/orders.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

class HomePage extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<HomePage> {
  late Future<List<Product>> _futureProducts;
  List<Product> _cartItems = [];
  List<Product> _placedOrders = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _futureProducts = fetchProducts();
  }

  Future<List<Product>> fetchProducts() async {
    final response = await http
        .get(Uri.parse("https://sanerylgloann.co.ke/coffeeInn/readItems.php"));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      List items = [];
      if (jsonData is List) {
        items = jsonData;
      } else if (jsonData is Map) {
        if (jsonData['data'] is List) {
          items = jsonData['data'];
        } else if (jsonData['products'] is List) {
          items = jsonData['products'];
        } else {
          final listVal = jsonData.values.firstWhere(
            (v) => v is List,
            orElse: () => <dynamic>[],
          );
          if (listVal is List) items = listVal;
        }
      }

      final List<Product> products = items
          .map((productJson) => Product.fromJson(Map<String, dynamic>.from(productJson)))
          .toList();

      return products;
    } else {
      throw Exception('Failed to load products');
    }
  }

  void _addToCart(Product product) async {
    final storage = GetStorage();
    final isLoggedIn = storage.read('userID') != null;

    if (!isLoggedIn) {
      final result = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Login Required'),
          content: Text('Please login to add items to cart'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context, true);
                final loginResult = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage())
                );
                if (loginResult == true) {
                  _showQuantityDialog(product);
                }
              },
              child: Text('Login'),
            ),
          ],
        )
      );
      if (result != true) return;
    } else {
      _showQuantityDialog(product);
    }
  }

  void _showQuantityDialog(Product product) {
    TextEditingController quantityController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add to Cart'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Enter Quantity:'),
              SizedBox(height: 10),
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Quantity',
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                int quantity = int.tryParse(quantityController.text) ?? 0;
                if (quantity > 0) {
                  setState(() {
                    for (int i = 0; i < quantity; i++) {
                      _cartItems.add(product);
                    }
                  });
                }
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildDashboard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 80,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                primaryColor,
                primaryColor,
              ],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: FittedBox(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Indulge in our premium coffee blends and treats!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Product>>(
            future: _futureProducts,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                return GridView.builder(
                  padding: EdgeInsets.fromLTRB(12, 12, 12, kBottomNavigationBarHeight + 20),
                  physics: AlwaysScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.72,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        _addToCart(snapshot.data![index]);
                      },
                      child: ProductItem(
                        product: snapshot.data![index],
                        onAddToCart: _addToCart,
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 0
          ? AppBar(
              title: Text(
                "Welcome to coffeeInn!",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              backgroundColor: primaryColor,
              actions: [
                IconButton(
                  icon: Icon(Icons.account_circle_outlined, color: Colors.white, size: 40),
                  onPressed: () async {
                    final storage = GetStorage();
                    final userRole = storage.read('userRole');
                    final isLoggedIn = storage.read('userID') != null;

                    if (isLoggedIn) {
                      if (userRole == '1') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AdminPage()),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      }
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage())
                      );
                    }
                  },
                ),
              ],
            )
          : null,
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildDashboard(),
          Statuspage(),
        ],
      ),
      floatingActionButton: _cartItems.isEmpty
          ? null
          : FloatingActionButton(
              onPressed: () {
              },
              child: Stack(
                children: [
                  Icon(Icons.shopping_cart),
                  Positioned(
                    right: 0,
                    child: CircleAvatar(
                      backgroundColor: Colors.red,
                      radius: 8,
                      child: Text(
                        _cartItems.length.toString(),
                        style: TextStyle(fontSize: 10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: const Color(0xFFFFA000),
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, -3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'Orders',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
        ),
      ),
      drawer: _selectedIndex == 0
          ? Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFA000),
                    ),
                    child: Text(
                      'coffeeInn',
                      style: GoogleFonts.pacifico(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.account_circle),
                    title: Text('Profile'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginPage()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.support_agent),
                    title: Text('Contact Support'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ContactUsPage()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.info),
                    title: Text('About Us'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AboutUsPage()),
                      );
                    },
                  ),
                  Divider(height: 10, thickness: 1.0),
                  ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('Log Out'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                  ),
                ],
              ),
            )
          : null,
    );
  }
}