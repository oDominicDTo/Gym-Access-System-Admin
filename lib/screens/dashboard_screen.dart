// screens/example_screen.dart

import 'package:flutter/material.dart';


class DashboardScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Example Screen'),
      ),
      body: Center(

          child: Text('Show Custom Dialog'),

      ),
    );
  }

}
