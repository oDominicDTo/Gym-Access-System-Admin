import 'package:flutter/material.dart';
import 'package:gym_kiosk_admin/models/model.dart';

class AddMembershipTypeDialog extends StatefulWidget {
  final Function(MembershipType) onAdd;

  const AddMembershipTypeDialog({Key? key, required this.onAdd}) : super(key: key);

  @override
  State createState() => _AddMembershipTypeDialogState();
}

class _AddMembershipTypeDialogState extends State<AddMembershipTypeDialog> {
  late String typeName = '';
  late double fee = 0.0;
  late double discount = 0.0;
  late bool isLifetime = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Membership Type', style: TextStyle(color: Colors.black, fontFamily: 'Poppins')),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextFormField(
                onChanged: (value) {
                  setState(() {
                    typeName = value;
                  });
                },
                style: const TextStyle(color: Colors.black, fontFamily: 'Poppins', fontSize: 16.0), // Adjust font size
                decoration: const InputDecoration(
                  labelText: 'Type Name',
                  labelStyle: TextStyle(color: Colors.black, fontFamily: 'Poppins', fontSize: 14.0, fontWeight: FontWeight.bold), // Bold label
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextFormField(
                onChanged: (value) {
                  setState(() {
                    fee = double.tryParse(value) ?? 0.0;
                  });
                },
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.black, fontFamily: 'Poppins', fontSize: 16.0), // Adjust font size
                decoration: const InputDecoration(
                  labelText: 'Fee',
                  labelStyle: TextStyle(color: Colors.black, fontFamily: 'Poppins', fontSize: 14.0, fontWeight: FontWeight.bold), // Bold label
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (typeName.isEmpty) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Invalid Type Name', style: TextStyle(color: Colors.black, fontFamily: 'Poppins')),
                    content: const Text('Type Name cannot be empty.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                            if (states.contains(MaterialState.hovered)) {
                              return Colors.purple[100]!; // Light purple when hovered
                            }
                            return Colors.black; // Black when not hovered
                          }),
                          foregroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                            if (states.contains(MaterialState.hovered)) {
                              return Colors.black; // Black text when hovered
                            }
                            return Colors.white; // White text when not hovered
                          }),
                        ),
                        child: const Text('OK', style: TextStyle(fontFamily: 'Poppins')),
                      ),
                    ],
                  );
                },
              );
            } else if (fee <= 0) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Invalid Fee', style: TextStyle(color: Colors.black, fontFamily: 'Poppins')),
                    content: const Text('Fee must be greater than 0.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                            if (states.contains(MaterialState.hovered)) {
                              return Colors.purple[100]!; // Light purple when hovered
                            }
                            return Colors.black; // Black when not hovered
                          }),
                          foregroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                            if (states.contains(MaterialState.hovered)) {
                              return Colors.black; // Black text when hovered
                            }
                            return Colors.white; // White text when not hovered
                          }),
                        ),
                        child: const Text('OK', style: TextStyle(fontFamily: 'Poppins')),
                      ),
                    ],
                  );
                },
              );

            } else {
              final newType = MembershipType(
                typeName: typeName,
                fee: fee,
                discount: discount,
                isLifetime: isLifetime,
              );
              widget.onAdd(newType); // Send the new type back
              Navigator.of(context).pop(); // Close the dialog
            }
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
              if (states.contains(MaterialState.hovered)) {
                return Colors.purple[100]!; // Light purple when hovered
              }
              return Colors.black; // Black when not hovered
            }),
            foregroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
              if (states.contains(MaterialState.hovered)) {
                return Colors.black; // Black text when hovered
              }
              return Colors.black; // White text when not hovered
            }),
          ),
          child: const Text('Add', style: TextStyle(color: Colors.white, fontFamily: 'Poppins')),
        ),
      ],
    );
  }
}

