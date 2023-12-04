import 'package:flutter/material.dart';
import 'package:gym_kiosk_admin/models/model.dart';

import '../main.dart';
// Import your model here

class MemberListScreen extends StatelessWidget {
  const MemberListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<List<Member>>(
        stream: objectbox.getMemberStream(), // Assuming objectbox has getMemberStream method
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            // Handle error state
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // No data available
            return Center(
              child: Text('No members available'),
            );
          } else {
            // Display the list of members
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final member = snapshot.data![index];
                return Dismissible(
                  key: UniqueKey(),
                  background: Container(color: Colors.red),
                  onDismissed: (direction) {
                    // Remove the member from ObjectBox
                    objectbox.removeMember(member.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Member ${member.id} deleted'),
                      ),
                    );
                  },
                  child: ListTile(
                    title: Text('${member.firstName} ${member.lastName}'),
                    subtitle: Text(member.contactNumber),
                    // Add more details here as needed
                    onTap: () {
                      // Handle tap on a member tile
                      // For example, navigate to a detailed member view
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
