import 'package:evergrow_mobile_app/models/soil_moisture.dart';
import 'package:evergrow_mobile_app/models/temperature.dart';
import 'package:evergrow_mobile_app/models/wind.dart';
import 'package:evergrow_mobile_app/screens/menu/chatbot.dart';
import 'package:evergrow_mobile_app/screens/menu/notifications.dart';
import 'package:evergrow_mobile_app/services/waether_service.dart';
import 'package:evergrow_mobile_app/widgets/expandable_weather_section.dart';
import 'package:evergrow_mobile_app/widgets/location_row.dart';
import 'package:evergrow_mobile_app/widgets/weather_messages.dart';
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

          _temperatureMessage = _weatherMessages.generateTemperatureMessage(temperatures);
          _windMessage = _weatherMessages.generateWindMessage(windSpeeds);
          _soilMoistureMessage =
              _weatherMessages.generateSoilMoistureMessage(soilMoistureData, depth);
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
              child: Column(
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
                    iconData: Icons.air,
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
                        _isSoilMoistureExpanded = !_isSoilMoistureExpanded;
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