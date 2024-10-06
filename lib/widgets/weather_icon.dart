import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../utils/theme.dart';

class WeatherIcon extends StatelessWidget {
  final IconData iconData;
  final String value;
  final String time;
  final double? direction;

  const WeatherIcon({
    super.key,
    required this.iconData,
    required this.value,
    required this.time,
    this.direction,
  });

  @override
  Widget build(BuildContext context) {
    IconData weatherIcon = iconData;

    if (iconData == Icons.water_drop) {
      return _ishumidity(value, weatherIcon, time);
    } else {
      if (iconData == Icons.wb_sunny) {
        double temperature = double.parse(value.replaceAll('°C', ''));
        

        if (temperature < 10) {
          weatherIcon = Icons.ac_unit;
        } else if (temperature < 20) {
          weatherIcon = Icons.cloud;
        } else if (temperature < 30) {
          weatherIcon = Icons.wb_cloudy;
        } else if (temperature < 40) {
          weatherIcon = Icons.wb_sunny;
        } else {
          weatherIcon = Icons.wb_incandescent;
        }
      }

      return Column(
        children: [
          Transform.rotate(
            angle: direction != null ? direction! * (math.pi / 180) : 0,
            child: Icon(weatherIcon, size: 35, color: AppTheme.primaryColor),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor),
          ),
          Text(
            time,
            style:
                const TextStyle(fontSize: 12, color: AppTheme.secondaryColor),
          ),
        ],
      );
    }
  }

  
  Widget _ishumidity(String value, IconData weatherIcon, String time ){
    double moisturePercentage = double.parse(value.replaceAll('%', '')) / 100.0;
    return Column(
      children: [
        SizedBox(
          height: 40,
          width: 40,
          child: Stack(
            children: [
              Icon(
                weatherIcon,
                size: 40,
                color: Colors.grey,
              ),
              ClipRect(
                clipper: _MoistureClipper(moisturePercentage),
                child: Icon(
                  weatherIcon,
                  size: 40,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor),
        ),
        Text(
          time,
          style: const TextStyle(fontSize: 12, color: AppTheme.secondaryColor),
        ),
      ],
    );
  }


 
}


class _MoistureClipper extends CustomClipper<Rect> {
  final double percentage;

  _MoistureClipper(this.percentage);

  @override
  Rect getClip(Size size) {
    double height = size.height * percentage;
    return Rect.fromLTWH(0, size.height - height, size.width, height);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) {
    return true;
  }
} 