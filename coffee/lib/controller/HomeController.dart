import 'package:get/get.dart';
import 'package:flutter/material.dart';

class HomeController extends GetxController {
  var selectedPage = 0.obs;

  void updateselectedpage(int index) {
    selectedPage.value = index;
  }

  void navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
}