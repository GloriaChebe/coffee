import 'package:coffee/configs/constants.dart';
import 'package:flutter/material.dart';
import 'package:coffee/views/Item.dart';
import 'package:coffee/views/checkout.dart';

class CartPage extends StatefulWidget {
  final List<Product> cartItems;
  final VoidCallback? onOrderPlaced;

  const CartPage({super.key, required this.cartItems, this.onOrderPlaced});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Map<String, _AggregatedItem> aggregated;

  @override
  void initState() {
    super.initState();
    aggregated = _aggregate(widget.cartItems);
  }

  /// Aggregate identical products into quantities
  Map<String, _AggregatedItem> _aggregate(List<Product> items) {
    final map = <String, _AggregatedItem>{};
    for (var p in items) {
      // Use id + name + price as key to avoid duplicates
      final key = '${p.id ?? ''}::${p.name}::${p.price}';
      if (map.containsKey(key)) {
        map[key]!.quantity += 1;
      } else {
        map[key] = _AggregatedItem(product: p, quantity: 1);
      }
    }
    return map;
  }

  double get total {
    return aggregated.values
        .fold(0.0, (sum, a) => sum + (a.product.price * a.quantity));
  }

  void _onCheckout() {
    final items = aggregated.values
        .map((a) => {
              'id': a.product.id ?? '',
              'name': a.product.name,
              'price': a.product.price,
              'quantity': a.quantity,
            })
        .toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CheckoutPage(
          items: items,
          total: total,
          onOrderSuccess: () {
            widget.onOrderPlaced?.call();
            Navigator.popUntil(context, (route) => route.isFirst);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = aggregated.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        backgroundColor:primaryColor
      ),
      body: list.isEmpty
          ? const Center(child: Text('Your cart is empty'))
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: list.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final a = list[index];
                      return ListTile(
                        leading: CircleAvatar(
                          radius: 28,
                          child: Text(
                            a.product.name.isNotEmpty
                                ? a.product.name[0].toUpperCase()
                                : '?',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(a.product.name),
                        subtitle:
                            Text('Ksh ${a.product.price.toStringAsFixed(2)} x ${a.quantity}'),
                        trailing: Text(
                            'Ksh ${(a.product.price * a.quantity).toStringAsFixed(2)}'),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          Text('Ksh ${total.toStringAsFixed(2)}',
                              style: const TextStyle(fontSize: 18)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _onCheckout,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.brown.shade700,
                          ),
                          child: const Text('Proceed to Checkout',style: TextStyle(color: appwhiteColor),),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class _AggregatedItem {
  final Product product;
  int quantity;
  _AggregatedItem({required this.product, required this.quantity});
}
