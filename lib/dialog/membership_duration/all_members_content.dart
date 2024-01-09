import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gym_kiosk_admin/main.dart';
import 'confirmation_dialog.dart';

class AllMembersContent extends StatefulWidget {
  final VoidCallback onBack;
  final ValueChanged<int> onDaysChanged;
  final BuildContext initialContext; // Store the initial context

  const AllMembersContent({
    Key? key,
    required this.onBack,
    required this.onDaysChanged,
    required this.initialContext,
  }) : super(key: key);

  @override
  State createState() => _AllMembersContentState();
}



class _AllMembersContentState extends State<AllMembersContent> {
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
              'Adjust Membership Duration for All Members',
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
                      title: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 40.0, // Adjust the size according to your preference
                          ),
                        ], // Add a comma here
                      ),

                      content: const SizedBox(
                        width: 400.0,
                        height: 60,// Adjust the width as needed
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Action Required', style: TextStyle(color: Colors.black, fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 15)),
                            SizedBox(height: 10.0),
                            Text('Please add or subtract days first.', style: TextStyle(color: Colors.black, fontFamily: 'Poppins', fontSize: 15)),
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
                          child: const Text('OK', style: TextStyle(color: Colors.black, fontFamily: 'Poppins')),
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
                          objectbox.updateMembershipDurationForAllMembers(days);

                          // Show success dialog
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const AlertDialog(
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                      size: 50.0, // Adjust the size according to your preference
                                    ),
                                  ], // Add a comma here
                                ),

                                content: SizedBox(
                                  width: 550.0,
                                  height: 80,// Adjust the width as needed
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('Success', style: TextStyle(color: Colors.black, fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 20)),
                                      SizedBox(height: 10.0),
                                      Text('Membership duration updated successfully.', style: TextStyle(color: Colors.black, fontFamily: 'Poppins', fontSize: 15)),
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
                          });
                        }
                      },
                    );
                  },
                );
              }
            },
            style: ElevatedButton.styleFrom(
              side: const BorderSide(color: Colors.black), // Set border color to black
            ),
            child: const Text('Update Duration', style: TextStyle(fontFamily: 'Poppins', color: Colors.black)),
          ),
          const SizedBox(height: 8),
          // Example back button to switch back to initial content
          TextButton(
            onPressed: widget.onBack,
            child: const Text('Back', style: TextStyle(fontFamily: 'Poppins', color: Colors.black)),
          ),
        ],
      ),
    );
  }
}
