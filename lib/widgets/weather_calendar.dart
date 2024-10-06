import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../utils/theme.dart';

class WeatherCalendar extends StatefulWidget {
  final List<DateTime> frostDates;
  final List<DateTime> droughtDates;
  final List<DateTime> strongWindDates;
  final List<DateTime> intenseRainDates;

  const WeatherCalendar({
    super.key,
    required this.frostDates,
    required this.droughtDates,
    required this.strongWindDates,
    required this.intenseRainDates,
  });

  @override
  State<WeatherCalendar> createState() => _WeatherCalendarState();
}

class _WeatherCalendarState extends State<WeatherCalendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.now().subtract(const Duration(days: 365)),
      lastDay: DateTime.now().add(const Duration(days: 365)),
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay!, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
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
          if (widget.frostDates.any((frostDate) => isSameDay(frostDate, day))) {
            return _buildMarker(AppTheme.frostColorStroke);
          }
          if (widget.droughtDates.any((droughtDate) => isSameDay(droughtDate, day))) {
            return _buildMarker(AppTheme.droughtColorStroke);
          }
          if (widget.strongWindDates.any((strongWindDate) => isSameDay(strongWindDate, day))) {
            return _buildMarker(AppTheme.strongWindsColorStroke);
          }
          if (widget.intenseRainDates.any((intenseRainDate) => isSameDay(intenseRainDate, day))) {
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

  Widget _buildMarker(Color borderColor) {
    return Container(
      width: 40,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.transparent,
        shape: BoxShape.circle,
        border: Border.fromBorderSide(BorderSide(color: borderColor, width: 1)),
      ),
    );
  }
}
