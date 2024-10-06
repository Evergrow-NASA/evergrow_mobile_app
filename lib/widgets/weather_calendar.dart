import 'package:evergrow_mobile_app/screens/menu/details_day.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../utils/theme.dart';

class WeatherCalendar extends StatelessWidget {
  final bool isCalendarExtend;
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final List<DateTime> frostDates;
  final List<DateTime> droughtDates;
  final List<DateTime> strongWindDates;
  final List<DateTime> intenseRainDates;
  final Function(DateTime, DateTime) onDaySelected;

  const WeatherCalendar({
    super.key,
    required this.isCalendarExtend,
    required this.focusedDay,
    required this.selectedDay,
    required this.frostDates,
    required this.droughtDates,
    required this.strongWindDates,
    required this.intenseRainDates,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    if (!isCalendarExtend) {
      return Container();
    }

    return TableCalendar(
      firstDay: DateTime.now().subtract(const Duration(days: 365)),
      lastDay: DateTime.now().add(const Duration(days: 365)),
      focusedDay: focusedDay,
      selectedDayPredicate: (day) {
        return isSameDay(selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        bool isDrought = droughtDates
            .any((droughtDate) => isSameDay(droughtDate, selectedDay));
        bool isFrost =
            frostDates.any((frostDate) => isSameDay(frostDate, selectedDay));
        bool isStrongWind = strongWindDates
            .any((strongWindDate) => isSameDay(strongWindDate, selectedDay));
        bool isIntenseRain = intenseRainDates
            .any((intenseRainDate) => isSameDay(intenseRainDate, selectedDay));

        if (isDrought || isFrost || isStrongWind || isIntenseRain) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailsDay(
                selectedDay: selectedDay,
                isDroughtSelected: isDrought,
                isFrostSelected: isFrost,
                isStrongWindsSelected: isStrongWind,
                isIntenseRainSelected: isIntenseRain,
              ),
            ),
          );
        }
        onDaySelected(selectedDay, focusedDay);
      },
      calendarStyle: CalendarStyle(
        todayDecoration: const BoxDecoration(
          color: AppTheme.primaryColor,
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: AppTheme.primaryColor,
          border: Border.all(color: AppTheme.accentColor, width: 1),
          shape: BoxShape.circle,
        ),
        outsideDaysVisible: false,
        defaultTextStyle: const TextStyle(color: AppTheme.primaryColor),
      ),
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, day, events) {
          if (frostDates.any((frostDate) => isSameDay(frostDate, day))) {
            return _buildMarker(AppTheme.frostColorStroke);
          }

          if (droughtDates.any((droughtDate) => isSameDay(droughtDate, day))) {
            return _buildMarker(AppTheme.droughtColorStroke);
          }

          if (strongWindDates
              .any((strongWindDate) => isSameDay(strongWindDate, day))) {
            return _buildMarker(AppTheme.strongWindsColorStroke);
          }

          if (intenseRainDates
              .any((intenseRainDate) => isSameDay(intenseRainDate, day))) {
            return _buildMarker(AppTheme.intenseRainColorStroke);
          }

          return null;
        },
      ),
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
    );
  }

  Widget _buildMarker(Color color) {
    return Container(
      width: 40,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.transparent,
        shape: BoxShape.circle,
        border: Border.fromBorderSide(BorderSide(color: color, width: 1)),
      ),
    );
  }
}
