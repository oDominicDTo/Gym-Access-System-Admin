import 'package:flutter/material.dart';

class DeleteDialog {
  final BuildContext context;

  DeleteDialog(this.context);

  Future<void> showDeleteDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure you want to delete?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop(false); // Return false when No is pressed
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
            Navigator.of(context).pop(true); // Return true when Yes is pressed
            },
            ),
          ],
        );
      },
    );
  }
}
