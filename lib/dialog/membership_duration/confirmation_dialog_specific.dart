import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final int days;
  final Function(bool) onConfirmation;

  const ConfirmationDialog({
    Key? key,
    required this.days,
    required this.onConfirmation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String operation = days >= 0 ? 'Add' : 'Subtract';
    String operationType = days >= 0 ? 'to' : 'from';
    String message = days == 0
        ? 'Please add or subtract days first.'
        : 'Are you sure you want $operation $days days $operationType specific members?';

    return AlertDialog(
      title: const Text(
        'Confirmation',
        style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 20),
        textAlign: TextAlign.center,
      ),
      content: Text(
        message,
        style: const TextStyle(color: Colors.black, fontFamily: 'Poppins', fontSize: 15),
        textAlign: TextAlign.center,
      ),

      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
            onConfirmation(true); // Confirm the action
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green, // Set background color to black
          ),
          child: const Text('Yes', style: TextStyle(color: Colors.white, fontFamily: 'Poppins')),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
            onConfirmation(false); // Cancel the action
          },
          style: ElevatedButton.styleFrom(
            side: const BorderSide(color: Colors.red), // Set border color to black
          ),
          child: const Text('No', style: TextStyle(color: Colors.black, fontFamily: 'Poppins')),
        ),
      ],
    );
  }
}