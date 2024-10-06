import 'package:evergrow_mobile_app/models/temperature.dart';
import 'package:evergrow_mobile_app/screens/menu/notifications.dart';
import 'package:evergrow_mobile_app/services/meteomatic_service.dart';
import 'package:evergrow_mobile_app/services/waether_service.dart';
import 'package:evergrow_mobile_app/widgets/weather_tag.dart';
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

  List<DateTime> _frostDates = [];
  bool _isFrostSelected = false;
  List<DateTime> _droughtDates = [];
  bool _isDroughtSelected = false;
  List<DateTime> _strongWindDates = [];
  bool _isStrongWindsSelected = false;
  List<DateTime> _intenseRainDates = [];
  bool _isIntenseRainSelected = false;

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
    _fetchFrostDates();
    _fetchDroughtDates();
    _fetchStrongWindDates();
    _fetchIntenseRainDates();
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

  Future<void> _fetchFrostDates() async {
    MeteomaticsService meteomaticsService = MeteomaticsService();
    try {
      List<DateTime> frostDates =
          await meteomaticsService.fetchFrostDates(widget.lat, widget.lng);
      setState(() {
        _frostDates = frostDates;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error al obtener las fechas de helada: $e');
    }
  }

  Future<void> _fetchDroughtDates() async {
    MeteomaticsService meteomaticsService = MeteomaticsService();
    try {
      List<DateTime> droughtDates =
          await meteomaticsService.fetchDroughtDates(widget.lat, widget.lng);
      setState(() {
        _droughtDates = droughtDates;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error al obtener las fechas de sequía: $e');
    }
  }

  Future<void> _fetchStrongWindDates() async {
    MeteomaticsService meteomaticsService = MeteomaticsService();
    try {
      List<DateTime> strongWindDates =
          await meteomaticsService.fetchStrongWindDates(widget.lat, widget.lng);
      setState(() {
        _strongWindDates = strongWindDates;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error al obtener las fechas de vientos fuertes: $e');
    }
  }

  Future<void> _fetchIntenseRainDates() async {
    MeteomaticsService meteomaticsService = MeteomaticsService();
    try {
      List<DateTime> intenseRainDates =
          await meteomaticsService.fetchHeavyRainDates(widget.lat, widget.lng);
      setState(() {
        _intenseRainDates = intenseRainDates;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error al obtener las fechas de lluvias intensas: $e');
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
      // return const SoilMoistureScreen();
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
                  _buildSectionTitle('Temperature'),
                  const SizedBox(height: 10),
                  const Text(
                    'Sunny conditions will continue up to 6 pm',
                    style:
                        TextStyle(fontSize: 14, color: AppTheme.secondaryColor),
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
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
          String hour = _extractHour(data.time);
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

  String _extractHour(String time) {
    int hourInt = int.parse(time.split(':')[0]);
    String period = hourInt >= 12 ? 'p.m.' : 'a.m.';

    hourInt = hourInt > 12
        ? hourInt - 12
        : hourInt == 0
            ? 12
            : hourInt;

    return '$hourInt $period';
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
        _buildSectionTitle('Weather calendar'),
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
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          WeatherTag(
            label: 'Drought',
            colorFill: AppTheme.droughtColorFill,
            colorStroke: AppTheme.droughtColorStroke,
            imagePath: 'assets/icons/drought.png',
            fetchDates: () {
              setState(() {
                _isDroughtSelected = !_isDroughtSelected;
                if (_isDroughtSelected) {
                  _fetchDroughtDates();
                } else {
                  _droughtDates.clear();
                }
              });
            },
          ),
          const SizedBox(width: 8),
          WeatherTag(
            label: 'Intense rain',
            colorFill: AppTheme.intenseRainColorFill,
            colorStroke: AppTheme.intenseRainColorStroke,
            imagePath: 'assets/icons/intense_rain.png',
            fetchDates: () {
              setState(() {
                _isIntenseRainSelected = !_isIntenseRainSelected;
                if (_isIntenseRainSelected) {
                  _fetchIntenseRainDates();
                } else {
                  _intenseRainDates.clear();
                }
              });
            },
          ),
          const SizedBox(width: 8),
          WeatherTag(
            label: 'Frost',
            colorFill: AppTheme.frostColorFill,
            colorStroke: AppTheme.frostColorStroke,
            imagePath: 'assets/icons/frost.png',
            fetchDates: () {
              setState(() {
                _isFrostSelected = !_isFrostSelected;
                if (_isFrostSelected) {
                  _fetchFrostDates();
                } else {
                  _frostDates.clear();
                }
              });
            },
          ),
          const SizedBox(width: 8),
          WeatherTag(
            label: 'Strong winds',
            colorFill: AppTheme.strongWindsColorFill,
            colorStroke: AppTheme.strongWindsColorStroke,
            imagePath: 'assets/icons/strong_winds.png',
            fetchDates: () {
              setState(() {
                _isStrongWindsSelected = !_isStrongWindsSelected;
                if (_isStrongWindsSelected) {
                  _fetchStrongWindDates();
                } else {
                  _strongWindDates.clear();
                }
              });
            },
          ),
        ],
      ),
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
          color: AppTheme.primaryColor,
          border: Border.all(color: AppTheme.accentColor, width: 1),
          shape: BoxShape.circle,
        ),
        outsideDaysVisible: false,
        defaultTextStyle: const TextStyle(color: AppTheme.primaryColor),
      ),
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, day, events) {
          bool isSameDay(DateTime a, DateTime b) {
            return a.year == b.year && a.month == b.month && a.day == b.day;
          }

          if (_frostDates.any((frostDate) => isSameDay(frostDate, day))) {
            return Container(
              width: 40,
              height: 50,
              decoration: const BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
                border: Border.fromBorderSide(
                  BorderSide(color: AppTheme.frostColorStroke, width: 1),
                ),
              ),
            );
          }

          if (_droughtDates.any((droughtDate) => isSameDay(droughtDate, day))) {
            return Container(
              width: 40,
              height: 50,
              decoration: const BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
                border: Border.fromBorderSide(
                  BorderSide(color: AppTheme.droughtColorStroke, width: 1),
                ),
              ),
            );
          }

          if (_strongWindDates
              .any((strongWindDate) => isSameDay(strongWindDate, day))) {
            return Container(
              width: 40,
              height: 50,
              decoration: const BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
                border: Border.fromBorderSide(
                  BorderSide(color: AppTheme.strongWindsColorStroke, width: 1),
                ),
              ),
            );
          }

          if (_intenseRainDates
              .any((intenseRainDate) => isSameDay(intenseRainDate, day))) {
            return Container(
              width: 40,
              height: 50,
              decoration: const BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
                border: Border.fromBorderSide(
                  BorderSide(color: AppTheme.intenseRainColorStroke, width: 1),
                ),
              ),
            );
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
          style: const TextStyle(fontSize: 12, color: AppTheme.secondaryColor),
        ),
      ],
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
