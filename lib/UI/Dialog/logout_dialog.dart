import 'package:flutter/material.dart';

class LogOutDialog {
  final BuildContext context;

  LogOutDialog(this.context);

  Future<void> showLogOutDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure you want to log out?'),
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
