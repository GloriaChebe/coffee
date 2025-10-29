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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "SEND US A MESSAGE",
                style: TextStyle(
                  color: Colors.grey[800],
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            
            SizedBox(height: 12),
            
            // Contact Form
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    
                      SizedBox(height: 16),
                    
                      // subject
                      TextField(
                        controller: _subjectController,
                        decoration: InputDecoration(
                          labelText: "Subject",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.indigo[600]!, width: 2),
                          ),
                          prefixIcon: Icon(Icons.label, color: Colors.indigo[400]),
                          filled: true,
                          fillColor: Colors.grey[100],
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: 16),
                    
                      // Message Field
                      TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          labelText: "Your Message",
                          //hintText: "Tell us how we can help you...",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.indigo[600]!, width: 2),
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(bottom: 80),
                            child: Icon(Icons.message, color: Colors.indigo[400]),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        ),
                        maxLines: 5,
                      ),
                      SizedBox(height: 24),
                    
                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            final subject = _subjectController.text;
                            final message = _messageController.text;
                    
                            if (subject.isEmpty || message.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Please fill in all fields"),
                                  backgroundColor: Colors.red[400],
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            } else {
                              try {
                                final storage = GetStorage();
                                final userID = storage.read("userID") ?? '';

                                if (userID.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("User ID not found. Please log in again."),
                                      backgroundColor: Colors.red[400],
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                  return;
                                }

                                final response = await http.post(
                                  Uri.parse('https://sanerylgloann.co.ke/donorApp/createMessage.php?'),
                                  body: {
                                    'userID': userID,
                                    'subject': subject,
                                    'message': message,
                                  },
                                );
                    
                                if (response.statusCode == 200) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Row(
                                        children: [
                                          Icon(Icons.check_circle, color: Colors.white),
                                          SizedBox(width: 12),
                                          Text("Message sent successfully!"),
                                        ],
                                      ),
                                      backgroundColor: Colors.green[600],
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                  _subjectController.clear();
                                  _messageController.clear();
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Failed to send message. Please try again."),
                                      backgroundColor: Colors.red[400],
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("An error occurred: $e"),
                                    backgroundColor: Colors.red[400],
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            }
                          },
                          child: Text(
                            "Submit Message",
                            style: TextStyle(
                              color: appwhiteColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
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