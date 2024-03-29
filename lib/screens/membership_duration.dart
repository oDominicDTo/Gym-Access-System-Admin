import 'package:flutter/material.dart';
import 'package:gym_kiosk_admin/screens/camera_page.dart';
import 'package:gym_kiosk_admin/models/model.dart';
import 'package:intl/intl.dart';

class MembershipDurationPage extends StatefulWidget {
  final MembershipType? selectedMembershipType;
  final String firstName;
  final String lastName;
  final String contactNumber;
  final String email;
  final String address;
  final String dateOfBirth;
  final Function(Member) onSaveMember;
  final String adminName;
  const MembershipDurationPage({
    Key? key,
    this.selectedMembershipType,
    required this.firstName,
    required this.lastName,
    required this.contactNumber,
    required this.email,
    required this.address,
    required this.onSaveMember,
    required this.dateOfBirth,
    required this.adminName,
  }) : super(key: key);

  @override
  State<MembershipDurationPage> createState() => _MembershipDurationPageState();
}

class _MembershipDurationPageState extends State<MembershipDurationPage> {
  int months = 1; // Initial value for the membership duration

  double get totalPrice => widget.selectedMembershipType!.fee * months;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Membership Duration'),
        automaticallyImplyLeading: true,
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
                  if (months > 1) IconButton(
                    onPressed: () {
                      setState(() {
                        if (months > 1) months--;
                      });
                    },
                    icon: Icon(Icons.remove, color: Colors.red),
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
                    icon: Icon(Icons.add, color: Colors.green),
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
                  onPressed: () {
                    // Handle cancellation logic here
                    Navigator.pop(context); // Go back to the previous page
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                      if (states.contains(MaterialState.hovered)) {
                        return Colors.red[100]!; // Light red when hovered
                      }
                      return Colors.white; // White background when not hovered
                    }),
                    foregroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                      if (states.contains(MaterialState.hovered)) {
                        return Colors.black; // Black text when hovered
                      }
                      return Colors.black; // Black text when not hovered
                    }),
                    side: MaterialStateProperty.resolveWith<BorderSide>((Set<MaterialState> states) {
                      if (states.contains(MaterialState.hovered)) {
                        return const BorderSide(color: Colors.black); // Black border when hovered
                      }
                      return const BorderSide(color: Colors.black); // Black border when not hovered
                    }),
                  ),
                  child: Text('Cancel', style: TextStyle(color: Colors.black, fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 40),
                ElevatedButton(
                  onPressed: () {
                    if (widget.selectedMembershipType != null) {
                      DateTime parsedDate = DateFormat('MMMM dd, yyyy').parse(widget.dateOfBirth);
                      DateTime membershipEndDate = DateTime.now().add(Duration(days: 30 * months));

                      Member newMember = Member(
                        firstName: widget.firstName,
                        lastName: widget.lastName,
                        contactNumber: widget.contactNumber,
                        email: widget.email,
                        address: widget.address,
                        dateOfBirth: parsedDate,
                        nfcTagID: 'sampleNfcTagID',
                        membershipStartDate: DateTime.now(),
                        membershipEndDate: membershipEndDate,
                        photoPath: '',
                        checkedIn: false,
                      );

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text(
                              'Confirm Payment',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.black, fontFamily: 'Poppins', fontWeight: FontWeight.bold),
                            ),
                            content: const Text(
                              'Did you receive the payment for this membership?',
                              style: TextStyle(color: Colors.black, fontFamily: 'Poppins'),
                            ),
                            actions: [
                              Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      style: TextButton.styleFrom(
                                        side: const BorderSide(color: Colors.black), // Set border color to black
                                      ),
                                      child: const Text(
                                        'No',
                                        style: TextStyle(color: Colors.black, fontFamily: 'Poppins', fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const SizedBox(width: 16), // Add some space between buttons
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        widget.onSaveMember(newMember);

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => CameraPage(
                                              newMember: newMember,
                                              selectedMembershipType: widget.selectedMembershipType,
                                              adminName: widget.adminName,
                                              totalPrice: totalPrice,
                                            ),
                                          ),
                                        );
                                      },
                                      style: TextButton.styleFrom(
                                        backgroundColor: Colors.black,
                                      ),
                                      child: const Text(
                                        'Yes',
                                        style: TextStyle(color: Colors.white, fontFamily: 'Poppins', fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      );
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
                      return Colors.white; // White text when not hovered
                    }),
                  ),
                  child: const Text('Confirm', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

