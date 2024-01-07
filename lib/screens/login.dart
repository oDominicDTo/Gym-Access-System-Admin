
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';





class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Left Side
          Expanded(
            flex: 5,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/gym_login.png'), // Replace with your image path
                  fit: BoxFit.cover, // Adjust the fit based on your needs
                ),
              ),
              child: Center(
                child: Container(
                  width: 800, // Width of the inner box holding text fields and button
                  height: 800, // Height of the inner box holding text fields and button
                  color: Colors.black.withOpacity(0.7), // Adjust the opacity based on your preference
                  padding: const EdgeInsets.all(20.0),

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const Center(
                        child: Text(
                          'WELCOME TO',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 35,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Image.asset(
                        'assets/images/binan_logo.png',
                        width: 150,
                        height: 150,
                        fit: BoxFit.contain,
                      ),
                      const Center(
                        child: Text(
                          'Biñan Gym & Fitness Center',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 443,
                        height: 95,
                        child: Center(
                          child: Text(
                            ' Get ready to transform your \nbody, mind, and spirit.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Right Side
          Expanded(
            flex: 5,

            child: Container(
              color: Colors.white, // Change to your desired background color
              child: Center(
                child: Container(
                  width: 400, // Width of the inner box holding text fields and button
                  height: 500, // Height of the inner box holding text fields and button
                  color: Colors.white, // Change to your desired container color
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.black, // Change to your desired text color
                          fontSize: 25,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 5.0),
                      const Text(
                        'or use NFC',
                        style: TextStyle(
                          color: Colors.black, // Change to your desired text color
                          fontSize: 20,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Lottie.asset(
                        'assets/animation/insert_card.json',
                        width: 100,
                        height: 100,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(
                        height: 45,
                        child: TextField(
                          decoration: InputDecoration(

                            labelText: 'Username', labelStyle: const TextStyle(color: Colors.black38, fontFamily: 'Poppins'),
                            prefixIcon: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 17.0), // Adjust the padding as needed
                              child: Icon(
                                Icons.person, // Change to your desired icon
                                color: Colors.black38,
                              ),
                            ),
                            border: OutlineInputBorder( borderSide: const BorderSide(width: 1, color: Color(0xFFA3A3A3)),
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15.0),
                      SizedBox(
                        height: 45,
                        child: TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password', labelStyle: const TextStyle(color: Colors.black38, fontFamily: 'Poppins'),
                            prefixIcon: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 17.0), // Adjust the padding as needed
                              child: Icon(
                                Icons.lock, // Change to your desired icon
                                color: Colors.black38,
                              ),
                            ),
                            border: OutlineInputBorder( borderSide: const BorderSide(width: 1, color: Color(0xFFA3A3A3)),
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15.0),
                      ElevatedButton(
                        onPressed: () {
                          // TODO: Implement login functionality
                          // Validate credentials and navigate to the next screen
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          minimumSize: const Size(304, 52),
                        ),
                        child: const Text(
                          'Log In',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: 'Poppins',
                            height: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
