import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class Order {
  final String ordersID;
  final String itemName;
  final String firstName;
  final String lastName;
  final String phone;
  final String status;
  final String timeOrdered;

  Order({
    required this.ordersID,
    required this.itemName,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.status,
    required this.timeOrdered,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      ordersID: json['ordersID'].toString(),
      itemName: json['itemName'] ?? 'N/A',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      phone: json['phoneNo'] ?? '',
      status: json['status'] ?? 'Pending',
      timeOrdered: json['timeOrdered'] ?? '',
    );
  }
}

class AdminOrdersController extends GetxController {
  var orders = <Order>[].obs;
  var isLoading = false.obs;

  final String baseUrl = 'https://sanerylgloann.co.ke/coffeeInn';

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders({String? status}) async {
    try {
      isLoading(true);
      final uri = status == null
          ? Uri.parse('$baseUrl/readOrders.php')
          : Uri.parse('$baseUrl/readOrders.php?status=$status');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == 1) {
          final List list = data['data'];
          orders.value = list.map((e) => Order.fromJson(e)).toList();
        } else {
          orders.clear();
        }
      } else {
        Get.snackbar('Error', 'Failed to fetch orders');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateOrderStatus(String ordersID, String newStatus) async {
    try {
      isLoading(true);
      final response = await http.post(
        Uri.parse('$baseUrl/approve.php'),
        body: {'ordersID': ordersID, 'status': newStatus},
      );

      final data = json.decode(response.body);
      if (data['success'] == 1) {
        Get.snackbar('Success', data['message']);
        fetchOrders(); // Refresh after update
      } else {
        Get.snackbar('Error', data['message']);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }
}
