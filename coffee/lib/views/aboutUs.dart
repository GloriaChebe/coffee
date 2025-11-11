import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
        backgroundColor: const Color(0xFFFFA000),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Coffee Shop',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFFFA000), 
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Welcome to our coffeeInn, your one-stop destination for the finest coffee from around the world. Our mission is to provide our customers with the highest quality coffee, sourced ethically and sustainably.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade800, 
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Location:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFFFA000),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Address: Kimathi Street, Nairobi City Center, Kenya',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade800, 
                ),
              ),
             
            ],
          ),
        ),
      ),
    );
  }
}