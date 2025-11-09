import 'dart:convert';
import 'package:coffee/model/statusModel.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;


class DonationController extends GetxController {
  var donations = <Donation>[].obs;         // For all donations (e.g. admin)
  var userDonations = <Donation>[].obs;     // For personal (donor) donations

  var isLoading = false.obs;
  var isLoadingUserDonations = false.obs;

  var openingStatus = <bool>[].obs;

  /// Updates which card is open, ensuring only one is open at a time
  void setOpeningStatus(int index, bool val) {
    for (int i = 0; i < openingStatus.length; i++) {
      openingStatus[i] = false;
    }
    openingStatus[index] = val;
    openingStatus.refresh();
  }

  /// Fetch donations filtered by status (for admin/general view)
  Future<void> fetchDonations(String status) async {
    try {
      isLoading(true);

      final response = await http.get(
        Uri.parse('https://sanerylgloann.co.ke/donorApp/readDonations.php?status=$status'),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['success'] == 1) {
          final List<dynamic> data = jsonData['data'];

          donations.value = data.map((item) {
            return Donation(
              userID: item['userID'] ?? '',
              firstName: item['firstName'] ?? '',
              lastName: item['lastName'] ?? '',
              price: item['price'] ?? '',
              name: item['name'] ?? '',
              orderID: item['orderID'] ?? '',
              itemsID: item['itemsID'] ?? '',
              //address: item['address'] ?? '',
             // deliveryMethod: item['deliveryMethod'] ?? '',
              orderDate: item['orderDate'] ?? '',
              orderTime: item['orderTime'] ?? '',
              quantity: int.tryParse(item['quantity'].toString()) ?? 0,
              status: item['status'] ?? '',
              timestamp: item['timestamp'] ?? '',
            );
          }).toList();

        } else {
          Get.snackbar('Error', 'No data found');
        }
      } else {
        Get.snackbar('Error', 'Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Exception', e.toString());
    } finally {
      isLoading(false);
    }
  }

  /// Fetch personal donations for the logged-in donor
  Future<void> fetchPersonalDonations(String userID) async {
    try {
      isLoadingUserDonations(true);

      final response = await http.get(
        Uri.parse('https://sanerylgloann.co.ke/coffeeInn/readPersonalOrders.php?userID=$userID'),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['success'] == 1) {
          final List<dynamic> data = jsonData['data'];

          userDonations.value = data.map((item) {
            return Donation(
              userID: item['userID'] ?? '',
              firstName: item['firstName'] ?? '',
              lastName: item['lastName'] ?? '',
              price: item['price'] ?? '',
              name: item['name'] ?? '',
              orderID: item['ordersID'] ?? '',
              itemsID: item['itemsID'] ?? '',
             // address: item['address'] ?? '',
              //deliveryMethod: item['deliveryMethod'] ?? '',
              orderDate: item['orderDate'] ?? '',
              orderTime: item['orderTime'] ?? '',
              quantity: int.tryParse(item['quantity'].toString()) ?? 0,
              status: item['status'] ?? '',
              
              timestamp: item['timestamp'] ?? '',
            );
          }).toList();
          print(response.body);

          // Initialize opening status for each item (all collapsed initially)
          openingStatus.assignAll(List.filled(userDonations.length, false));
        } else {
          Get.snackbar('Error', 'No data found');
        }
      } else {
        Get.snackbar('Error', 'Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Exception', e.toString());
    } finally {
      isLoadingUserDonations(false);
    }
  }
}
