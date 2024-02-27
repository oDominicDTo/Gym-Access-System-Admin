import 'package:flutter/material.dart';
import 'package:gym_kiosk_admin/screens/add_member.dart';
import 'package:gym_kiosk_admin/screens/feedback/feedback_page.dart';
import 'package:gym_kiosk_admin/screens/home_page.dart';
import 'package:gym_kiosk_admin/dialog/admin/management_page_admin.dart';
import 'package:gym_kiosk_admin/screens/member_list_screen.dart';
import 'package:gym_kiosk_admin/screens/membership_analytics.dart';
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
    const MembershipStatusChartPage(),
    MemberInput(adminName: ''),
    const MemberListScreen(),
    RenewalPage(adminName: ''),
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
              if (index == 7) {
                Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
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
                label: Text('Home'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.dashboard),
                label: Text('Overview'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.person_add),
                label: Text('Add Member'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.list),
                label: Text('View Members'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.person),
                label: Text('Renew'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.build_outlined),
                label: Text('Management'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.feedback_outlined),
                label: Text('Feedback'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.logout_rounded),
                label: Text('Log Out'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Navigator(
              onGenerateRoute: (settings) {
                return MaterialPageRoute(
                  builder: (context) => _screens[_selectedIndex],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
