import 'package:flutter/material.dart';

import '../widget/app_bar_with_search.dart';
import '../widget/custom_drawer.dart';

class HomeAdmin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithSearch(
        onAddPressed: () {
          // Implement your 'Add' button logic here
        },
      ),
      drawer: CustomDrawer(),
      body: Center(
        child: Text('Welcome to Gym Management System!'),
      ),
    );
  }
}
