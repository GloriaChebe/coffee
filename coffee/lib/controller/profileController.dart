import 'dart:convert';
import 'package:coffee/model/profileModel.dart';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;


class UserProfileController extends GetxController {
  var user = Rxn<UserProfile>();
  var isLoading = false.obs;

  Future<void> fetchUserProfile(String userID) async {
    isLoading.value = true;
    try {
      //print("Fetching user profile for userID: $userID"); 
      final response = await http.get(
        Uri.parse('https://sanerylgloann.co.ke/donorApp/readUser.php?userID=$userID'), 
      );

      // print("Response status: ${response.statusCode}");
      // print("Response body: ${response.body}"); 

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        user.value = UserProfile.fromJson(jsonData);
        //print("User profile loaded: ${user.value}"); 
      } else {
        Get.snackbar('Error', 'Server returned ${response.statusCode}');
      }
    } catch (e) {
      //print("Exception: $e");
      Get.snackbar('Exception', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
