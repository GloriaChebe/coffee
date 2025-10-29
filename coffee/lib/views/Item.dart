import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Combined Product model + ProductItem widget in one file.
/// Replace both product.dart and Item.dart usages with this single file.
/// Update imports elsewhere to: import 'package:coffee/views/Item.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageFileName; // raw filename from API
  final String imageUrl; // full constructed URL

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageFileName,
    required this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final rawImage = (json['image'] ?? json['image_name'] ?? json['img'] ?? '').toString();
    const base = 'https://sanerylgloann.co.ke/coffeeInn/coffees/';
    final fullUrl = rawImage.isNotEmpty ? (base + rawImage) : '';

    if (kDebugMode) {
      // helpful when debugging on device
      debugPrint('Product.fromJson -> image file: $rawImage, url: $fullUrl');
    }

    return Product(
      id: (json['id'] ?? json['item_id'] ?? '').toString(),
      name: (json['name'] ?? json['title'] ?? 'Unnamed').toString(),
      description: (json['description'] ?? json['desc'] ?? '').toString(),
      price: double.tryParse((json['price'] ?? json['cost'] ?? '0').toString()) ?? 0.0,
      imageFileName: rawImage,
      imageUrl: fullUrl,
    );
  }
}

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
          // Image area
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
                      debugPrint('Image.network error: $error for ${product.imageUrl}');
                      return Container(
                        color: Colors.grey[200],
                        child: const Center(child: Icon(Icons.broken_image, size: 40, color: Colors.grey)),
                      );
                    },
                  )
                : Container(
                    color: Colors.grey[200],
                    child: const Center(child: Icon(Icons.image_not_supported, size: 40, color: Colors.grey)),
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
                  '\$${product.price.toStringAsFixed(2)}',
                  style: TextStyle(color: Colors.brown.shade700),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown.shade700,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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