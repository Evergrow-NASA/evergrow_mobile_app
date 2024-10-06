import 'package:evergrow_mobile_app/widgets/weather_icon.dart';
import 'package:flutter/material.dart';
import '../../utils/theme.dart';

class ExpandableWeatherSection extends StatelessWidget {
  final String title;
  final String message;
  final IconData iconData;
  final List<String> data;
  final List<String> times;
  final List<double>? directions;
  final Widget? child;
  final bool isExpanded;
  final VoidCallback onExpandToggle;

  const ExpandableWeatherSection({
    super.key,
    required this.title,
    required this.message,
    required this.iconData,
    required this.data,
    required this.times,
    this.directions,
    this.child,
    required this.isExpanded,
    required this.onExpandToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
            IconButton(
              onPressed: onExpandToggle, 
              icon: Icon(
                isExpanded ? Icons.expand_less : Icons.expand_more,
                color: AppTheme.primaryColor,
              ),
            ),
          ],
        ),
        if (isExpanded) _calendar(), 
      ],
    );
  }

  Widget _calendar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: 8),
        Text(
          message,
          style: const TextStyle(fontSize: 14, color: AppTheme.secondaryColor),
        ),
        const Divider(height: 30, color: AppTheme.secondaryColor),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(data.length, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: WeatherIcon(
                  iconData: iconData,
                  value: data[index],
                  time: times[index],
                  direction: directions != null ? directions![index] : null,
                ),
              );
            }),
          ),
        ),
        if (child != null) child!, 
      ],
    );
  }
}
