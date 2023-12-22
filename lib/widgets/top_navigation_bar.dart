import 'package:flutter/material.dart';

class TopNavigationBar extends StatelessWidget implements PreferredSizeWidget {
  const TopNavigationBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
              left: 20.0,
              right: 8.0, // Increased right padding for some space between logo and text
            ),
            child: Row(
              children: [
                SizedBox(
                  height: 40,
                  width: 40, // Adjust the size as needed
                  child: Image.asset(
                    'assets/images/binan_logo.png', // Your logo image asset
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 8), // Space between logo and text
                const Text(
                  'Gym and Fitness Center',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Poppins',
                    fontSize: 16, // Adjust the font size as needed
                    fontWeight: FontWeight.bold, // Customize the font weight
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: Container()), // To push items to the right side
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.black, // Customize the color as needed
            ),
            onPressed: () {
              // Implement settings functionality here
            },
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.notifications,
                  color: Colors.black, // Customize the color as needed
                ),
                onPressed: () {
                  // Implement notifications functionality here
                },
              ),
              Positioned(
                top: 7,
                right: 7,
                child: Container(
                  width: 12,
                  height: 12,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red, // Badge color
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              )
            ],
          ),
          Container(
            width: 1,
            height: 24,
            color: Colors.grey, // Divider color
            margin: const EdgeInsets.symmetric(horizontal: 12),
          ),
          const Text(
            "Santos Enoque",
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Poppins',
              fontSize: 16// Customize the color as needed
            ),
          ),
          const SizedBox(width: 16), // Adjust the spacing as needed
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.5), // Customize the color as needed
              borderRadius: BorderRadius.circular(30),
            ),
            child: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person_outline,
                color: Colors.black, // Customize the icon color as needed
              ),
            ),
          ),
          const SizedBox(width: 16), // Adjust the spacing as needed
        ],
      ),
      iconTheme: const IconThemeData(color: Colors.grey), // Customize icon color
    );
  }
}
