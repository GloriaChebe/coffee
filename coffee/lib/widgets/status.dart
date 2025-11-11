import 'package:flutter/material.dart';
import 'package:coffee/configs/constants.dart';

class StatusCard extends StatelessWidget {
  final String donationId;
  final String currentStatus;
  final String itemName;
  final int quantity;
  final String price;
  final String formattedDate;
  final bool showFullDetails;
  final VoidCallback onToggleDetails;

  const StatusCard({
    Key? key,
    required this.donationId,
    required this.currentStatus,
    required this.itemName,
    required this.quantity,
    required this.price,
    required this.formattedDate,
    required this.showFullDetails,
    required this.onToggleDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: GestureDetector(
        onTap: onToggleDetails,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: secondaryColor.withOpacity(0.1),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Order ID + Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order ID: $donationId',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getStatusColor(currentStatus),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      currentStatus,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Item + quantity
              Text(
                'Item: $quantity x $itemName',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),

              // Price
              Text(
                'Price: KES $price',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),

              // Ordered on
              Text(
                'Ordered On: $formattedDate',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'processing':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
