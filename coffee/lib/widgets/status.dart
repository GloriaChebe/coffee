import 'package:coffee/configs/constants.dart';
import 'package:flutter/material.dart';


class StatusCard extends StatelessWidget {
  final String ordersID;
  final String currentStatus;
  final String itemName;
  final int quantity;
  
  final DateTime? orderDate;
  final TimeOfDay? orderTime;
  final bool showFullDetails;
  final VoidCallback onToggleDetails;

  StatusCard({
    required this.ordersID,
    required this.currentStatus,
    required this.itemName,
    required this.quantity,
  
    this.orderDate,
    this.orderTime,
    required this.showFullDetails,
    required this.onToggleDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: secondaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order ID: $ordersID',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(currentStatus),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    currentStatus,
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Item Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Item: $quantity x $itemName',
                  style: TextStyle(fontSize: 16),
                ),
                GestureDetector(
                  onTap: onToggleDetails,
                  child: Icon(
                    showFullDetails ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    size: 32,
                    color: appwhiteColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),

            // Pickup Option
           
            // Scheduled For
            SizedBox(height: 8),
            Text(
              'Scheduled For: ${_buildScheduledText()}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  String _buildScheduledText() {
   
      if (orderDate != null && orderTime != null) {
        return '${orderDate!.day}/${orderDate!.month}/${orderDate!.year} at ${_formatTime(orderTime!)}';
      } else {
        return 'N/A';
      }
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final period = time.period == DayPeriod.am ? "AM" : "PM";
    return '${hour}:${time.minute.toString().padLeft(2, '0')} $period';
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'Processing':
        return Colors.green;
     
      case 'Completed':
        return Colors. blue;
      default:
        return Colors.grey;
    }
  }
}
