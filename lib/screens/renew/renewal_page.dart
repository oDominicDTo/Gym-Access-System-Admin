import 'package:flutter/material.dart';
import 'package:gym_kiosk_admin/widgets/custom_card_button.dart';
import 'member_renew.dart';

class RenewalPage extends StatefulWidget {
  const RenewalPage({Key? key}) : super(key: key);

  @override
  State createState() => _RenewalPageState();
}

class _RenewalPageState extends State<RenewalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Renewal Page',
            style: TextStyle(color: Colors.black, fontFamily: 'Poppins'),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 120.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: SizedBox(
                width: 200,
                height: 300,
                child: CustomCardButton(
                  title: 'Renew Member',
                  icon: Icons.refresh,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RenewMemberPage(),
                      ),
                    );
                  },
                  iconColor: Colors.green, // Set icon color to green
                ),
              ),
            ),
            const SizedBox(width: 16), // Add spacing between buttons
            Expanded(
              child: SizedBox(
                width: 200,
                height: 300,
                child: CustomCardButton(
                  title: 'View Renewal Log',
                  icon: Icons.history,
                  onPressed: () {
                    setState(() {});
                    // Handle view renewal log action
                  },
                  iconColor: Colors.pink,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}