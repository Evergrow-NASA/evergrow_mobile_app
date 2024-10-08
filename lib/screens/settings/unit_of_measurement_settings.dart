import 'package:evergrow_mobile_app/components/bottom_navigation.dart';
import 'package:evergrow_mobile_app/components/top_section.dart';
import 'package:evergrow_mobile_app/screens/menu/chatbot.dart';
import 'package:evergrow_mobile_app/screens/menu/home.dart';
import 'package:evergrow_mobile_app/screens/menu/notifications.dart';
import 'package:evergrow_mobile_app/screens/settings/settings.dart';
import 'package:evergrow_mobile_app/utils/theme.dart';
import 'package:flutter/material.dart';

class UnitOfMeasurementSettingsPage extends StatefulWidget {
  final String location;
  final double lat;
  final double lng;

  const UnitOfMeasurementSettingsPage(
      {super.key,
      required this.location,
      required this.lat,
      required this.lng});

  @override
  State<UnitOfMeasurementSettingsPage> createState() =>
      _UnitOfMeasurementSettingsPageState();
}

class _UnitOfMeasurementSettingsPageState
    extends State<UnitOfMeasurementSettingsPage> {
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

  bool _isCelciusSelected = false;
  bool _isKilometersSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TopSection(
              location: widget.location,
              latitude: widget.lat,
              longitude: widget.lng),
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
                                  builder: (context) => SettingsPage(
                                      location: widget.location,
                                      lat: widget.lat,
                                      lng: widget.lng)),
                            );
                          },
                        ),
                        const Text(
                          'Unit of measurement\nsettings',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        )
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
                            'Temperature',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ListTile(
                            title: const Text('Celcius (ºC)',
                                style: TextStyle(fontSize: 18)),
                            trailing: Radio<bool>(
                              value: true,
                              groupValue: _isCelciusSelected,
                              activeColor: AppTheme.primaryColor,
                              onChanged: (bool? value) {
                                setState(() {
                                  _isCelciusSelected = value!;
                                });
                              },
                            ),
                          ),
                          ListTile(
                            title: const Text('Ferenheit (ºF)',
                                style: TextStyle(fontSize: 18)),
                            trailing: Radio<bool>(
                              value: false,
                              groupValue: _isCelciusSelected,
                              activeColor: AppTheme.primaryColor,
                              onChanged: (bool? value) {
                                setState(() {
                                  _isCelciusSelected = value!;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Temperature',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ListTile(
                            title: const Text('Kilometers per hour (km/h)',
                                style: TextStyle(fontSize: 18)),
                            trailing: Radio<bool>(
                              value: true,
                              groupValue: _isKilometersSelected,
                              activeColor: AppTheme.primaryColor,
                              onChanged: (bool? value) {
                                setState(() {
                                  _isKilometersSelected = value!;
                                });
                              },
                            ),
                          ),
                          ListTile(
                            title: const Text('Miles per hour (mph)',
                                style: TextStyle(fontSize: 18)),
                            trailing: Radio<bool>(
                              value: false,
                              groupValue: _isKilometersSelected,
                              activeColor: AppTheme.primaryColor,
                              onChanged: (bool? value) {
                                setState(() {
                                  _isKilometersSelected = value!;
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
      bottomNavigationBar: BottomNavigation(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
