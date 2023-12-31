import 'package:flutter/material.dart';
import 'package:gym_kiosk_admin/screens/add_member.dart';
import 'package:gym_kiosk_admin/screens/member_list_screen.dart';

class HomeSuperAdminPage extends StatefulWidget {
  final String adminName;
  const HomeSuperAdminPage({super.key, required this.adminName});

  @override
  State createState() => _HomeSuperAdminPageState();
}

class _HomeSuperAdminPageState extends State<HomeSuperAdminPage> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const Center(child: Text('Welcome to SuperAdmin')),
    const Center(child: Text('Welcome to Overview!')),
    const MemberInput(),
    const MemberListScreen(),
    const Center(child: Text('Welcome to Feedback')),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 4,
          titleSpacing: 0,
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 30.0,
                  bottom: 25.0,
                  left: 2.0,
                  right: 2.0,
                ),
                child: SizedBox(
                  height: 40,
                  width: 300,
                  child: Image.asset(
                    'assets/images/whole_logo.png',
                    fit: BoxFit.contain,
                  ),
                ),

              ),
            ],
          ),

        ),
      ),
      body: Row(
        children: <Widget>[
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              if (index == 5) { // Check if "Log Out" button is clicked
                // Perform logout actions here
                Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
                // This will navigate to the home route ("/") and remove all routes from the stack
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
            child: _screens[_selectedIndex],
          ),
        ],
      ),
    );
  }
}
