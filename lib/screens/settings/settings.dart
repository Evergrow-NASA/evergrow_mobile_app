import 'package:evergrow_mobile_app/components/bottom_navigation.dart';
import 'package:evergrow_mobile_app/screens/menu/chatbot.dart';
import 'package:evergrow_mobile_app/screens/menu/home.dart';
import 'package:evergrow_mobile_app/screens/menu/notifications.dart';
import 'package:evergrow_mobile_app/screens/settings/unit_of_measurement_settings.dart';
import 'package:flutter/material.dart';
import '../../components/top_section.dart';
import '../../utils/theme.dart';

class SettingsPage extends StatefulWidget {
  final String location;
  final double lat;
  final double lng;

  const SettingsPage(
      {super.key,
      required this.location,
      required this.lat,
      required this.lng});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ChatbotScreen(
                location: widget.location, lat: widget.lat, lng: widget.lng)),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Home(widget.location, widget.lat, widget.lng),
        ),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Notifications(
                location: widget.location, lat: widget.lat, lng: widget.lng),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TopSection(
            location: widget.location,
            latitude: widget.lat,
            longitude: widget.lng,
          ),
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
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Home(
                                    widget.location, widget.lat, widget.lng),
                              ),
                            );
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
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Notifications(
                                        location: widget.location,
                                        lat: widget.lat,
                                        lng: widget.lng),
                                  ));
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
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        UnitOfMeasurementSettingsPage(
                                            location: widget.location,
                                            lat: widget.lat,
                                            lng: widget.lng)),
                              );
                            },
                            child: const ListTile(
                              title: Text('Unit of measurement',
                                  style: TextStyle(fontSize: 18)),
                              trailing: Icon(Icons.arrow_forward_ios,
                                  color: Color.fromARGB(255, 7, 7, 35)),
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
      bottomNavigationBar: BottomNavigation(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
