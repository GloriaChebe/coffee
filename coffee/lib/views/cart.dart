// import 'dart:convert';
// import 'package:coffee_shop/screens/dashboard_app.dart';
// import 'package:coffee_shop/screens/product.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class CartPage extends StatefulWidget {
//   final List<Product> cartItems;

//   const CartPage({Key? key, required this.cartItems}) : super(key: key);

//   @override
//   _CartPageState createState() => _CartPageState();
// }

// class _CartPageState extends State<CartPage> {
//   bool _orderPlaced = false;

//   Future<void> _placeOrder(BuildContext context) async {

//     final List<Map<String, dynamic>> orderData = widget.cartItems.map((item) {
//       return {
//         'product_id': item.id,
//         'product_name': item.name,
//         'quantity': 1, 
//       };
//     }).toList();

//     final response = await http.post(
//       Uri.parse('http://www.nattiee.com/coffee/createorder.php'),
//       body: json.encode(orderData),
//       headers: {'Content-Type': 'application/json'},
//     );

//     if (response.statusCode == 200) {
      
//       setState(() {
//         _orderPlaced = true;
//       });

//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text('Order Placed Successfully!'),
//             actions: <Widget>[
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                   setState(() {
//                     widget.cartItems.clear();
//                   });
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => DashboardScreen()),
//                   );
//                 },
//                 child: Text('OK'),
//               ),
//             ],
//           );
//         },
//       );
//     } else {

//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text('Failed to Place Order'),
//             content: Text('Please try again later.'),
//             actions: <Widget>[
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: Text('OK'),
//               ),
//             ],
//           );
//         },
//       );
//     }
//   }

//   void _removeItem(Product item) {
//     setState(() {
//       widget.cartItems.remove(item);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Cart'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: widget.cartItems.length,
//               itemBuilder: (context, index) {
//                 final item = widget.cartItems[index];
//                 return ListTile(
//                   title: Text(item.name),
//                   subtitle: Text('Price: \$${item.price}'),
//                   leading: Image.network(
//                     'http://www.nattiee.com/coffee/images/${item.image}',
//                     width: 50,
//                     height: 50,
//                     fit: BoxFit.cover,
//                   ),
//                   trailing: IconButton(
//                     icon: Icon(Icons.delete),
//                     onPressed: () {
//                       _removeItem(item);
//                     },
//                   ),
//                 );
//               },
//             ),
//           ),
//           _orderPlaced
//               ? Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Text(
//                     'Order Placed Successfully!',
//                     style: TextStyle(fontSize: 20, color: Colors.green),
//                   ),
//                 )
//               : ElevatedButton(
//                   onPressed: () => _placeOrder(context),
//                   child: Text('Place Order'),
//                 ),
//         ],
//       ),
//     );
//   }
// }