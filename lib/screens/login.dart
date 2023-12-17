import 'package:flutter/material.dart';


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
              color: Colors.black, // Replace with your image or design
              child: Center(
                child: Container(
                  width: 800, // Width of the inner box holding text fields and button
                  height: 500, // Height of the inner box holding text fields and button
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
                            fontSize: 40,
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
                            fontSize: 45,
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
                              fontSize: 25,
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
                  height: 300, // Height of the inner box holding text fields and button
                  color: Colors.white, // Change to your desired container color
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(
                        height: 49,
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Username',
                            border: OutlineInputBorder( borderSide: const BorderSide(width: 1, color: Color(0xFFA3A3A3)),
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                       SizedBox(
                         height: 49,
                         child: TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder( borderSide: const BorderSide(width: 1, color: Color(0xFFA3A3A3)),
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                      ),
                       ),
                      const SizedBox(height: 30.0),
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
                            minimumSize: const Size(404, 52),
                        ),
                        child: const Text(
                          'Log In',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
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


