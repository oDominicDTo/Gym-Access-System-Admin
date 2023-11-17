import 'package:flutter/material.dart';

class HomeAdmin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0), // Set the preferred height of the app bar
        child: AppBar(
          backgroundColor: Colors.white, // Set the background color to white
          elevation: 4, // Add an elevation (shadow)
          titleSpacing: 0, // Remove default spacing around the title

          // Row to hold the logo and title
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15.0, bottom: 12.0, left: 30.0, right: 10.0),
                child: SizedBox(
                  height: 60, // Set the desired height
                  width: 60, // Set the desired width
                  child: Image.asset(
                    'assets/images/binan_logo.png', // Path to your logo image
                    fit: BoxFit.contain, // Adjust the image fit
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  'GYM AND FITNESS CENTER',
                  style: TextStyle(
                    color: Colors.black, // Set the text color to black
                    fontSize: 24,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w100,
                    height: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Your screen content here
          ],
        ),
      ),
    );
  }
}
