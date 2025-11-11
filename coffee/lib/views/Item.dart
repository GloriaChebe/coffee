import 'package:flutter/material.dart';

/// Product model
class Product {
  final String? id;
  final String name;
  final double price;
  final String description;
  final String imageFileName;
  final String imageUrl;

  Product({
    this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.imageFileName,
    required this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'] ??
        json['itemsID'] ??
        json['itemID'] ??
        json['itemsId'] ??
        json['ItemsID'] ??
        json['items_id'];

    final rawImage = json['imageUrl'] ??
        json['image'] ??
        json['imageFileName'] ??
        json['image_url'] ??
        json['img'] ??
        '';

    String imageUrl = rawImage.toString().trim();
    if (imageUrl.isNotEmpty && !imageUrl.startsWith('http')) {
      while (imageUrl.startsWith('/')) {
        imageUrl = imageUrl.substring(1);
      }
      const base = 'https://sanerylgloann.co.ke/coffeeInn/coffees/';
      imageUrl = base + imageUrl;
    }

    return Product(
      id: rawId?.toString(),
      name: (json['name'] ?? json['item_name'] ?? '').toString(),
      price: double.tryParse((json['price'] ?? '0').toString()) ?? 0.0,
      description: (json['description'] ?? '').toString(),
      imageFileName: (json['imageFileName'] ?? '').toString(),
      imageUrl: imageUrl,
    );
  }
}

/// ProductItem widget
class ProductItem extends StatelessWidget {
  final Product product;
  final void Function(Product) onAddToCart;

  const ProductItem({
    super.key,
    required this.product,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image
          AspectRatio(
            aspectRatio: 4 / 3,
            child: product.imageUrl.isNotEmpty
                ? Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(child: CircularProgressIndicator());
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        child: const Center(
                          child: Icon(Icons.broken_image,
                              size: 40, color: Colors.grey),
                        ),
                      );
                    },
                  )
                : Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: Icon(Icons.image_not_supported,
                          size: 40, color: Colors.grey),
                    ),
                  ),
          ),

          // Info + Add button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  'Ksh ${product.price.toStringAsFixed(2)}',
                  style: TextStyle(color: Colors.brown.shade700),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown.shade700,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () => onAddToCart(product),
                    child: const Text('Add'),
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
