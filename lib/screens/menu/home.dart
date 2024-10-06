import 'package:evergrow_mobile_app/models/temperature_data.dart';
import 'package:evergrow_mobile_app/screens/menu/chatbot.dart';
import 'package:evergrow_mobile_app/screens/menu/notifications.dart';
import 'package:evergrow_mobile_app/services/waether_service.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../components/top_section.dart';
import '../../components/bottom_navigation.dart';
import '../../utils/theme.dart';

class Home extends StatefulWidget {
  final String location;
  final double lat;
  final double lng;

  const Home(this.lat, this.lng, this.location, {super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool _isFilterVisible = false;
  int _selectedIndex = 1;
  List<Temperature> _weatherData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  Future<void> _fetchWeatherData() async {
    WeatherService weatherService = WeatherService();
    try {
      List<Temperature>? temperatures =
          await weatherService.fetchHourlyTemperature(widget.lat, widget.lng);
      if (temperatures != null) {
        setState(() {
          _weatherData = temperatures;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getContentWidget(_selectedIndex),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _getContentWidget(int index) {
    switch (index) {
      case 0:
       return const ChatbotScreen();
      case 1:
        return _buildHomeContent();
      case 2:
        return const Notifications();
      default:
        return _buildHomeContent();
    }
  }

  Widget _buildHomeContent() {
    return Column(
      children: [
        const TopSection(),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLocationRow(),
                  const SizedBox(height: 20),
                  _buildSectionTitle('Temperatura'),
                  const SizedBox(height: 10),
                  const Text(
                    'Condiciones soleadas continuarán hasta las 6 p.m.',
                    style: TextStyle(
                        fontSize: 14, color: AppTheme.secondaryColor),
                  ),
                  const Divider(height: 30, color: AppTheme.secondaryColor),
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _buildWeatherIcons(),
                  const SizedBox(height: 25),
                  _buildWeatherCalendarHeader(),
                  const SizedBox(height: 10),
                  AnimatedCrossFade(
                    firstChild: _buildWeatherTags(),
                    secondChild: Container(),
                    crossFadeState: _isFilterVisible
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    duration: const Duration(milliseconds: 300),
                  ),
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
        Expanded(
          child: Text(
            widget.location,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherIcons() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _weatherData.map((data) {
          String hour = _extractHour(data.date);
          IconData weatherIcon = _getWeatherIcon(data.temperature);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: _buildWeatherIcon(
              weatherIcon,
              '${data.temperature}°C',
              hour,
            ),
          );
        }).toList(),
      ),
    );
  }

    String _extractHour(String dateTimeKey) {
    String hour = dateTimeKey.substring(8);
    int hourInt = int.parse(hour);
    String period = hourInt >= 12 ? 'PM' : 'AM';
    hourInt = hourInt > 12 ? hourInt - 12 : hourInt == 0 ? 12 : hourInt;
    return '$hourInt:00 $period';
  }

  IconData _getWeatherIcon(double temperature) {
    if (temperature >= 30) {
      return Icons.wb_sunny; 
    } else if (temperature >= 20) {
      return Icons.wb_cloudy; 
    } else {
      return Icons.ac_unit; 
    }
  }

  Widget _buildWeatherCalendarHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildSectionTitle('Calendario Climático'),
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
        _buildWeatherTag('Sequía', AppTheme.accentColor),
        const SizedBox(width: 8),
        _buildWeatherTag('Inundación', AppTheme.floodColor),
        const SizedBox(width: 8),
        _buildWeatherTag('Helada', AppTheme.frostColor),
      ],
    );
  }

  Widget _buildTableCalendar() {
    return TableCalendar(
      firstDay: DateTime.now().subtract(const Duration(days: 365)),
      lastDay: DateTime.now().add(const Duration(days: 365)),
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
        selectedTextStyle:
            const TextStyle(color: AppTheme.primaryColor),
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
      style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppTheme.primaryColor),
    );
  }
}