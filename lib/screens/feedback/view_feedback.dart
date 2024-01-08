import 'package:flutter/material.dart';
import '../../main.dart';
import '../../models/model.dart';
import 'package:intl/intl.dart';

class ViewFeedback extends StatefulWidget {
  const ViewFeedback({Key? key}) : super(key: key);

  @override
  State createState() => _ViewFeedbackState();
}

class _ViewFeedbackState extends State<ViewFeedback> {
  UserFeedback? selectedFeedback;
  late List<UserFeedback> feedbackList;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<UserFeedback>>(
      future: objectbox.getFeedbackSortedByTime(),
      builder: (context, AsyncSnapshot<List<UserFeedback>?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No feedback available.'));
        }

        feedbackList = snapshot.data!;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Feedback'),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left side list
                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: feedbackList.map((feedback) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                selectedFeedback = feedback;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: ListTile(
                                leading: const Icon(Icons.feedback_outlined),
                                title: Text(
                                  'Name: ${feedback.name}',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  'Title: ${feedback.title}',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(width: 16.0), // Spacer

                // Detailed view
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: const EdgeInsets.all(12.0),
                    child: selectedFeedback != null
                        ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Name: ${selectedFeedback!.name}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              DateFormat('MMMM d, y').format(selectedFeedback!.submissionTime),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const Divider(color: Colors.black, thickness: 0.5),
                        Text(
                          'Title: ${selectedFeedback!.title}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Divider(color: Colors.black, thickness: 0.5),
                        Text(
                          'Category: ${selectedFeedback!.category}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Divider(color: Colors.black, thickness: 0.5),
                        const Text(
                          'Feedback Message:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          selectedFeedback!.feedbackText,
                        ),
                      ],
                    )
                        : const Center(
                      child: Text('Select a feedback to view details.'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

