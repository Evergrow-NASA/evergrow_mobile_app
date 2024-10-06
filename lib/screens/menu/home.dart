import 'package:evergrow_mobile_app/models/soil_moisture.dart';
import 'package:evergrow_mobile_app/models/temperature.dart';
import 'package:evergrow_mobile_app/models/wind.dart';
import 'package:evergrow_mobile_app/screens/menu/chatbot.dart';
import 'package:evergrow_mobile_app/screens/menu/notifications.dart';
import 'package:evergrow_mobile_app/services/meteomatic_service.dart';
import 'package:evergrow_mobile_app/services/waether_service.dart';
import 'package:evergrow_mobile_app/utils/theme.dart';
import 'package:evergrow_mobile_app/widgets/expandable_weather_section.dart';
import 'package:evergrow_mobile_app/widgets/location_row.dart';
import 'package:evergrow_mobile_app/widgets/weather_calendar.dart';
import 'package:evergrow_mobile_app/widgets/weather_messages.dart';
import 'package:evergrow_mobile_app/widgets/weather_tags.dart';
import 'package:flutter/material.dart';
import '../../components/top_section.dart';
import '../../components/bottom_navigation.dart';

class Home extends StatefulWidget {
  final String location;
  final double lat;
  final double lng;

  const Home(this.lat, this.lng, this.location, {super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 1;
  List<String> _windData = [];
  List<double> _windDirections = [];
  List<String> _windTimes = [];
  List<String> _soilMoistureData = [];
  List<String> _soilMoistureTimes = [];

  List<String> _temperatureData = [];
  List<String> _temperatureTimes = [];

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool _isFilterVisible = false;
  bool _isCalendarExtend = false;

  bool _isLoading = true;

  List<DateTime> _frostDates = [];
  bool _isFrostSelected = false;
  List<DateTime> _droughtDates = [];
  bool _isDroughtSelected = false;
  List<DateTime> _strongWindDates = [];
  bool _isStrongWindsSelected = false;
  List<DateTime> _intenseRainDates = [];
  bool _isIntenseRainSelected = false;

  String _temperatureMessage = '';
  String _windMessage = '';
  String _soilMoistureMessage = '';

  bool _isTemperatureExpanded = false;
  bool _isWindExpanded = false;
  bool _isSoilMoistureExpanded = false;

  final WeatherMessages _weatherMessages = WeatherMessages();
  @override
  void initState() {
    super.initState();

    _fetchWeatherData();
    _fetchFrostDates();
    _fetchDroughtDates();
    _fetchStrongWindDates();
    _fetchIntenseRainDates();
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

  Future<void> _fetchWeatherData() async {
    WeatherService weatherService = WeatherService();
    try {
      List<Temperature>? temperatures =
          await weatherService.fetchHourlyTemperature(widget.lat, widget.lng);

      List<WindSpeed>? windSpeeds =
          await weatherService.fetchWindSpeed(widget.lat, widget.lng);
      List<WindDirection>? windDirections =
          await weatherService.fetchWindDirection(widget.lat, widget.lng);

      String depth = '-15cm';
      List<SoilMoisture>? soilMoistureData =
          await weatherService.fetchSoilMoisture(widget.lat, widget.lng, depth);

      if (temperatures != null &&
          windSpeeds != null &&
          windDirections != null &&
          soilMoistureData != null) {
        setState(() {
          _temperatureData =
              temperatures.map((data) => '${data.temperature}°C').toList();
          _temperatureTimes =
              temperatures.map((data) => _extractHour(data.time)).toList();

          _windData = windSpeeds.map((wind) => '${wind.speed} km/h').toList();
          _windDirections =
              windDirections.map((wind) => wind.direction).toList();
          _windTimes =
              windSpeeds.map((wind) => _extractHour(wind.time)).toList();

          _soilMoistureData = soilMoistureData
              .map((soil) => '${(soil.moisture * 100).toStringAsFixed(1)} %')
              .toList();
          _soilMoistureTimes =
              soilMoistureData.map((soil) => _extractHour(soil.time)).toList();

          _temperatureMessage =
              _weatherMessages.generateTemperatureMessage(temperatures);
          _windMessage = _weatherMessages.generateWindMessage(windSpeeds);
          _soilMoistureMessage = _weatherMessages.generateSoilMoistureMessage(
              soilMoistureData, depth);
        });
      }
    } catch (e) {
      setState(() {
        // Manejo del error
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
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LocationRow(location: widget.location),
                        const SizedBox(height: 30),
                        ExpandableWeatherSection(
                          title: 'Temperature',
                          message: _temperatureMessage,
                          iconData: Icons.wb_sunny,
                          data: _temperatureData,
                          times: _temperatureTimes,
                          isExpanded: _isTemperatureExpanded,
                          onExpandToggle: () {
                            setState(() {
                              _isTemperatureExpanded = !_isTemperatureExpanded;
                            });
                          },
                        ),
                        const SizedBox(height: 25),
                        ExpandableWeatherSection(
                          title: 'Wind',
                          message: _windMessage,
                          iconData: Icons.arrow_right_alt,
                          data: _windData,
                          times: _windTimes,
                          directions: _windDirections,
                          isExpanded: _isWindExpanded,
                          onExpandToggle: () {
                            setState(() {
                              _isWindExpanded = !_isWindExpanded;
                            });
                          },
                        ),
                        const SizedBox(height: 25),
                        ExpandableWeatherSection(
                          title: 'Soil moisture',
                          message: _soilMoistureMessage,
                          iconData: Icons.water_drop,
                          data: _soilMoistureData,
                          times: _soilMoistureTimes,
                          isExpanded: _isSoilMoistureExpanded,
                          onExpandToggle: () {
                            setState(() {
                              _isSoilMoistureExpanded =
                                  !_isSoilMoistureExpanded;
                            });
                          },
                        ),
                        const SizedBox(height: 25),
                        _buildWeatherCalendarHeader(),
                        if (_isFilterVisible) const SizedBox(height: 10),
                        WeatherTags(
                          isFilterVisible: _isFilterVisible,
                          toggleDroughtFilter: () {
                            setState(() {
                              _isDroughtSelected = !_isDroughtSelected;
                            });
                          },
                          toggleRainFilter: () {
                            setState(() {
                              _isIntenseRainSelected = !_isIntenseRainSelected;
                            });
                          },
                          toggleFrostFilter: () {
                            setState(() {
                              _isFrostSelected = !_isFrostSelected;
                            });
                          },
                          toggleWindFilter: () {
                            setState(() {
                              _isStrongWindsSelected = !_isStrongWindsSelected;
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                        if (_isCalendarExtend)
                          WeatherCalendar(
                            isCalendarExtend: _isCalendarExtend,
                            focusedDay: _focusedDay,
                            selectedDay: _selectedDay,
                            frostDates: _frostDates,
                            droughtDates: _droughtDates,
                            strongWindDates: _strongWindDates,
                            intenseRainDates: _intenseRainDates,
                            latitude: widget.lat,
                            longitude: widget.lng,
                            onDaySelected: (selectedDay, focusedDay) {
                              setState(() {
                                _selectedDay = selectedDay;
                                _focusedDay = focusedDay;
                              });
                            },
                          ),
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherCalendarHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Weather Calendar',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),
        Row(
          children: [
            if (_isCalendarExtend)
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
            IconButton(
              onPressed: () {
                setState(() {
                  _isCalendarExtend = !_isCalendarExtend;
                  if (!_isCalendarExtend) {
                    _isFilterVisible = false;
                  }
                });
              },
              icon: Icon(
                _isCalendarExtend ? Icons.expand_less : Icons.expand_more,
                color: AppTheme.primaryColor,
              ),
            ),
          ],
        ),
      ],
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
}
