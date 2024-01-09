import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gym_kiosk_admin/main.dart';
import 'confirmation_dialog_specific.dart';

class AdjustSelectedMembershipDuration extends StatefulWidget {

  final List<int> selectedMemberIds;
  final BuildContext initialContext;
  final ValueChanged<int> onDaysChanged;

  const AdjustSelectedMembershipDuration({
    Key? key,

    required this.selectedMemberIds,
    required this.initialContext,
    required this.onDaysChanged,
  }) : super(key: key);

  @override
  State createState() => _AdjustSelectedMembershipDurationState();
}

class _AdjustSelectedMembershipDurationState extends State<AdjustSelectedMembershipDuration> {
  int days = 0;
  Timer? _timer;

  void _startTimer(Function() callback) {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      callback();
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 510,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Adjust Membership Duration for Selected Members',
              style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Poppins', fontSize: 15),
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTapDown: (_) {
                          _startTimer(() {
                            setState(() {
                              days--;
                            });
                            widget.onDaysChanged(days);
                          });
                        },
                        onTapUp: (_) => _stopTimer(),
                        onTapCancel: _stopTimer,
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              days--;
                            });
                            widget.onDaysChanged(days);
                          },
                          style: OutlinedButton.styleFrom(
                            shape: const CircleBorder(),
                          ),
                          child: const Icon(Icons.remove),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        days == 0
                            ? 'Days to Add/Subtract'
                            : 'Days to ${days >= 0 ? 'Add' : 'Subtract'}: ${days.abs()}',
                        style: const TextStyle(fontSize: 18, fontFamily: 'Poppins'),
                      ),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTapDown: (_) {
                          _startTimer(() {
                            setState(() {
                              days++;
                            });
                            widget.onDaysChanged(days);
                          });
                        },
                        onTapUp: (_) => _stopTimer(),
                        onTapCancel: _stopTimer,
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              days++;
                            });
                            widget.onDaysChanged(days);
                          },
                          style: OutlinedButton.styleFrom(
                            shape: const CircleBorder(),
                          ),
                          child: const Icon(Icons.add),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (days == 0) {
                // Show dialog prompting to add or subtract days first
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 40.0, // Adjust the size according to your preference
                          ),
                        ], // Add a comma here
                      ),

                      content: Container(
                            width: 400.0,
                            height: 60,// Adjust the width as needed
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('Action Required', style: TextStyle(color: Colors.black, fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 15)),
                                const SizedBox(height: 10.0),
                                const Text('Please add or subtract days first.', style: TextStyle(color: Colors.black, fontFamily: 'Poppins', fontSize: 15)),
                              ],
                            ),
                          ),


                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black, // Set background color to black
                          ),
                          child: const Text('OK', style: TextStyle(fontFamily: 'Poppins', color: Colors.white)),
                        ),
                      ],
                    );

                  },
                );
              } else {
                // Show confirmation dialog for adding or subtracting days
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ConfirmationDialog(
                      days: days,
                      onConfirmation: (bool confirm) {
                        if (confirm) {
                          objectbox.updateMembershipDurationForSelectedMembers(
                            widget.selectedMemberIds,
                            days,
                          );
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                  title: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                  const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 50.0, // Adjust the size according to your preference
                              ),
                              ], // Add a comma here
                              ),

                              content: Container(
                              width: 550.0,
                              height: 80,// Adjust the width as needed
                              child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                              const Text('Success', style: TextStyle(color: Colors.black, fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 20)),
                              const SizedBox(height: 10.0),
                              const Text('Membership duration updated for selected members.', style: TextStyle(color: Colors.black, fontFamily: 'Poppins', fontSize: 15)),
                              ],
                              ),
                              ),
                              );
                              },
                          );
                          // Delay navigation back to the initial dialog after 2 seconds
                          Future.delayed(const Duration(seconds: 2), () {
                            Navigator.of(widget.initialContext).pop();
                            Navigator.of(widget.initialContext).pop();
                            Navigator.of(widget.initialContext).pop();

                          });
                        }
                      },
                    );
                  },
                );
              }
            },
            style: ElevatedButton.styleFrom(
              side: BorderSide(color: Colors.black), // Set border color to black
            ),
            child: const Text('Update Duration for Selected Members', style: TextStyle(fontFamily: 'Poppins', color: Colors.black)),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the Adjust Membership Duration screen
            },
            child: const Text('Back', style: TextStyle(fontFamily: 'Poppins', color: Colors.black)),
          ),
        ],
      ),
    );
  }
}