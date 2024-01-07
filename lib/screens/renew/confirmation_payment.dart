import 'package:flutter/material.dart';
import '../../main.dart';
import 'preview_success_renew.dart';
import '../../models/model.dart';

class ConfirmationPaymentPage extends StatefulWidget {
  final Member selectedMember;
  final int months;

  const ConfirmationPaymentPage({
    Key? key,
    required this.selectedMember,
    required this.months,
  }) : super(key: key);

  @override
  State createState() => _ConfirmationPaymentPageState();
}

class _ConfirmationPaymentPageState extends State<ConfirmationPaymentPage> {
  double? membershipFee; // Variable to hold membership fee

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
        title: const Text('Confirm Payment'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Did you receive the payment for this membership?'),
          const SizedBox(height: 20),
          Text(
            'Total Amount: PHP ${totalPrice.toStringAsFixed(2)}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
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
                child: const Text('No'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Update membership duration and log renewal
                  final currentDate = DateTime.now();
                  final updatedEndDate = currentDate.add(Duration(days: 30 * widget.months));

                  // Update membership duration
                  widget.selectedMember.membershipEndDate = updatedEndDate;
                  // Assuming objectbox methods are being handled elsewhere

                  // Log renewal in RenewalLog entity with added duration days
                  final addedDurationDays = 30 * widget.months; // Calculate the added duration
                  final newRenewalLog = RenewalLog(
                    renewalDate: currentDate,
                    addedDurationDays: addedDurationDays,
                  );
                  newRenewalLog.member.target = widget.selectedMember;
                  objectbox.addRenewalLog(newRenewalLog);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SuccessPage(member: widget.selectedMember),
                    ),
                  );
                },
                child: const Text('Yes'),
              ),

            ],
          ),
        ],
      ),
    );
  }
}
