import 'dart:async';

import 'package:flutter/material.dart';



class TopNavigationBar extends StatefulWidget implements PreferredSizeWidget {
  final String adminName; // Add adminName parameter

  const TopNavigationBar({Key? key, required this.adminName}) : super(key: key);

  @override
  State createState() => _TopNavigationBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _TopNavigationBarState extends State<TopNavigationBar> {
  late DateTime _currentTime;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTime());
  }

  void _updateTime() {
    setState(() {
      _currentTime = DateTime.now();
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = '${_currentTime.day}/${_currentTime
        .month}/${_currentTime.year}';
    String formattedTime =
        '${_get12HourFormat(_currentTime.hour)}:${_currentTime.minute.toString()
        .padLeft(2, '0')}:${_currentTime.second.toString().padLeft(
        2, '0')} ${_formatAmPm(_currentTime)}';


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

          Expanded(child: Container()),
          const SizedBox(width: 8), // Space between profile and date/time
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                formattedDate,
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'Poppins',
                  fontSize: 12, // Adjust the font size as needed
                ),
              ),
              Text(
                formattedTime,
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'Poppins',
                  fontSize: 12, // Adjust the font size as needed
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Text(
                    widget.adminName,
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'Poppins',
                      fontSize: 16, // Adjust the font size as needed
                    ),
                  ),
                  const SizedBox(width: 8),
                  const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person_outline,
                      color: Colors
                          .black, // Customize the icon color as needed
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.black, // Customize the color as needed
            ),
            onPressed: () {},
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
          const SizedBox(width: 16), // Adjust the spacing as needed
        ],
      ),
      iconTheme: const IconThemeData(
          color: Colors.grey), // Customize icon color
    );
  }

  String _formatAmPm(DateTime time) {
    if (time.hour >= 12) {
      return 'PM';
    } else {
      return 'AM';
    }
  }

  int _get12HourFormat(int hour) {
    return hour > 12 ? hour - 12 : hour;
  }
}
