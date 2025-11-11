import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:coffee/model/statusModel.dart';

class ReportsController extends GetxController {
  var donations = <Donation>[].obs;
  var isLoading = false.obs;

  /// Fetch all donations for admin report
  Future<void> fetchDonations() async {
    try {
      isLoading(true);
      final response = await http.get(Uri.parse(
          'https://sanerylgloann.co.ke/coffeeInn/readReports.php'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == 1) {
          final List<dynamic> list = data['data'];
          donations.value = list.map((item) {
            return Donation(
              userID: item['userID'] ?? '',
              firstName: item['firstName'] ?? '',
              lastName: item['lastName'] ?? '',
              price: item['price'] ?? '',
              name: item['name'] ?? '',
              orderID: item['ordersID'] ?? '',
              itemsID: item['itemsID'] ?? '',
              orderDate: item['orderDate'] ?? '',
              orderTime: item['orderTime'] ?? '',
              quantity: int.tryParse(item['quantity'].toString()) ?? 0,
              status: item['status'] ?? '',
              timestamp: item['timestamp'] ?? '', ordersID: '',
            );
          }).toList();
        } else {
          Get.snackbar('Info', 'No donations found');
        }
      } else {
        Get.snackbar('Error', 'Failed to fetch donations');
      }
    } catch (e) {
      Get.snackbar('Exception', e.toString());
    } finally {
      isLoading(false);
    }
  }
}
