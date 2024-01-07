import 'package:flutter/material.dart';
import 'package:gym_kiosk_admin/screens/renew/preview_selected_member.dart';
import '../../main.dart';
import '../../models/model.dart';

class MemberSelectionPage extends StatefulWidget {
  const MemberSelectionPage({Key? key}) : super(key: key);

  @override
  State createState() => _MemberSelectionPageState();
}

class _MemberSelectionPageState extends State<MemberSelectionPage> {
  List<Member> allMembers = []; // Fetch members from ObjectBox
  List<Member> filteredMembers = []; // Filtered list based on search

  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    // Fetch members from ObjectBox when the widget initializes
    fetchMembers();
    _searchController = TextEditingController();
  }

  void fetchMembers() async {
    // Fetch all members from ObjectBox
    List<Member> members = objectbox.getAllMembers();

    // Sort members alphabetically by first name before updating the state
    members.sort((a, b) => a.firstName.toLowerCase().compareTo(b.firstName.toLowerCase()));

    setState(() {
      allMembers = members;
      filteredMembers = members;
    });
  }

  void filterMembers(String searchText) {
    setState(() {
      filteredMembers = allMembers
          .where((member) =>
      member.firstName.toLowerCase().contains(searchText.toLowerCase()) ||
          member.lastName.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    });
  }

  void navigateToMembershipDuration(Member selectedMember) {
    // Navigate to the page where membership duration can be set for the selected member
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PreviewMemberPage(member: selectedMember),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select a Member'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search Members',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: filterMembers,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredMembers.length,
              itemBuilder: (context, index) {
                final member = filteredMembers[index];
                return ListTile(
                  title: Text('${member.firstName} ${member.lastName}'),
                  onTap: () {
                    // Navigate to membership duration setting page with selected member
                    navigateToMembershipDuration(member);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

