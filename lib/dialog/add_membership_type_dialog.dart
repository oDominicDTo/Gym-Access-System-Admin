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
      title: const Text('Add Membership Type'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            onChanged: (value) {
              setState(() {
                typeName = value;
              });
            },
            decoration: const InputDecoration(labelText: 'Type Name'),
          ),
          TextFormField(
            onChanged: (value) {
              setState(() {
                fee = double.tryParse(value) ?? 0.0;
              });
            },
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Fee'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            final newType = MembershipType(
              typeName: typeName,
              fee: fee,
              discount: discount,
              isLifetime: isLifetime,
            );
            widget.onAdd(newType); // Send the new type back
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}