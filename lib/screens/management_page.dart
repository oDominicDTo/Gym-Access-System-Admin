import 'package:flutter/material.dart';
import 'package:gym_kiosk_admin/dialog/staff/list_staff.dart';
import '../dialog/membership_type/list_membership_type_dialog.dart';

class ManagementPage extends StatelessWidget {
  const ManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Management Page', style: TextStyle(color: Colors.black, fontFamily: 'Poppins'))),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: CustomCardButton(
                              title: 'Edit Staff',
                              icon: Icons.person,
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => const ListStaffDialog(),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Expanded(
                            child: CustomCardButton(
                              title: 'Edit Membership Duration',
                              icon: Icons.access_time,
                              onPressed: () {
                                // Action for Edit Membership Duration button
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: CustomCardButton(
                              title: 'Edit Membership Types',
                              icon: Icons.category,
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => const ListMembershipTypeDialog(),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Expanded(
                            child: CustomCardButton(
                              title: 'Button 4',
                              icon: Icons.category,
                              onPressed: () {
                                // Action for button 4
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomCardButton extends StatefulWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPressed;

  const CustomCardButton({super.key,
    required this.title,
    required this.icon,
    required this.onPressed,
  });

  @override
  State createState() => _CustomCardButtonState();
}

class _CustomCardButtonState extends State<CustomCardButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      onHover: (hovered) {
        setState(() {
          isHovered = hovered;
        });
      },
      child: Card(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          width: 500,
          height: 120,
          decoration: BoxDecoration(
            color: isHovered ? Colors.blue.withOpacity(0.1) : Colors.white,
            border: Border.all(
              color: Colors.blueGrey, // Border color
              width: isHovered ? 2.0 : 1.0, // Border width
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  widget.icon,
                  size: 40,
                  color: isHovered ? Colors.blue : Colors.black,
                ),
                const SizedBox(height: 10),
                Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    color: isHovered ? Colors.blue : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}