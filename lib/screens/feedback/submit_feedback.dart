import 'package:flutter/material.dart';
import 'package:gym_kiosk_admin/main.dart';

class SubmitFeedback extends StatefulWidget {
  const SubmitFeedback({Key? key}) : super(key: key);

  @override
  State createState() => _SubmitFeedbackState();
}

class _SubmitFeedbackState extends State<SubmitFeedback> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController feedbackController = TextEditingController();

  String? selectedCategory;
  final List<String> categories = [
    'UI',
    'Functionality',
    'Performance',
    'Bug',
    'Other',
    // Add more categories as needed
  ];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Future<void> _showSuccessDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(

          title: const Row(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 50.0, // Adjust the size according to your preference
              ),
            ], // Add a comma here
          ), // Add a comma here

          content: const SizedBox(
            width: 500.0, // Adjust the width as needed
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Feedback Sent!', style: TextStyle(color: Colors.black, fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 25)),
                SizedBox(height: 10.0),
                Text('Your feedback has been successfully submitted.', style: TextStyle(color: Colors.black, fontFamily: 'Poppins', fontSize: 13)),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black, // Set background color to black
              ),
              child: const Text('OK', style: TextStyle(color: Colors.white, fontFamily: 'Poppins')),
            ),
          ],
        );


      },
    );
  }
  @override
  void dispose() {
    nameController.dispose();
    titleController.dispose();
    feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit Feedback', style: TextStyle(color: Colors.black, fontFamily: 'Poppins')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name (Optional)', labelStyle: TextStyle(color: Colors.black, fontFamily: 'Poppins'),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title', labelStyle: TextStyle(color: Colors.black, fontFamily: 'Poppins'),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                onChanged: (String? value) {
                  setState(() {
                    selectedCategory = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Category', labelStyle: TextStyle(color: Colors.black, fontFamily: 'Poppins'),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a category';
                  }
                  return null;
                },
                items: categories.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: feedbackController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Feedback', labelStyle: TextStyle(color: Colors.black, fontFamily: 'Poppins'),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your feedback';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    String name = nameController.text;
                    String title = titleController.text;
                    String? category = selectedCategory;
                    String feedbackText = feedbackController.text;

                    objectbox.addFeedbackAdmin(
                      name: name.isNotEmpty ? name : 'Anonymous',
                      title: title,
                      category: category!,
                      feedbackText: feedbackText,
                    );
                    _showSuccessDialog();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // Set background color to black
                ),
                child: const Text('Submit', style: TextStyle(color: Colors.white, fontFamily: 'Poppins')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}