import 'package:flutter/material.dart';

class CardButton extends StatelessWidget {
  final String title;
  final Function onPressed;

  const CardButton({super.key,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        onPressed();
      },
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        side: const BorderSide(
          color: Colors.black, // Change the border color as needed
          width: 1.0,
        ),
        padding: EdgeInsets.zero,
      ),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(fontSize: 20.0, color: Colors.black),
          ),
        ),
      ),
    );
  }
}
