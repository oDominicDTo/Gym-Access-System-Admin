import 'package:flutter/material.dart';

class SaveDialog {
  final BuildContext context;

  SaveDialog(this.context);

  Future<void> showSaveDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure you want to save?'),
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
