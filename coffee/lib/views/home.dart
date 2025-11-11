import 'dart:convert';
import 'package:coffee/configs/constants.dart';
import 'package:coffee/views/Admin/admin.dart';
import 'package:coffee/views/Item.dart';
import 'package:coffee/views/cart.dart';
import 'package:coffee/views/orders.dart';
import 'package:coffee/views/profile.dart';
import 'package:coffee/views/login.dart';
import 'package:coffee/views/contactUs.dart';
import 'package:coffee/views/aboutUs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Product>> _futureProducts;
  List<Product> _cartItems = [];
  int _selectedIndex = 0;
  String role = '';

  @override
  void initState() {
    super.initState();
    _futureProducts = fetchProducts();

    final storage = GetStorage();
    role = storage.read('role')?.toString() ?? '';
  }

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(
        Uri.parse("https://sanerylgloann.co.ke/coffeeInn/readItems.php"));
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

      return items
          .map((productJson) =>
              Product.fromJson(Map<String, dynamic>.from(productJson)))
          .toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  void _addToCart(Product product) {
    _showQuantityDialog(product);
  }

  void _showQuantityDialog(Product product) {
    final quantityController = TextEditingController(text: '1');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add to Cart'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text('Enter Quantity:'),
              const SizedBox(height: 10),
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Quantity',
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                int quantity = int.tryParse(quantityController.text) ?? 0;
                if (quantity > 0) {
                  setState(() {
                    _cartItems.addAll(List.filled(quantity, product));
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          '$quantity ${product.name} added to cart!'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                }
                Navigator.of(context).pop();
              },
              child: const Text('Order Now'),
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
              colors: [primaryColor, primaryColor],
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
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
        Expanded(
          child: FutureBuilder<List<Product>>(
            future: _futureProducts,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                return GridView.builder(
                  padding: EdgeInsets.fromLTRB(
                      12, 12, 12, kBottomNavigationBarHeight + 80),
                  physics: const AlwaysScrollableScrollPhysics(),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.72,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return ProductItem(
                      product: snapshot.data![index],
                      onAddToCart: _addToCart,
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
              title: const Text(
                "Welcome to coffeeInn!",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              backgroundColor: primaryColor,
              actions: role == '1'
                  ? [
                      IconButton(
                        icon: const Icon(Icons.admin_panel_settings,
                            color: Colors.white, size: 40),
                        onPressed: () {
                          Get.to(() => AdminPage());
                        },
                      ),
                    ]
                  : [],
            )
          : null,
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildDashboard(),
          StatusPage(), // your orders/history page
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _cartItems.isEmpty
            ? null
            : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartPage(
                      cartItems: _cartItems,
                      onOrderPlaced: () {
                        setState(() => _cartItems.clear());
                      },
                    ),
                  ),
                );
              },
        backgroundColor:
            _cartItems.isEmpty ? Colors.grey : primaryColor,
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Icon(Icons.shopping_cart),
            if (_cartItems.isNotEmpty)
              Positioned(
                right: 0,
                top: 0,
                child: CircleAvatar(
                  backgroundColor: secondaryColor,
                  radius: 8,
                  child: Text(
                    _cartItems.length.toString(),
                    style: const TextStyle(fontSize: 10),
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius:
              const BorderRadius.vertical(top: Radius.circular(16)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, -3),
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
                      color: primaryColor,
                    ),
                    child: Text(
                      'coffeeInn',
                      style: GoogleFonts.pacifico(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.account_circle),
                    title: const Text('Profile'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ProfileDetailsPage()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.support_agent),
                    title: const Text('Contact Support'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ContactUsPage()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.info),
                    title: const Text('About Us'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AboutUsPage()),
                      );
                    },
                  ),
                  const Divider(height: 10, thickness: 1.0),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Log Out'),
                    onTap: () {
                      GetStorage().erase();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
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
