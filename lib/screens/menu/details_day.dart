import 'package:evergrow_mobile_app/constants.dart';
import 'package:evergrow_mobile_app/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../components/top_section.dart';

class DetailsDay extends StatefulWidget {
  final DateTime selectedDay;
  final List<DateTime> frostDates;
  final List<DateTime> droughtDates;
  final List<DateTime> strongWindDates;
  final List<DateTime> intenseRainDates;

  const DetailsDay({
    super.key,
    required this.selectedDay,
    required this.frostDates,
    required this.droughtDates,
    required this.strongWindDates,
    required this.intenseRainDates,
  });

  @override
  State<DetailsDay> createState() => _DetailsDayState();
}

class _DetailsDayState extends State<DetailsDay> {
  late DateTime _focusedDay;
  late DateTime _selectedNewDay;
  late CalendarFormat _calendarFormat;

  @override
  void initState() {
    super.initState();
    _calendarFormat = CalendarFormat.week;
    _focusedDay = widget.selectedDay;
    _selectedNewDay = widget.selectedDay;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            const TopSection(),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildWeatherHeader(),
                      const SizedBox(height: 20),
                      _buildWeeklyCalendar(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  Widget _buildWeatherHeader() {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        const Text(
          'Weather Calendar',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklyCalendar() {
    return TableCalendar(
      firstDay: DateTime.now().subtract(const Duration(days: 365)),
      lastDay: DateTime.now().add(const Duration(days: 365)),
      focusedDay: _focusedDay,
      calendarFormat: _calendarFormat,
      selectedDayPredicate: (day) {
        return isSameDay(_selectedNewDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedNewDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
      calendarStyle: const CalendarStyle(
        todayDecoration: BoxDecoration(
          color: AppTheme.primaryColor,
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: Color.fromARGB(255, 154, 240, 217),
          shape: BoxShape.circle,
        ),
        selectedTextStyle: TextStyle(
          color: neutral,
          fontWeight: FontWeight.bold,
        ),
        outsideDaysVisible: false,
        defaultTextStyle: TextStyle(color: AppTheme.primaryColor),
      ),
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, day, events) {
          if (widget.frostDates.any((frostDate) => isSameDay(frostDate, day))) {
            return _buildMarker(AppTheme.frostColorStroke);
          }
          if (widget.droughtDates
              .any((droughtDate) => isSameDay(droughtDate, day))) {
            return _buildMarker(AppTheme.droughtColorStroke);
          }
          if (widget.strongWindDates
              .any((strongWindDate) => isSameDay(strongWindDate, day))) {
            return _buildMarker(AppTheme.strongWindsColorStroke);
          }
          if (widget.intenseRainDates
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
