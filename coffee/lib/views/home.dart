import 'dart:convert';

import 'package:coffee/configs/constants.dart';
import 'package:coffee/views/Item.dart';
import 'package:coffee/views/aboutUs.dart';
import 'package:coffee/views/contactUs.dart';
import 'package:coffee/views/login.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

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
      // response may be a list or an object containing a list, try to discover products list
      List items = [];
      if (jsonData is List) {
        items = jsonData;
      } else if (jsonData is Map) {
        if (jsonData['data'] is List) {
          items = jsonData['data'];
        } else if (jsonData['products'] is List) {
          items = jsonData['products'];
        } else {
          // fallback: take first List value found in the map
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

  void _addToCart(Product product) {
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
                  for (int i = 0; i < quantity; i++) {
                    setState(() {
                      _cartItems.add(product);
                    });
                  }
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
                  icon: Icon(Icons.account_circle_outlined,
                      color: Colors.white, size: 40),
                  onPressed: () {},
                ),
              ],
            )
          : null,
      body: _selectedIndex == 0
          ? Column(
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
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
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
                                  onAddToCart: _addToCart),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            )
          // Temporarily disabled orders page navigation
          // : _selectedIndex == 1
          //     ? OrdersPage(orderedItems: _placedOrders)
          //     : Container(),
          : Container(), // Temporary empty container
      floatingActionButton: _cartItems.isEmpty
          ? null
          : FloatingActionButton(
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) => CartPage(cartItems: _cartItems)),
                // ).then((value) {
                //   setState(() {
                //     _cartItems.removeWhere((item) => value.contains(item));
                //   });
                // });
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
          unselectedItemColor: Colors.grey[700],
          onTap: _onItemTapped,
          backgroundColor: Colors.transparent,
          elevation: 0,
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