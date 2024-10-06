import 'package:evergrow_mobile_app/components/top_section.dart';
import 'package:evergrow_mobile_app/utils/theme.dart';
import 'package:flutter/material.dart';

class NotificationsSettingsPage extends StatefulWidget {
  const NotificationsSettingsPage({super.key});

  @override
  State<NotificationsSettingsPage> createState() =>
      _NotificationsSettingsPageState();
}

class _NotificationsSettingsPageState extends State<NotificationsSettingsPage> {
  bool _isPushNotificationsEnabled = true;
  bool _isDroughtNotificationEnabled = true;
  bool _isFloodNotificationEnabled = true;
  bool _isFrostNotificationEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const TopSection(),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        const Text(
                          'Notifications settings',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Push notifications',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ListTile(
                            title: const Text('On',
                                style: TextStyle(fontSize: 18)),
                            trailing: Radio<bool>(
                              value: true,
                              groupValue: _isPushNotificationsEnabled,
                              activeColor: AppTheme.primaryColor,
                              onChanged: (bool? value) {
                                setState(() {
                                  _isPushNotificationsEnabled = value!;
                                });
                              },
                            ),
                          ),
                          ListTile(
                            title: const Text('Off',
                                style: TextStyle(fontSize: 18)),
                            trailing: Radio<bool>(
                              value: false,
                              groupValue: _isPushNotificationsEnabled,
                              activeColor: AppTheme.primaryColor,
                              onChanged: (bool? value) {
                                setState(() {
                                  _isPushNotificationsEnabled = value!;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Type of event',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ListTile(
                            title: const Text('Drought',
                                style: TextStyle(fontSize: 18)),
                            trailing: Checkbox(
                              value: _isDroughtNotificationEnabled,
                              activeColor: AppTheme.primaryColor,
                              shape: const CircleBorder(),
                              onChanged: (bool? value) {
                                setState(() {
                                  _isDroughtNotificationEnabled = value!;
                                });
                              },
                            ),
                          ),
                          ListTile(
                            title: const Text('Flood',
                                style: TextStyle(fontSize: 18)),
                            trailing: Checkbox(
                              value: _isFloodNotificationEnabled,
                              activeColor: AppTheme.primaryColor,
                              shape: const CircleBorder(),
                              onChanged: (bool? value) {
                                setState(() {
                                  _isFloodNotificationEnabled = value!;
                                });
                              },
                            ),
                          ),
                          ListTile(
                            title: const Text('Frost',
                                style: TextStyle(fontSize: 18)),
                            trailing: Checkbox(
                              value: _isFrostNotificationEnabled,
                              activeColor: AppTheme.primaryColor,
                              shape: const CircleBorder(),
                              onChanged: (bool? value) {
                                setState(() {
                                  _isFrostNotificationEnabled = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
