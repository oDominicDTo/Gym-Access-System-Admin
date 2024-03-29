import 'package:flutter/material.dart';
import '../../main.dart';
import 'preview_success_renew.dart';
import '../../models/model.dart';

class ConfirmationPaymentPage extends StatefulWidget {
  final Member selectedMember;
  final int months;

  final String adminName;

  const ConfirmationPaymentPage({
    Key? key,
    required this.selectedMember,
    required this.months,  required this.adminName,
  }) : super(key: key);

  @override
  State createState() => _ConfirmationPaymentPageState();
}

class _ConfirmationPaymentPageState extends State<ConfirmationPaymentPage> {
  double? membershipFee; // Variable to hold membership fee
  bool isNoButtonHovered = false;
  bool isYesButtonHovered = false;

  @override
  void initState() {
    super.initState();
    fetchMembershipType();
  }

  void fetchMembershipType() {
    // Accessing the membership type relation of the selected member
    final membershipType = widget.selectedMember.membershipType.target;

    // If the membership type is not null, set the membership fee
    if (membershipType != null) {
      setState(() {
        membershipFee = membershipType.fee;
      });
    }
  }

  double get totalPrice => (membershipFee ?? 0.0) * widget.months;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Payment', style: TextStyle(fontFamily: 'Poppins')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 400,
              height: 200,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Did you receive the payment for this membership?', style: TextStyle(fontFamily: 'Poppins')),
                  const SizedBox(height: 20),
                  Text(
                    'Total Amount: PHP ${totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        fontFamily: 'Poppins'
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the confirmation page
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isNoButtonHovered ? const Color(0xFFE0ADB0) : Colors.black,
                    fixedSize: const Size(120, 50), // Adjust the button size here
                  ),
                  onHover: (hovering) {
                    setState(() {
                      isNoButtonHovered = hovering;
                    });
                  },
                  child: const Text(
                    'No',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16, // Adjust the font size here
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Update membership duration and log renewal
                    final currentDate = DateTime.now();
                    // final updatedEndDate = currentDate.add(Duration(days: 30 * widget.months));

                    // Update membership duration
                    final addedDurationDays = 30 * widget.months;

                  objectbox.updateMembershipDuration(widget.selectedMember.id, addedDurationDays);

                    final membershipType = widget.selectedMember.membershipType.target;
                    final membershipTypeName = membershipType != null ? membershipType.typeName : '';

                    final newAdminRenewalLog = AdminRenewalLog(
                      renewalDate: currentDate,
                      memberName: '${widget.selectedMember.firstName} ${widget.selectedMember.lastName}',
                      adminName: widget.adminName, // Set the admin name here
                      membershipType: membershipTypeName, // Assuming membership type ID needs to be captured
                      addedDurationDays: addedDurationDays,
                      amount: totalPrice, // If applicable, include the total price here
                    );

                    final newRenewalLog = RenewalLog(
                      renewalDate: currentDate,
                      addedDurationDays: addedDurationDays,
                    );
                    newRenewalLog.member.target = widget.selectedMember;

                    objectbox.addRenewalLog(newRenewalLog);
                    objectbox.addAdminRenewalLog(newAdminRenewalLog);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SuccessPage(member: widget.selectedMember, addedDurationDays: addedDurationDays,),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isYesButtonHovered ? const Color(0xFF5CC69C) : Colors.black,
                    fixedSize: const Size(120, 50), // Adjust the button size here
                  ),
                  onHover: (hovering) {
                    setState(() {
                      isYesButtonHovered = hovering;
                    });
                  },
                  child: const Text(
                    'Yes',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16, // Adjust the font size here
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}