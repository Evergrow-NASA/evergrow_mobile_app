import 'package:evergrow_mobile_app/screens/settings/settings.dart';
import 'package:flutter/material.dart';
import '../utils/theme.dart';

class TopSection extends StatelessWidget {
  final String? location;
  final double? latitude;
  final double? longitude;

  const TopSection({super.key, this.location, this.latitude, this.longitude});

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name;

    return Stack(
      children: [
        ClipPath(
          clipper: CustomClipPath(),
          child: Container(
            height: 120,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/top_crop.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Positioned(
          top: 40,
          left: 20,
          child: Row(
            children: [
              Image.asset(
                'assets/logo.png',
                height: 40,
              ),
              const SizedBox(width: 8),
              const Text(
                'Evergrow',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        if (currentRoute != '/settings')
          Positioned(
            top: 50,
            right: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsPage(
                      location: location!,
                      lat: latitude!,
                      lng: longitude!,
                    ),
                  ),
                );
              },
              child: const Icon(
                Icons.settings,
                color: AppTheme.primaryColor,
                size: 30,
              ),
            ),
          ),
      ],
    );
  }
}

class CustomClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 0.8);

    var firstControlPoint = Offset(size.width * 0.25, size.height);
    var secondControlPoint = Offset(size.width * 0.65, size.height - 75);
    var secondEndPoint = Offset(size.width, size.height - 80);

    path.cubicTo(
        firstControlPoint.dx,
        firstControlPoint.dy,
        secondControlPoint.dx,
        secondControlPoint.dy,
        secondEndPoint.dx,
        secondEndPoint.dy);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
