import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../components/top_section.dart';
import '../../components/bottom_navigation.dart';
import '../../utils/theme.dart';


const List<Map<String, String>> weatherData = [
  {'icon': 'wb_sunny', 'temp': '23°', 'time': 'Now'},
  {'icon': 'wb_sunny', 'temp': '22°', 'time': '6 p.m.'},
  {'icon': 'wb_cloudy', 'temp': '21°', 'time': '7 p.m.'},
  {'icon': 'wb_sunny', 'temp': '21°', 'time': '8 p.m.'},
  {'icon': 'snowflake', 'temp': '18°', 'time': '9 p.m.'},
  {'icon': 'snowflake', 'temp': '0°', 'time': '10 p.m.'},
];

class Home extends StatefulWidget {
  final String location;

  const Home({super.key, this.location = 'Ayacucho, Perú'});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool _isFilterVisible = false;
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          Container(), 
          _buildHomeContent(),
          Container(), 
        ],
      ),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _buildHomeContent() {
    return Column(
      children: [
        const TopSection(),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLocationRow(),
                  const SizedBox(height: 20),
                  _buildSectionTitle('Temperature'),
                  const SizedBox(height: 10),
                  const Text(
                    'Sunny conditions will continue up to 6 p.m.',
                    style: TextStyle(fontSize: 14, color: AppTheme.secondaryColor),
                  ),
                  const Divider(height: 30, color: AppTheme.secondaryColor),
                  _buildWeatherIcons(),
                  const SizedBox(height: 25),
                  _buildWeatherCalendarHeader(),
                  const SizedBox(height: 10),
                  if (_isFilterVisible) _buildWeatherTags(),
                  const SizedBox(height: 15),
                  _buildTableCalendar(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  
  Widget _buildLocationRow() {
    return Row(
      children: [
        const Icon(Icons.location_on, color: AppTheme.primaryColor),
        const SizedBox(width: 8),
        Text(
          widget.location,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildWeatherIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: weatherData.map((data) {
        return _buildWeatherIcon(
          data['icon'] == 'wb_sunny'
              ? Icons.wb_sunny
              : data['icon'] == 'wb_cloudy'
                  ? Icons.wb_cloudy
                  : FontAwesomeIcons.snowflake,
          data['temp']!,
          data['time']!,
        );
      }).toList(),
    );
  }

  Widget _buildWeatherCalendarHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildSectionTitle('Weather Calendar'),
        IconButton(
          icon: Icon(
            _isFilterVisible ? Icons.filter_alt_off : Icons.filter_alt,
            color: AppTheme.primaryColor,
          ),
          onPressed: () {
            setState(() {
              _isFilterVisible = !_isFilterVisible;
            });
          },
        ),
      ],
    );
  }

  Widget _buildWeatherTags() {
    return Row(
      children: [
        _buildWeatherTag('Drought', AppTheme.accentColor),
        const SizedBox(width: 8),
        _buildWeatherTag('Flood', AppTheme.floodColor),
        const SizedBox(width: 8),
        _buildWeatherTag('Frost', AppTheme.frostColor),
      ],
    );
  }
  
  Widget _buildTableCalendar() {
    return TableCalendar(
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
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
          color: Colors.white,
          border: Border.all(color: AppTheme.accentColor, width: 1),
          shape: BoxShape.circle,
        ),
        outsideDaysVisible: false,
        selectedTextStyle: const TextStyle(color: AppTheme.primaryColor),
      ),
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
    );
  }

  Widget _buildWeatherIcon(IconData icon, String temp, String time) {
    return Column(
      children: [
        Icon(icon, size: 35, color: AppTheme.primaryColor),
        const SizedBox(height: 4),
        Text(
          temp,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
        ),
        Text(time, style: const TextStyle(fontSize: 12, color: AppTheme.secondaryColor)),
      ],
    );
  }
  
  Widget _buildWeatherTag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        border: Border.all(color: color, width: 1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
    );
  }
}
