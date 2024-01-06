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
              style: TextStyle(fontWeight: FontWeight.bold),
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
                        style: const TextStyle(fontSize: 18),
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
                      title: const Text('Action Required'),
                      content: const Text('Please add or subtract days first.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: const Text('OK'),
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
                                title: Text('Success'),
                                content: Text('Membership duration updated successfully.'),
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
            child: const Text('Update Duration'),
          ),
          const SizedBox(height: 8),
          // Example back button to switch back to initial content
          TextButton(
            onPressed: widget.onBack,
            child: const Text('Back'),
          ),
        ],
      ),
    );
  }
}
