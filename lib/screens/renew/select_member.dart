import 'package:flutter/material.dart';
import 'package:gym_kiosk_admin/screens/renew/preview_selected_member.dart';
import '../../main.dart';
import '../../models/model.dart';

class MemberSelectionPage extends StatefulWidget {
  final String adminName;
  const MemberSelectionPage({Key? key, required this.adminName}) : super(key: key);

  @override
  State createState() => _MemberSelectionPageState();
}

class _MemberSelectionPageState extends State<MemberSelectionPage> {
  List<Member> allMembers = []; // Fetch members from ObjectBox
  List<Member> filteredMembers = []; // Filtered list based on search

  late TextEditingController _searchController;
  int _hoveredIndex = -1;

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
        builder: (context) => PreviewMemberPage(member: selectedMember, adminName: widget.adminName,),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select a Member', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Members', labelStyle: const TextStyle(fontFamily: 'Poppins'),
                prefixIcon: const Icon(Icons.search, color: Colors.purple),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                ),
              ),
              onChanged: filterMembers,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredMembers.length,
              itemBuilder: (context, index) {
                final member = filteredMembers[index];
                return InkWell(
                  onHover: (isHovered) {
                    setState(() {
                      _hoveredIndex = isHovered ? index : -1;
                    });
                  },
                  onTap: () {
                    // Navigate to membership duration setting page with selected member
                    navigateToMembershipDuration(member);
                  },
                  child: Container(
                    color: _hoveredIndex == index ? Colors.lightBlueAccent : Colors.transparent,
                    child: ListTile(
                      title: Text('${member.firstName} ${member.lastName}', style: const TextStyle(fontFamily: 'Poppins')),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
