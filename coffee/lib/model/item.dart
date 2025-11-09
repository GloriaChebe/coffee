import 'dart:convert';

class DonationResponse {
  final int success;
  final List<DonationItem> data;

  DonationResponse({required this.success, required this.data});

  // Convert JSON string to DonationResponse object
  factory DonationResponse.fromJson(String jsonStr) {
    final Map<String, dynamic> json = jsonDecode(jsonStr);
    final List<dynamic> items = json['data'];

    return DonationResponse(
      success: json['success'],
      data: items.map((item) => DonationItem.fromJson(item)).toList(),
    );
  }
}

class DonationItem {
  final String itemsID;
  final String name;
  final String price;
  final String image;

  DonationItem({
    required this.itemsID,
    required this.name,
    required this.price,
    required this.image,
  });

  // Convert JSON object to DonationItem
  factory DonationItem.fromJson(Map<String, dynamic> json) {
    return DonationItem(
      itemsID: json['itemsID'],
      name: json['name'],
      price: json['price'],
      image: json['image'],
    );
  }
}
