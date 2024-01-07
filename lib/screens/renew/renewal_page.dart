import 'package:flutter/material.dart';
import 'package:gym_kiosk_admin/screens/renew/renew_log.dart';
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                CustomCardButton(
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
                  iconColor: Colors.blue, // Set icon color
                ),
                CustomCardButton(
                  title: 'View Renewal Log',
                  icon: Icons.history,
                  onPressed: () {
                    setState(() {
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RenewalLogPage(),
                      ),
                    );
                  },
                  iconColor: Colors.pink, // Set icon color
                ),
            ],
          ),
        ),
      ),
    );
  }
}
