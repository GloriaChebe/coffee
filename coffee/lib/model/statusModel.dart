import 'package:flutter/material.dart';

class Donation {
   String userID;
   String firstName;
   String lastName;
   String price;
   String name;
   String orderID;
   String itemsID;
   //String address;
   
   String orderDate;
   String orderTime;
  int quantity;
   String status;
  
  String timestamp;
  var amount;

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
    this.amount,
  });

  // Convert Donation object to JSON for API requests
  // Map<String, String> toJson() {
  //   return {
  //     'userID': userID,
  //      'firstName': firstName,
  //     'lastName': lastName,
  //     'category': category,
  //     'name': name,
  //     'donationsID': donationsID,
  //     'itemsID': itemsID,
  //     'address': address,
  //     'donationMethod': deliveryMethod,
  //     'preferredDate': preferredDate,
  //     'preferredTime': preferredTime,
  //     'quantity': quantity.toString(),
  //     'status': status,
  //     'comments': comments,
  //   };
  // }
}