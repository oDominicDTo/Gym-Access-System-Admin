import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../../../models/model.dart';
import 'renewal_page.dart';
import '../../../widgets/custom_card_button.dart';

class SuccessPage extends StatelessWidget {
  final Member member;
  final int addedDurationDays;
  const SuccessPage({Key? key, required this.member, required this.addedDurationDays}) : super(key: key);

  @override
  Widget build(BuildContext context) {



    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: SingleChildScrollView(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 100),
            Expanded(
              flex: 1,
              child: _buildProfileImage(),
            ),
            const SizedBox(width: 20.0),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20.0),
                      Text(
                        'Successfully Added  $addedDurationDays  Days',
                        style: const TextStyle(fontFamily: 'Poppins', fontSize: 24),
                      ),
                      const SizedBox(height: 16.0),
                      _buildInfoRow(
                        icon: Icons.event,
                        label: 'Start Date:',
                        value: member.membershipStartDateFormat,
                        color: Colors.blue,
                      ),
                      _buildInfoRow(
                        icon: Icons.event,
                        label: 'End Date:',
                        value: member.membershipEndDateFormat,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 50.0),
                      SizedBox(
                        width: 150, // Set the width here
                        child: CustomCardButton(
                          title: 'Exit',
                          icon: Icons.close,
                          onPressed: () {
                            Navigator.of(context).popUntil((route) => route.isFirst);
                          },
                          iconColor: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return FutureBuilder<String>(
      future: _getLocalImagePath(member.photoPath),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 500, // Adjust the height as desired
            width: 200, // Adjust the width as desired
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty) {
          return _buildAvatarPlaceholder();
        } else {
          final file = File(snapshot.data!);
          if (!file.existsSync()) {
            return _buildAvatarPlaceholder();
          }
          return SizedBox(
            height: 400, // Adjust the height as desired
            width: 400, // Adjust the width as desired
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.file(
                file,
                fit: BoxFit.cover, // Use BoxFit.cover to maintain aspect ratio and cover the space
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildAvatarPlaceholder() {
    return const SizedBox(
      width: 300,
      height: 400,
      child: Center(
        child: Icon(
          Icons.person,
          size: 300,
          color: Colors.grey, // Change color to black to ensure visibility
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 25,
            color: color,
          ),
          const SizedBox(width: 8),
          Text(
            '$label $value',
            style: const TextStyle(fontFamily: 'Poppins', fontSize: 24),
          ),
        ],
      ),
    );
  }

  Future<String> _getLocalImagePath(String imagePath) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String localPath = '${appDocDir.path}/Kiosk/Photos/$imagePath';
    return localPath.replaceAll(r'\', '/'); // Ensure correct separators
  }
}
