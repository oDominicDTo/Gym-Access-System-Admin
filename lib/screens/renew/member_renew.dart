import 'package:flutter/material.dart';
import 'package:gym_kiosk_admin/screens/renew/select_member.dart';

import '../../widgets/custom_card_button.dart';


class RenewMemberPage extends StatelessWidget {
  const RenewMemberPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Renew Membership'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomCardButton(
              title: 'Select Member',
              icon: Icons.list_alt,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MemberSelectionPage(),
                  ),
                );
              },
              iconColor: Colors.blue,
            ),
            const SizedBox(height: 16.0),
            CustomCardButton(
              title: 'Scan Member NFC',
              icon: Icons.nfc,
              onPressed: () {
                // Handle logic for scanning NFC
                // Navigate to the NFC scanning page for renewal
              },
              iconColor: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}
