import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class InsertBlankCard extends StatefulWidget {
  const InsertBlankCard({Key? key}) : super(key: key);

  @override
  State<InsertBlankCard> createState() => _InsertBlankCardState();
}

class _InsertBlankCardState extends State<InsertBlankCard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NFC Card'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedTextKit(
              animatedTexts: [
                TyperAnimatedText(
                  'Place Blank Card on NFC Scanner',
                  textStyle: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Set the text color
                    backgroundColor: Colors.white, // Set a background color
                  ),
                  speed: const Duration(milliseconds: 50),
                ),
              ],
              totalRepeatCount: 1,
            ),
            const SizedBox(height: 20),
            Lottie.asset(
              'assets/animation/insert_card.json',
              width: 500,
              height: 500,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}
