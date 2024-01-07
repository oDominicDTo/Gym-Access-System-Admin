import 'package:flutter/material.dart';
import 'package:gym_kiosk_admin/models/model.dart';
import 'confirmation_payment.dart';

class MembershipDurationPage extends StatefulWidget {
  final Member selectedMember;

  const MembershipDurationPage({
    Key? key,
    required this.selectedMember,
  }) : super(key: key);

  @override
  State createState() => _MembershipDurationPageState();
}

class _MembershipDurationPageState extends State<MembershipDurationPage> {
  int months = 1; // Initial value for the membership duration
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

  double get totalPrice => (membershipFee ?? 0.0) * months;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Membership Duration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 400,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (months > 1) months--;
                      });
                    },
                    icon: const Icon(Icons.remove),
                  ),
                  Text(
                    months == 1 ? '1 month' : '$months months',
                    style: const TextStyle(fontSize: 48),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        months++;
                      });
                    },
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Total Price: PHP ${totalPrice.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 100),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () async {
                    Navigator.push(
                        context,
                      MaterialPageRoute(
                        builder: (context) => ConfirmationPaymentPage(
                          selectedMember: widget.selectedMember,
                          months: months,
                        ),
                      ),
                      );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  child: const Text('Confirm', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
