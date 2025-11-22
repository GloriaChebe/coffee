import 'dart:convert';
import 'package:coffee/configs/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

class CheckoutPage extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final double total;
  final VoidCallback? onOrderSuccess;

  const CheckoutPage({super.key, required this.items, required this.total, this.onOrderSuccess});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  bool _loading = false;
  String _status = '';

  // Show dialog to enter phone and confirm amount (amount is fixed to widget.total)
  void _showMpesaDialog() {
    final phoneController = TextEditingController();
    final storage = GetStorage();
    final defaultPhone = storage.read('phone')?.toString() ?? '';
    if (defaultPhone.isNotEmpty) phoneController.text = defaultPhone;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Mpesa Payment'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Amount to pay: Ksh ${widget.total.toStringAsFixed(2)}'),
              const SizedBox(height: 12),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone (07XXXXXXXX)',
                ),
                inputFormatters: [
                FilteringTextInputFormatter.digitsOnly, 
                 LengthLimitingTextInputFormatter(10),   // Limit to 10 digits
  ],
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                final phone = phoneController.text.trim();
                Navigator.pop(context);
                _submitOrder(phone);
              },
              child: const Text('Pay'),
            ),
          ],
        );
      },
    );
  }

  // Post order to DB (createOrders.php) with itemID, userID, quantity, status
  Future<void> _submitOrder(String phone) async {
    if (phone.isEmpty) {
      setState(() => _status = 'Please enter a phone number');
      return;
    }

    setState(() {
      _loading = true;
      _status = 'Processing order...';
    });

    final storage = GetStorage();
    final userId = storage.read('userID')?.toString() ?? storage.read('ID')?.toString() ?? '0';

    if (userId == '0') {
      setState(() => _status = 'User ID not found. Please log in again.');
      setState(() => _loading = false);
      return;
    }

    try {
      // Loop through items and insert each one
      for (var item in widget.items) {
        final itemId = item['id']?.toString() ?? '';
        final quantity = item['quantity']?.toString() ?? '1';

        if (itemId.isEmpty) {
          setState(() => _status = 'Item ID is missing. Cannot proceed.');
          setState(() => _loading = false);
          return;
        }

        print('Sending: itemsID=$itemId, userID=$userId, quantity=$quantity, status=pending');

        final response = await http.post(
          Uri.parse('https://sanerylgloann.co.ke/coffeeInn/createOrders.php'),
          body: {
            'itemsID': itemId,
            'userID': userId,
            'quantity': quantity,
            'status': 'pending',
          },
        );

        print('Response status: ${response.statusCode}, body: ${response.body}');

        if (response.statusCode == 200) {
          try {
            final resp = jsonDecode(response.body);
            if (resp is! Map || (resp['success'] != 1)) {
              setState(() => _status = 'Failed to save order: ${response.body}');
              setState(() => _loading = false);
              return;
            }
          } catch (e) {
            setState(() => _status = 'Invalid JSON response: ${response.body}');
            setState(() => _loading = false);
            return;
          }
        } else {
          setState(() => _status = 'Server error: ${response.statusCode}');
          setState(() => _loading = false);
          return;
        }
      }

      // All orders posted successfully
      setState(() => _status = 'Order placed successfully');
      widget.onOrderSuccess?.call();
      Future.delayed(const Duration(milliseconds: 400), () {
        Navigator.popUntil(context, (route) => route.isFirst);
      });
    } catch (e) {
      setState(() => _status = 'Error: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  ...widget.items.map((it) {
                    return ListTile(
                      title: Text(it['name']?.toString() ?? ''),
                      subtitle: Text('Ksh ${it['price']} x ${it['quantity']}'),
                      trailing: Text('Ksh ${(double.parse(it['price'].toString()) * int.parse(it['quantity'].toString())).toStringAsFixed(2)}'),
                    );
                  }),
                  const Divider(),
                  ListTile(
                    title: const Text('Total'),
                    trailing: Text('Ksh ${widget.total.toStringAsFixed(2)}'),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            if (_status.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(_status, style: const TextStyle(color: Colors.red)),
              ),
            SizedBox(
              width: double.infinity,
              child:ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: primaryColor, 
    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  onPressed: _loading ? null : _showMpesaDialog,
  child: _loading
      ? const SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
        )
      : const Text(
          'Confirm & Pay (Mpesa)',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
            ),
          ],
        ),
      ),
    );
  }
}