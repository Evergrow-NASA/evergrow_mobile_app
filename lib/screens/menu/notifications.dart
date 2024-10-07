import 'package:evergrow_mobile_app/components/bottom_navigation.dart';
import 'package:evergrow_mobile_app/screens/menu/chatbot.dart';
import 'package:evergrow_mobile_app/screens/menu/home.dart';
import 'package:flutter/material.dart';
import '../../components/top_section.dart';
import '../../utils/theme.dart';

class Notifications extends StatefulWidget {
  final String location;
  final double lat;
  final double lng;

  const Notifications(
      {super.key,
      required this.location,
      required this.lat,
      required this.lng});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
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
              location: this.widget.location,
              latitude: this.widget.lat,
              longitude: this.widget.lng),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Notifications'),
                  const SizedBox(height: 10),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'There are no new notifications',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppTheme.secondaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppTheme.primaryColor,
      ),
    );
  }
}
