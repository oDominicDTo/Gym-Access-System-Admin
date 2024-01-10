import 'package:flutter/material.dart';

import '../../widgets/custom_card_button.dart';
import 'checkIn_dialog.dart';


class CheckDialog extends StatelessWidget {
  final Null Function() onCheckInConfirmed;

  const CheckDialog({
    Key? key,
    required this.onCheckInConfirmed,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Check Action'),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomCardButton(
            title: 'Check In',
            onPressed: () {
              Navigator.of(context).pop();
              showDialog(
                context: context,
                builder: (BuildContext context) => CheckInDialog(
                  onMembersSelected: (List<String> value) {},
                  onCheckInConfirmed: onCheckInConfirmed, // Pass the callback here
                ),
              );
            },
            icon: Icons.arrow_circle_right_outlined,
            iconColor: Colors.black,
          ),
          const SizedBox(height: 16), // Adding some spacing between buttons
          CustomCardButton(
            title: 'Check Out',
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icons.arrow_circle_left_outlined,
            iconColor: Colors.black,
          ),
        ],
      ),
    );
  }
}