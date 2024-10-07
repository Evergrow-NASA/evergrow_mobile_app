import 'package:flutter/material.dart';
import 'package:evergrow_mobile_app/constants.dart';

class WeatherTag extends StatefulWidget {
  final String label;
  final Color colorFill;
  final Color colorStroke;
  final String imagePath;
  final Function? fetchDates;

  const WeatherTag({
    super.key,
    required this.label,
    required this.colorFill,
    required this.colorStroke,
    required this.imagePath,
    this.fetchDates,
  });

  @override
  State<WeatherTag> createState() => _WeatherTagState();
}

class _WeatherTagState extends State<WeatherTag> {
  bool _isSelected = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_isSelected && widget.fetchDates != null) {
          widget.fetchDates!();
        }
        setState(() {
          _isSelected = !_isSelected;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: _isSelected ? widget.colorFill : Colors.transparent,
          border: Border.all(
            color: _isSelected ? widget.colorStroke : Colors.transparent,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              widget.imagePath,
              width: 16,
              height: 16,
              color: neutral,
            ),
            const SizedBox(width: 8),
            Text(
              widget.label,
              style: const TextStyle(
                color: neutral,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
