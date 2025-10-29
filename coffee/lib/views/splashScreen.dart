import 'package:coffee/configs/constants.dart';
import 'package:coffee/views/home.dart';
import 'package:coffee/views/login.dart';
import 'package:coffee/views/register.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Image.asset(
            '/images/Espresso.png',
            fit: BoxFit.cover,
            width: MediaQuery.of(context)
                .size
                .width, //Setting the width to match screen width
            height: MediaQuery.of(context).size.height,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'CoffeeInn',
                  style: GoogleFonts.pacifico(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(height: 50),
                Column(
                  children: [
                    Text(
                      'Welcome to Our Coffee Shop',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Discover the Finest Coffee Blends!',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Let's Go!",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: secondaryColor, // Button color
                  ),
                  child: Text(
                    'Get Started',
                    style: TextStyle(
                      fontSize: 20,
                      color: appwhiteColor
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

