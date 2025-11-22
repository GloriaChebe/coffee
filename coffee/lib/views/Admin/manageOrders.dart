import 'package:coffee/configs/constants.dart';
import 'package:coffee/controller/generalOrdersController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class AdminManageOrdersPage extends StatelessWidget {
  final controller = Get.put(AdminOrdersController());

  AdminManageOrdersPage({super.key});

  String getNextStatus(String currentStatus) {
    switch (currentStatus.toLowerCase()) {
      case 'pending':
        return 'Processing';
      case 'processing':
        return 'Completed';
      default:
        return 'Completed';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Orders',style: TextStyle(color: appwhiteColor),),
        backgroundColor:primaryColor,
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.orders.isEmpty) {
          return const Center(child: Text('No orders found'));
        }

        return RefreshIndicator(
          onRefresh: () => controller.fetchOrders(),
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: controller.orders.length,
            itemBuilder: (context, index) {
              final order = controller.orders[index];

              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(10),
                  title: Text(
                    order.itemName,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Customer: ${order.firstName} ${order.lastName}"),
                      Text("Phone: ${order.phone}"),
                      Text("Ordered on: ${order.timeOrdered}"),
                      const SizedBox(height: 5),
                      Row(
                        children: [
  const Text(
    "Status: ",
    style: TextStyle(fontWeight: FontWeight.bold),
  ),
  Chip(
    label: Text(order.status),
    backgroundColor: 
        order.status.toLowerCase() == "pending"
            ? secondaryColor.withOpacity(0.5)
            : order.status.toLowerCase() == "processing"
                ? Colors.blue.shade300
                : Colors.green.shade300, // completed
  ),
],

                      ),
                    ],
                  ),
                  trailing: order.status.toLowerCase() == 'completed'
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            final newStatus = getNextStatus(order.status);
                            controller.updateOrderStatus(
                                order.ordersID, newStatus);
                          },
                          child: Text(
                            order.status.toLowerCase() == 'pending'
                                ? 'Approve'
                                : 'Complete',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
