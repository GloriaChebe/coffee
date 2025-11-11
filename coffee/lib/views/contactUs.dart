import 'package:coffee/configs/constants.dart';
import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

class ContactUsPage extends StatelessWidget {
  
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        automaticallyImplyLeading: true,foregroundColor: appwhiteColor,
        elevation: 0,
        title: Text(
          "Contact Us",
          style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
        ),
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            
            // Contact Information Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildContactCard(
                      context,
                      Icons.phone,
                      "Call Us",
                      "+254758964415",
                      Colors.green[400]!,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildContactCard(
                      context,
                      Icons.email_outlined,
                      "Email Us",
                      "ochengobenji@gmail.com",
                      Colors.orange[400]!,
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 24),
            
            // Form Title
           
            
            
            
            // Contact Form
            
            
            
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
  
  Widget _buildContactCard(BuildContext context, IconData icon, String title, String content, Color color) {
    return GestureDetector(
      onTap: () async {
        if (title == "Call Us") {
          final Uri phoneUri = Uri(scheme: 'tel', path: content);
          try {
            await launchUrl(phoneUri);
          } catch (e) {
            print("Error: $e");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Unable to open phone dialer: $e"),
                backgroundColor: Colors.red[400],
              ),
            );
          }
        } else if (title == "Email Us") {
          final Uri emailUri = Uri(
            scheme: 'mailto',
            path: content,
          );
          try {
            await launchUrl(emailUri);
          } catch (e) {
            print("Error: $e");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Unable to open email app: $e"),
                backgroundColor: Colors.red[400],
              ),
            );
          }
        }
      },
      child: Card(
       
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 28,
                ),
              ),
              SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 6),
              Text(
                content,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}