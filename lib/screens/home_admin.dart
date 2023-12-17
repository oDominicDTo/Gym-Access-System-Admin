import 'package:flutter/material.dart';
import 'package:gym_kiosk_admin/screens/add_member.dart'; // Import the AddMemberScreen widget
import 'package:gym_kiosk_admin/screens/view_member.dart';

class HomeAdminPage extends StatefulWidget {
  const HomeAdminPage({super.key});


  @override
  State createState() => _HomeAdminPageState();
}

class _HomeAdminPageState extends State<HomeAdminPage> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const Center(child: Text('Welcome to Admin Dashboard!')),
    const MemberInput(),
    const MemberListScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
      ),
      body: Row(
        children: <Widget>[
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.selected,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.dashboard),
                label: Text('Dashboard'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.person_add),
                label: Text('Add Member'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.list),
                label: Text('View Members'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: _screens[_selectedIndex],
          ),
        ],
      ),
    );
  }
}
