import 'package:flutter/material.dart';
import 'package:gym_kiosk_admin/screens/logs/newm_data_table.dart';
import 'package:gym_kiosk_admin/screens/logs/renew_data_table.dart';
import 'package:gym_kiosk_admin/widgets/custom_card_button.dart';


class LogPage extends StatefulWidget {
  const LogPage({Key? key}) : super(key: key);

  @override
  State createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> {
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
                  title: 'View New Member Log',
                  icon: Icons.nature_people_outlined,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NewMemberLogPage(),
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
                  title: 'View Admin Renewal Log',
                  icon: Icons.history,
                  onPressed: () {
                    setState(() {
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdminRenewalLogPage(),
                      ),
                    );
                  },
                  iconColor: Colors.pink, // Set icon color
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}