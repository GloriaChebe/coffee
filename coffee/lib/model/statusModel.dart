import 'package:intl/intl.dart';

class Donation {
  String userID;
  String firstName;
  String lastName;
  String price;
  String name;
  String orderID;
  String itemsID;
  String orderDate;
  String orderTime;
  int quantity;
  String status;
  String timestamp;
  String formattedDate;
  var amount;
  String ordersID;

  Donation({
    required this.userID,
    required this.firstName,
    required this.lastName,
    required this.price,
    required this.name,
    required this.orderID,
    required this.itemsID,
    required this.orderDate,
    required this.orderTime,
    required this.quantity,
    required this.status,
    required this.timestamp,
    required this.ordersID,
    this.amount,
  }) : formattedDate = _formatDate(timestamp);

  static String _formatDate(String ts) {
    try {
      final date = DateTime.parse(ts);
      return DateFormat('dd/MM/yyyy – hh:mm a').format(date);
    } catch (_) {
      return 'N/A';
    }
  }

  factory Donation.fromJson(Map<String, dynamic> item) {
    return Donation(
      userID: item['userID'] ?? '',
      firstName: item['firstName'] ?? '',
      lastName: item['lastName'] ?? '',
      price: item['price']?.toString() ?? '0',
      name: item['name'] ?? '',
      orderID: item['ordersID'] ?? '',
      itemsID: item['itemsID'] ?? '',
      orderDate: item['orderDate'] ?? '',
      orderTime: item['orderTime'] ?? '',
      quantity: int.tryParse(item['quantity'].toString()) ?? 0,
      status: item['status'] ?? '',
      timestamp: item['timestamp'] ?? '',
      amount: item['amount'],
      ordersID: item['ordersID'] ?? '',
    
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userID': userID,
      'firstName': firstName,
      'lastName': lastName,
      'price': price,
      'name': name,
      'ordersID': orderID,
      'itemsID': itemsID,
      'orderDate': orderDate,
      'orderTime': orderTime,
      'quantity': quantity,
      'status': status,
      'timestamp': timestamp,
      'amount': amount,
      'ordersID': ordersID,
    };
  }
}
