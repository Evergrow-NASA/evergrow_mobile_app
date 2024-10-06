import 'package:flutter/material.dart';
import '../../components/top_section.dart';
import '../../utils/theme.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

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
                          'Settings',
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
                            'General',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                          const SizedBox(height: 10),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, '/notifications_settings');
                            },
                            child: const ListTile(
                              title: Text('Notifications',
                                  style: TextStyle(fontSize: 18)),
                              trailing: Icon(Icons.arrow_forward_ios,
                                  color: AppTheme.primaryColor),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, '/location');
                            },
                            child: const ListTile(
                              title: Text('Location',
                                  style: TextStyle(fontSize: 18)),
                              trailing: Icon(Icons.arrow_forward_ios,
                                  color: AppTheme.primaryColor),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, '/unit_of_measurement_settings');
                            },
                            child: const ListTile(
                              title: Text('Unit of measurement',
                                  style: TextStyle(fontSize: 18)),
                              trailing: Icon(Icons.arrow_forward_ios,
                                  color: AppTheme.primaryColor),
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
