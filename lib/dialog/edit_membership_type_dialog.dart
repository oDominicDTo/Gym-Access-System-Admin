import 'package:flutter/material.dart';
import 'package:gym_kiosk_admin/models/model.dart';


class EditMembershipTypeDetailsDialog extends StatefulWidget {
  final MembershipType type;
  final Function(MembershipType) onUpdate;
  final Function(int) onRemove; // Add the function to remove the type

  const EditMembershipTypeDetailsDialog({
    Key? key,
    required this.type,
    required this.onUpdate,
    required this.onRemove,
  }) : super(key: key);

  @override
  State createState() => _EditMembershipTypeDetailsDialogState();
}

class _EditMembershipTypeDetailsDialogState extends State<EditMembershipTypeDetailsDialog> {
  late String typeName;
  late double fee;
  late double discount;
  late bool isLifetime;

  @override
  void initState() {
    super.initState();
    typeName = widget.type.typeName;
    fee = widget.type.fee;
    discount = widget.type.discount;
    isLifetime = widget.type.isLifetime;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Membership Type'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            initialValue: typeName,
            onChanged: (value) {
              setState(() {
                typeName = value;
              });
            },
            decoration: const InputDecoration(labelText: 'Type Name'),
          ),
          TextFormField(
            initialValue: fee.toString(),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                // Invoke the remove function with the type ID
                widget.onRemove(widget.type.id);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Remove'),
            ),
            TextButton(
              onPressed: () {
                final updatedType = MembershipType(
                  id: widget.type.id,
                  typeName: typeName,
                  fee: fee,
                  discount: discount,
                  isLifetime: isLifetime,
                );
                widget.onUpdate(updatedType);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ],
    );
  }
}