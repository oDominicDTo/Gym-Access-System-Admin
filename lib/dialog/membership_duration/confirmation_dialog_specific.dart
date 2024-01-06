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
      title: Text('Confirmation'),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
            onConfirmation(true); // Confirm the action
          },
          child: Text('Yes'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
            onConfirmation(false); // Cancel the action
          },
          child: Text('No'),
        ),
      ],
    );
  }
}