import 'package:flutter/material.dart';
import 'package:gym_kiosk_admin/screens/add_member.dart';
import 'package:gym_kiosk_admin/screens/member_list_screen.dart';
import 'package:gym_kiosk_admin/widgets/top_navigation_bar.dart';

class HomeAdminPage extends StatefulWidget {
  const HomeAdminPage({super.key});

  @override
  State createState() => _HomeAdminPageState();
}

class _HomeAdminPageState extends State<HomeAdminPage> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const Center(child: Text('Welcome to Home!')),
    const Center(child: Text('Welcome to Overview!')),
    const MemberInput(),
    const MemberListScreen(),
    const Center(child: Text('Welcome to Renew')),
    const Center(child: Text('Welcome to Management')),
    const Center(child: Text('Welcome to Feedback')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopNavigationBar(),
      body: Row(
        children: <Widget>[
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              if (index == 7) {
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
                label: Text('Renew',
                  style: TextStyle(fontFamily: 'Poppins'),),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.build_outlined),
                label: Text('Management',
                  style: TextStyle(fontFamily: 'Poppins'),),
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
                label: Text('Log Out',
                  style: TextStyle(fontFamily: 'Poppins'),),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Scaffold(
               // Using the TopNavigationBar widget here
              body: _screens[_selectedIndex],
            ),
          ),
        ],
      ),
    );
  }
}