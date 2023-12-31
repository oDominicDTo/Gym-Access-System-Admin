import 'package:flutter/material.dart';
import 'package:gym_kiosk_admin/screens/add_member.dart';
import 'package:gym_kiosk_admin/screens/feedback/feedback_page.dart';
import 'package:gym_kiosk_admin/screens/home_page.dart';
import 'package:gym_kiosk_admin/screens/management_page.dart';
import 'package:gym_kiosk_admin/screens/member_list_screen.dart';
import 'package:gym_kiosk_admin/widgets/top_navigation_bar.dart';

import '../renew/renewal_page.dart';

class HomeAdminPage extends StatefulWidget {
  final String adminName;

  const HomeAdminPage({Key? key, required this.adminName}) : super(key: key);

  @override
  State createState() => _HomeAdminPageState();
}

class _HomeAdminPageState extends State<HomeAdminPage> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomePage(),
    const Center(child: Text('Welcome to Overview!')),
    const MemberInput(),
    const MemberListScreen(),
    const RenewalPage(),
    const ManagementPage(),
    const FeedbackPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavigationBar(adminName: widget.adminName),
      body: Row(
        children: <Widget>[
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              if (index == 4) {
                setState(() {
                  _selectedIndex = index;
                });
              } else if (index == 7) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/', (Route<dynamic> route) => false);
              } else {
                setState(() {
                  _selectedIndex = index;
                });
              }
            },
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.home_filled),
                label: Text(
                  'Home',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.dashboard),
                label: Text(
                  'Overview',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.person_add),
                label: Text(
                  'Add Member',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.list),
                label: Text(
                  'View Members',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.person),
                label: Text(
                  'Renew',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.build_outlined),
                label: Text(
                  'Management',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.feedback_outlined),
                label: Text(
                  'Feedback',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.logout_rounded),
                label: Text(
                  'Log Out',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: _selectedIndex == 4
                ? Navigator(
              onGenerateRoute: (settings) {
                return MaterialPageRoute(
                  builder: (_) => const RenewalPage(),
                );
              },
            )
                : _selectedIndex == 6
                ? Navigator(
              onGenerateRoute: (settings) {
                return MaterialPageRoute(
                  builder: (_) => const FeedbackPage(),
                );
              },
            )
                : _screens[_selectedIndex],
          ),
        ],
      ),
    );
  }
}