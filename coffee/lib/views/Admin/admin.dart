import 'package:coffee/configs/constants.dart';
import 'package:coffee/controller/dashboardController.dart';
import 'package:coffee/controller/reportsController.dart';

import 'package:coffee/model/statusModel.dart' show Donation;
import 'package:coffee/views/Admin/manage%20users.dart';
import 'package:coffee/views/Admin/manageItems.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

// Initialize DashboardController
final DashboardController dashboardController = Get.put(DashboardController());

class AdminPage extends StatefulWidget {
  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  void initState() {
    super.initState();
    dashboardController.fetchDashboardSummary(); // Fetch stats on load
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: Column(
          children: [
            // Statistics Card
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Obx(() {
                    if (dashboardController.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final summary = dashboardController.summary.value;
                    if (summary == null) {
                      return const Center(child: Text('No data available'));
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Statistics',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildStatisticItem(
                              title: 'Total Orders',
                              value: summary.totalDonations.toString(),
                              icon: Icons.volunteer_activism,
                              color: Colors.green,
                            ),
                            _buildStatisticItem(
                              title: 'Pending Approvals',
                              value: summary.pendingApprovals.toString(),
                              icon: Icons.pending_actions,
                              color: Colors.orange,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildStatisticItem(
                              title: 'Total Users',
                              value: summary.totalUsers.toString(),
                              icon: Icons.people,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),

            // Admin action cards
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                padding: const EdgeInsets.all(16),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildAdminCard(
                    context,
                    title: 'Manage Orders',
                    icon: Icons.volunteer_activism,
                    onTap: () {
                      Get.to(() => CategoriesAdmin());
                    },
                  ),
                  _buildAdminCard(
                    context,
                    title: 'Manage Items',
                    icon: Icons.inventory,
                    onTap: () {
                      Get.to(() => CategoriesAdmin());
                    },
                  ),
                  _buildAdminCard(
                    context,
                    title: 'Users',
                    icon: Icons.people,
                    onTap: () {
                       Get.to(() => ManageUsersPage());
                    },
                  ),
                ],
              ),
            ),

            // Reports section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Donations Report',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () async {
                              final ReportsController controller =
                                  Get.put(ReportsController());
                              await controller.fetchDonations();
                              await generateItemDonationsPdf(
                                  controller.donations);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            icon: const Icon(Icons.card_giftcard,
                                color: Colors.white),
                            label: const Text('Item Donations',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Statistic item widget
  Widget _buildStatisticItem({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: secondaryColor.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              title,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
          ],
        ),
      ],
    );
  }

  // Admin card widget
  Widget _buildAdminCard(BuildContext context,
      {required String title,
      required IconData icon,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: secondaryColor),
            const SizedBox(height: 16),
            Text(
              title,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// PDF generation for item donations
Future<void> generateItemDonationsPdf(List<Donation> donations) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.MultiPage(
      build: (pw.Context context) => [
        pw.Text('Item Donations Report',
            style:
                pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 20),
        pw.Table.fromTextArray(
          border: pw.TableBorder.all(),
          cellStyle: const pw.TextStyle(fontSize: 10),
          headerStyle: pw.TextStyle(
  fontWeight: pw.FontWeight.bold,
  fontSize: 12,
),

          headers: [
            'Orders ID',
            'User ID',
            'Name',
            'Item',
            'Quantity',
            'Status',
            'Time Donated'
          ],
          data: donations.map((donation) {
            return [
              donation.orderID,
              donation.userID,
              '${donation.firstName} ${donation.lastName}',
              donation.name,
              donation.quantity.toString(),
              donation.status,
              donation.timestamp,
            ];
          }).toList(),
        ),
      ],
    ),
  );

  await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save());
}
