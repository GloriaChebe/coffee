// import 'dart:convert';
// import 'package:coffee/model/dashbordModel.dart';
// import 'package:http/http.dart' as http;


// class ApiService {
//   static const String baseUrl = "https://yourapi.com";

//   // Fetch dashboard summary
//   static Future<DashboardSummary?> getDashboardSummary() async {
//     try {
//       final response = await http.get(Uri.parse("$baseUrl/dashboard_summary.php"));
//       if (response.statusCode == 200) {
//         final jsonData = jsonDecode(response.body);
//         return DashboardSummary.fromJson(jsonData);
//       } else {
//         print("Failed to load dashboard summary");
//         return null;
//       }
//     } catch (e) {
//       print("Error: $e");
//       return null;
//     }
//   }
// }
