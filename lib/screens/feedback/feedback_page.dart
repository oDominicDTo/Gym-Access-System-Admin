import 'package:flutter/material.dart';
import 'package:gym_kiosk_admin/screens/feedback/view_feedback.dart';
import '../../widgets/custom_card_button.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({Key? key}) : super(key: key);
  @override
  State createState() => _FeedbackPageState();
}
class _FeedbackPageState extends State<FeedbackPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Feedback Page',
            style: TextStyle(color: Colors.black, fontFamily: 'Poppins'),
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: CustomCardButton(
                              title: 'View Feedback',
                              icon: Icons.feedback,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation, secondaryAnimation) => const ViewFeedback(),
                                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                      return SlideTransition(
                                        position: Tween<Offset>(
                                          begin: const Offset(0.0, 1.0),
                                          end: Offset.zero,
                                        ).animate(animation),
                                        child: child,
                                      );
                                    },
                                  ),
                                );
                              },

                              iconColor: Colors.blue,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Expanded(
                            child: CustomCardButton(
                              title: 'Submit Feedback',
                              icon: Icons.add_comment,
                              onPressed: () {
                                // Action to submit feedback
                              },
                              iconColor: Colors.pink,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: CustomCardButton(
                              title: 'Feedback Analytics',
                              icon: Icons.analytics,
                              onPressed: () {
                                // Action for feedback analytics
                              },
                              iconColor: Colors.orange,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Expanded(
                            child: CustomCardButton(
                              title: 'Export Feedback',
                              icon: Icons.save_alt,
                              onPressed: () {
                                // Action for button 4
                              },
                              iconColor: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
