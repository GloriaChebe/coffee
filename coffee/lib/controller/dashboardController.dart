import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class DashboardSummary {
  int totalDonations;
  int pendingApprovals;
  int totalUsers;

  DashboardSummary({
    required this.totalDonations,
    required this.pendingApprovals,
    required this.totalUsers,
  });
}

class DashboardController extends GetxController {
  var summary = Rxn<DashboardSummary>();
  var isLoading = false.obs;

  Future<void> fetchDashboardSummary() async {
    try {
      isLoading(true);
      final response = await http.get(
        Uri.parse('https://sanerylgloann.co.ke/coffeeInn/readStatics.php'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['success'] == 1 && data['data'] != null && data['data'].isNotEmpty) {
          final summaryData = data['data'][0]; // <-- important
          summary.value = DashboardSummary(
            totalDonations: int.tryParse(summaryData['totalOrders'].toString()) ?? 0,
            pendingApprovals: int.tryParse(summaryData['pendingApprovals'].toString()) ?? 0,
            totalUsers: int.tryParse(summaryData['totalUsers'].toString()) ?? 0,
          );
        } else {
          Get.snackbar('Error', 'No dashboard data found');
        }
      } else {
        Get.snackbar('Error', 'Failed to fetch dashboard summary');
      }
    } catch (e) {
      Get.snackbar('Exception', e.toString());
    } finally {
      isLoading(false);
    }
  }
}
