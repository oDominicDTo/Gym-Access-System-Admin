import 'package:flutter/material.dart';

class MemberSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const MemberSearchBar({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400, // Set the width of the search bar
      height: 40, // Set the height of the search bar
      child: TextField(
        decoration: const InputDecoration(
          hintText: 'Search by name...',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(),
        ),
        onChanged: onChanged,
      ),
    );
  }
}