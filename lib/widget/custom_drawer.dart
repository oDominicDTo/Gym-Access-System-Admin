import 'package:flutter/material.dart';
import '../screens/dashboard_screen.dart';
import '../screens/membership_status_screen.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.white24,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // First Image widget
                Image.asset(
                  'assets/images/whole_logo.png', // Provide the path to your first image asset
                  width: 250,
                  height: 200,
                ),
                SizedBox(width: 0), // Add some spacing between the images
                // Second Image widget

              ],
            ),
          ),
          ListTile(
            title: Row(
              children: [
                // Small image for Dashboard
                Image.asset(
                  'assets/images/home_icon.png', // Provide the path to your small image asset
                  width: 24,
                  height: 24,
                ),
                SizedBox(width: 10), // Add some spacing between the image and text
                Text('Dashboard',
                  style: TextStyle(
                    fontFamily: 'Poppins', // Use the Poppins Regular font
                  ),
                ),
              ],
            ),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DashboardScreen()),
              );
            },
          ),
          ListTile(
            title: Row(
              children: [
                // Small image for Membership Status
                Image.asset(
                  'assets/images/graph_icon.png', // Provide the path to your small image asset
                  width: 24,
                  height: 24,
                ),
                SizedBox(width: 10), // Add some spacing between the image and text
                Text('Overview',
                  style: TextStyle(
                    fontFamily: 'Poppins', // Use the Poppins Regular font
                  ),
                ),
              ],
            ),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MembershipStatusScreen(),
                ),
              );
            },
          ),

          ListTile(
            title: Row(
              children: [
                // Small image for Membership Status
                Image.asset(
                  'assets/images/medal_icon.png', // Provide the path to your small image asset
                  width: 24,
                  height: 24,
                ),
                SizedBox(width: 10), // Add some spacing between the image and text
                Text('Membership Status',
                  style: TextStyle(
                    fontFamily: 'Poppins', // Use the Poppins Regular font
                  ),
                ),
              ],
            ),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MembershipStatusScreen(),
                ),
              );
            },
          ),






          ListTile(
            title: Row(
              children: [
                // Small image for Logout
                Image.asset(
                  'assets/images/user_icon.png', // Provide the path to your small image asset
                  width: 24,
                  height: 24,
                ),
                SizedBox(width: 16), // Add some spacing between the image and text
                Text('Log Out',
                  style: TextStyle(
                    fontFamily: 'Poppins', // Use the Poppins Regular font
                  ),
                ),
              ],
            ),
            onTap: () {
              // Implement your log out logic here
              // For example, you can show a confirmation dialog and log out the user
              Navigator.pop(context); // Close the drawer
            },
          ),
        ],
      ),
    );
  }
}