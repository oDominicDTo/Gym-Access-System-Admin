import 'package:flutter/material.dart';
import 'package:gym_kiosk_admin/widgets/card_button.dart';

class ManagementPage extends StatelessWidget {
  const ManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Management Page')),
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
                            child: CardButton(
                              title: 'Edit Staff',
                              onPressed: () {
                                // Action for button 1
                              },
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Expanded(
                            child: CardButton(
                              title: 'Edit Membership Duration',
                              onPressed: () {
                                // Action for button 3
                              },
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
                            child: CardButton(
                              title: 'Edit Membership Types',
                              onPressed: () {
                                // Action for button 2
                              },
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Expanded(
                            child: CardButton(
                              title: 'Button 4',
                              onPressed: () {
                                // Action for button 4
                              },
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