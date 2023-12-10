import 'package:flutter/material.dart';

import '../widget/add_new_member_form.dart';

class MembershipStatusScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Membership Status'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Content of the screen
            AddNewMemberForm(),
          ],
        ),
      ),
    );
  }
}
