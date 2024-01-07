import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gym_kiosk_admin/screens/renew/renewal_page.dart';
import 'package:gym_kiosk_admin/widgets/custom_card_button.dart';
import 'package:path_provider/path_provider.dart';
import '../../models/model.dart';


class SuccessPage extends StatelessWidget {
  final Member member;

  const SuccessPage({Key? key, required this.member}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Duration membershipDuration = member.membershipEndDate.difference(member.membershipStartDate);

    String durationText = '';
    if (membershipDuration.inDays >= 365) {
      final years = membershipDuration.inDays ~/ 365;
      final remainingDays = membershipDuration.inDays % 365;
      if (remainingDays > 30) {
        durationText = '$years year${years > 1 ? 's' : ''}';
      } else {
        durationText = '$years year${years > 1 ? 's' : ''} and $remainingDays day${remainingDays > 1 ? 's' : ''}';
      }
    } else if (membershipDuration.inDays > 30) {
      final months = membershipDuration.inDays ~/ 30;
      final remainingDays = membershipDuration.inDays % 30;
      durationText = '$months month${months > 1 ? 's' : ''} and $remainingDays day${remainingDays > 1 ? 's' : ''}';
    } else {
      durationText = '${membershipDuration.inDays} day${membershipDuration.inDays > 1 ? 's' : ''}';
    }

    return Scaffold(
      appBar: AppBar(
      ),
      body: SingleChildScrollView(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 100),
            Expanded(flex:1, child:
            _buildProfileImage()
            ),

            const SizedBox(width: 20.0),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20.0),
                    Text(
                      'Successfully Added $durationText',
                      style: const TextStyle(fontFamily: 'Poppins', fontSize: 24),
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      'Start Date: ${member.membershipStartDateFormat}',
                      style: const TextStyle(fontFamily: 'Poppins', fontSize: 24),
                    ),
                    Text(
                      'End Date: ${member.membershipEndDateFormat}',
                      style: const TextStyle(fontFamily: 'Poppins', fontSize: 24),
                    ),
                    const SizedBox(height: 50.0),
                    CustomCardButton(
                      title: 'Exit',
                      icon: Icons.close,
                      onPressed: () {
                        Navigator.popUntil(context, ModalRoute.withName('/'));
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RenewalPage(),
                          ),
                        );
                      },
                      iconColor: Colors.blue,
                    ),
                  ],
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
            height: 200, // Adjust the height as desired
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

  Future<String> _getLocalImagePath(String imagePath) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String localPath = '${appDocDir.path}/Kiosk/Photos/$imagePath';
    return localPath.replaceAll(r'\', '/'); // Ensure correct separators
  }
}
