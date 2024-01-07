import 'package:flutter/material.dart';
import 'confirmation_payment.dart';
import 'package:gym_kiosk_admin/models/model.dart';

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
  int months = 1;
  double? membershipFee;
  bool isMinusButtonHovered = false;
  bool isPlusButtonHovered = false;
  bool isConfirmButtonHovered = false;

  @override
  void initState() {
    super.initState();
    fetchMembershipType();
  }

  void fetchMembershipType() {
    final membershipType = widget.selectedMember.membershipType.target;

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
                color: const Color(0xFFF5F5F5), // Set color to #f5f5f5
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (months > 1) months--;
                      });
                    },
                    onHover: (hovering) {
                      setState(() {
                        isMinusButtonHovered = hovering;
                      });
                    },
                    child: Icon(
                      Icons.remove,
                      color: isMinusButtonHovered ? Colors.purple : Colors.black,
                    ),
                  ),
                  Text(
                    months == 1 ? '1 month' : '$months months',
                    style: const TextStyle(fontSize: 48),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        months++;
                      });
                    },
                    onHover: (hovering) {
                      setState(() {
                        isPlusButtonHovered = hovering;
                      });
                    },
                    child: Icon(
                      Icons.add,
                      color: isPlusButtonHovered ? Colors.purple : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Total Price: PHP ${totalPrice.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 100),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  onTap: () async {
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
                  onHover: (hovering) {
                    setState(() {
                      isConfirmButtonHovered = hovering;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isConfirmButtonHovered ? Colors.white : Colors.black,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      'Confirm',
                      style: TextStyle(
                        color: isConfirmButtonHovered ? Colors.black : Colors.white,
                      ),
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