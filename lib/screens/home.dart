// main.dart

import 'package:flutter/material.dart';
import 'package:gym_kiosk_admin/widget/add_new_member_form.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeAdmin(),
    );
  }
}

class HomeAdmin extends StatefulWidget {
  @override
  _HomeAdminState createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
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
                  height: 50,
                  width: 300,
                  child: Image.asset(
                    'assets/images/whole_logo.png',
                    fit: BoxFit.contain,
                  ),
                ),

              ),
            ],
          ),
          actions: [
           // Display the search bar in the AppBar
          ],
        ),
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
            labelType: NavigationRailLabelType.all,
            destinations: [
              NavigationRailDestination(
                icon: Icon(Icons.home_filled),
                label: Text('Home',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.add_box_rounded),
                label: Text('Add',
                  style: TextStyle(fontFamily: 'Poppins'),),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.bar_chart),
                label: Text('Overview',
                  style: TextStyle(fontFamily: 'Poppins'),),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.stars_rounded),
                label: Text('Membership',
                  style: TextStyle(fontFamily: 'Poppins'),),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.person),
                label: Text('Profile',
                  style: TextStyle(fontFamily: 'Poppins'),),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings),
                label: Text('Log Out',
                  style: TextStyle(fontFamily: 'Poppins'),),
              ),
            ],
          ),
          VerticalDivider(thickness: 1, width: 1),
          // Content displayed on the right side based on the selected index
          Expanded(
            child: Center(
              child: _getContent(_selectedIndex),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (

            ) {
          // Add your FloatingActionButton logic here
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _getContent(int index) {
    switch (index) {
      case 0:
        return Center(child: Text('Home Content'));
      case 1:
        return AddNewMemberForm();
      case 2:
        return Center(child: Text('3'));
      case 4:
        return Center(child: Text('4'));
      case 5:
        return Center(child: Text('5'));
      case 6:
        return Center(child: Text('6'));
      default:
        return Center(child: Text('Invalid Content'));
    }
  }
}
