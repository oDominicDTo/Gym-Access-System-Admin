import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class InsertBlankCard extends StatefulWidget {
  const InsertBlankCard({Key? key}) : super(key: key);

  @override
  State<InsertBlankCard> createState() => _InsertBlankCardState();
}

class _InsertBlankCardState extends State<InsertBlankCard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Please Insert Card Here',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
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