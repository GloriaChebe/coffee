import 'dart:convert';

import 'package:coffee/model/statusModel.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class DonationController extends GetxController {
  var userDonations = <Donation>[].obs;
  var isLoadingUserDonations = false.obs;
  var openingStatus = <bool>[].obs;

  /// Collapse all cards except the tapped one
  void setOpeningStatus(int index, bool val) {
    for (int i = 0; i < openingStatus.length; i++) {
      openingStatus[i] = false;
    }
    openingStatus[index] = val;
    openingStatus.refresh();
  }

  /// Fetch personal donations for a user
  Future<void> fetchPersonalDonations(String userID) async {
    try {
      isLoadingUserDonations(true);
      final response = await http.get(
        Uri.parse(
            'https://sanerylgloann.co.ke/coffeeInn/readPersonalOrders.php?userID=$userID'),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['success'] == 1 && jsonData['data'] != null) {
          final List<dynamic> data = jsonData['data'];
          userDonations.value =
              data.map((item) => Donation.fromJson(item)).toList();

          // Initialize all cards as collapsed
          openingStatus.assignAll(List.filled(userDonations.length, false));
        } else {
          userDonations.clear();
          openingStatus.clear();
          Get.snackbar('Info', 'No donations found.');
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
