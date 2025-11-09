import 'package:coffee/model/item.dart';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class ItemController extends GetxController {
  var isLoading = true.obs;
  var isUrgentLoading = true.obs;
  var items = <DonationItem>[].obs;
  var urgentItems = <DonationItem>[].obs;
  var filteredItems = <DonationItem>[].obs;
  var selectedCategory = 'All'.obs;

  final String apiUrl = "https://sanerylgloann.co.ke/coffeeInn/readItems.php";
 

 @override// Fetch donation items from the API
  onInit(){
    super.onInit();
    fetchDonationItems();
  }
  Future<void> fetchDonationItems() async {
    try {
      isLoading(true);
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData['success'] == 1) {
          var fetchedItems = (jsonData['data'] as List)
              .map((item) => DonationItem.fromJson(item))
              .toList();

          items.value = fetchedItems;
          filteredItems.value = fetchedItems;
        }
      } else {
        Get.snackbar("Error", "Failed to fetch data: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    } finally {
      isLoading(false);
    }
  }
  // Filter items based on category
  void filterItems(String category) {
    selectedCategory.value = category;
    if (category == 'All') {
      filteredItems.value = items;
    } else {
      filteredItems.value = items.where((item) => item.price == category).toList();
    }
  }

  // Search items
  void searchItems(String query) {
    if (query.isEmpty) {
      filterItems(selectedCategory.value);
    } else {
      filteredItems.value = items.where(
        (item) => item.name.toLowerCase().contains(query.toLowerCase()),
      ).toList();
    }
  }

  
 
}
