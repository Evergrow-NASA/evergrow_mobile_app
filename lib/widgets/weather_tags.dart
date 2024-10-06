import 'package:evergrow_mobile_app/utils/theme.dart';
import 'package:evergrow_mobile_app/widgets/weather_tag.dart';
import 'package:flutter/material.dart';

class WeatherTags extends StatelessWidget {
  final bool isFilterVisible;
  final Function() toggleDroughtFilter;
  final Function() toggleRainFilter;
  final Function() toggleFrostFilter;
  final Function() toggleWindFilter;

  const WeatherTags({
    super.key,
    required this.isFilterVisible,
    required this.toggleDroughtFilter,
    required this.toggleRainFilter,
    required this.toggleFrostFilter,
    required this.toggleWindFilter,
  });

  @override
  Widget build(BuildContext context) {
    if (!isFilterVisible) return Container();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          WeatherTag(
            label: 'Drought',
            colorFill: AppTheme.droughtColorFill,
            colorStroke: AppTheme.droughtColorStroke,
            imagePath: 'assets/icons/drought.png',
            fetchDates: toggleDroughtFilter,
          ),
          const SizedBox(width: 8),
          WeatherTag(
            label: 'Intense rain',
            colorFill: AppTheme.intenseRainColorFill,
            colorStroke: AppTheme.intenseRainColorStroke,
            imagePath: 'assets/icons/intense_rain.png',
            fetchDates: toggleRainFilter,
          ),
          const SizedBox(width: 8),
          WeatherTag(
            label: 'Frost',
            colorFill: AppTheme.frostColorFill,
            colorStroke: AppTheme.frostColorStroke,
            imagePath: 'assets/icons/frost.png',
            fetchDates: toggleFrostFilter,
          ),
          const SizedBox(width: 8),
          WeatherTag(
            label: 'Strong winds',
            colorFill: AppTheme.strongWindsColorFill,
            colorStroke: AppTheme.strongWindsColorStroke,
            imagePath: 'assets/icons/strong_winds.png',
            fetchDates: toggleWindFilter,
          ),
        ],
      ),
    );
  }
}
