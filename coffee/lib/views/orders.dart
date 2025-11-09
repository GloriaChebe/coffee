import 'package:coffee/configs/constants.dart';
import 'package:coffee/controller/ordersController.dart';
import 'package:coffee/widgets/status.dart';
import 'package:flutter/material.dart';


import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get_storage/get_storage.dart';

import 'package:step_progress_indicator/step_progress_indicator.dart' as step_progress;
final DonationController donationController=DonationController();
var store= GetStorage();
class Statuspage extends StatefulWidget {
   var orderID;
   var currentStatus;
   var itemName;
   var quantity;
   
   var pickupDate;
   TimeOfDay? orderTime;

  Statuspage({
    this.orderID,
     this.currentStatus,
     this.itemName,
    this.quantity,
     
    this.pickupDate,
    this.orderTime,
  });

  @override
  StatusPage createState() => StatusPage();
}

class StatusPage extends State<Statuspage> {
  
  bool _showFullDetails = false; // Toggle for showing full details

  @override
  Widget build(BuildContext context) {
    final userID = store.read('userID');
    if (userID != null && userID.toString().isNotEmpty) {
      donationController.fetchPersonalDonations(userID.toString());
    }

    return Scaffold(
     appBar: AppBar(
  automaticallyImplyLeading: false,

  actions: [
    TextButton(
      onPressed: () {
       // Get.to(navPage());
      },
      child: Text(
        'Back',
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    ),
  ],
  foregroundColor: appwhiteColor,
  title: Text('Donation Status', style: TextStyle(color: Colors.white)),
  backgroundColor: primaryColor,
),

      body: Obx(()=> ListView.builder(
          itemCount: donationController.userDonations.length,
          itemBuilder:   (context, index) {
            final donation = donationController.userDonations[index];

            final bool showFull = donationController.openingStatus.length > index
                ? donationController.openingStatus[index]
                : false;

            DateTime? parsedDate;
            final orderDateStr = donation.orderDate;
            if (orderDateStr != null && orderDateStr.toString().isNotEmpty) {
              try {
                parsedDate = DateTime.tryParse(orderDateStr.toString());
              } catch (_) {
                parsedDate = null;
              }
            }

            TimeOfDay? parsedTime;
            final orderTimeStr = donation.orderTime;
            if (orderTimeStr != null && orderTimeStr.toString().isNotEmpty && orderTimeStr.toString().contains(':')) {
              final parts = orderTimeStr.toString().split(':');
              if (parts.length >= 2) {
                final h = int.tryParse(parts[0]) ?? 0;
                final m = int.tryParse(parts[1]) ?? 0;
                parsedTime = TimeOfDay(hour: h, minute: m);
              }
            }

            final statusStr = donation.status ?? '';

            return Column(
              children: [
                StatusCard(
                  ordersID: donation.orderID ?? '',
                  currentStatus: statusStr,
                  itemName: donation.name ?? '',
                  quantity: donation.quantity,
                  orderDate: parsedDate,
                  orderTime: parsedTime,
                  showFullDetails: showFull,
                  onToggleDetails: () {
                    donationController.setOpeningStatus(index, !showFull);
                  },
                ),
                SizedBox(height: 20),

                Obx(()=>Visibility(
                    visible: showFull,
                    child: SizedBox(
                      height: 160,
                      
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: step_progress.StepProgressIndicator(
                                      currentStep: _getStepIndex(statusStr) + 1,
                                      totalSteps: 4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                  
                            Container(
                              padding: EdgeInsets.all(16),
                              margin: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey[300]!),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _getStatusDescription(statusStr),
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },),
      )
     
    );
  }

  int _getStepIndex(String status) {
  switch (status) {
    case 'Pending':
      return 0;
    case 'Processing':
      return 1;
    case 'Completed':
      return 2;
   
    default:
      return 0;
  }
}


  String _getStatusDescription(String status) {
    switch (status) {
      case 'Pending':
        return 'Your donation request has been submitted and is awaiting administrator review. We will process it as soon as possible.';
      case 'Processing':
        return 'Your donation has been approved. Please follow the pickup instructions or await further communication from our team.';
     
      case 'Completed':
        return 'Your donation process has been completed. Thank you for your generosity and support!';
     
      default:
        return 'Status information not available. Please contact administrator for more details.';
    }
  }
}