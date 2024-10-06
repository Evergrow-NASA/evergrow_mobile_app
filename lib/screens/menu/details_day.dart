import 'package:evergrow_mobile_app/constants.dart';
import 'package:evergrow_mobile_app/models/recommendation.dart';
import 'package:evergrow_mobile_app/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../components/top_section.dart';
import 'package:evergrow_mobile_app/services/waether_service.dart';

class DetailsDay extends StatefulWidget {
  final DateTime selectedDay;
  final List<DateTime> frostDates;
  final List<DateTime> droughtDates;
  final List<DateTime> strongWindDates;
  final List<DateTime> intenseRainDates;
  final double latitude;
  final double longitude;

  const DetailsDay({
    super.key,
    required this.selectedDay,
    required this.frostDates,
    required this.droughtDates,
    required this.strongWindDates,
    required this.intenseRainDates,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<DetailsDay> createState() => _DetailsDayState();
}

class _DetailsDayState extends State<DetailsDay> {
  List<Recommendation> recommendations = [
    Recommendation(
      imagePath: 'assets/icons/drought_recommendation.png',
      title: 'Drought Advisory',
      description:
          'Make sure to store enough water to be able to water your plants for 16 weeks.',
    ),
    Recommendation(
      imagePath: 'assets/icons/rain_recommendation.png',
      title: 'Intense Rain Alert',
      description:
          'Ensure proper drainage systems are in place to prevent waterlogging in fields. Utilize remote sensing data to monitor soil moisture levels.',
    ),
    Recommendation(
      imagePath: 'assets/icons/frost_recommendation.png',
      title: 'Frost Warning',
      description:
          'Deploy protective coverings for sensitive crops and activate heaters to mitigate frost impact on crop yield.',
    ),
    Recommendation(
      imagePath: 'assets/icons/wind_recommendation.png',
      title: 'Strong Wind Caution',
      description:
          'Secure crops. Do not spray pesticides as the wind will blow them away and waste them.',
    ),
  ];

  late DateTime _focusedDay;
  late DateTime _selectedNewDay;
  late CalendarFormat _calendarFormat;
  double? averageTemperature;
  double? averageWindSpeed;
  double? averageMoisture;

  bool isDrought = false;
  bool isRain = false;
  bool isFrost = false;
  bool isWind = false;

  @override
  void initState() {
    super.initState();
    _calendarFormat = CalendarFormat.week;
    _focusedDay = widget.selectedDay;
    _selectedNewDay = widget.selectedDay;
    _updateRecommendations(widget.selectedDay);
    _fetchTemperatureForSelectedDay(_selectedNewDay);
    _fetchWindVelocityForSelectedDay(_selectedNewDay);
    _fetchMoistureForSelectedDay(_selectedNewDay);
  }

  Future<void> _fetchTemperatureForSelectedDay(DateTime selectedDay) async {
    WeatherService weatherService = WeatherService();
    try {
      String formattedDate =
          '${selectedDay.year}-${selectedDay.month.toString().padLeft(2, '0')}-${selectedDay.day.toString().padLeft(2, '0')}';

      double temperature = await weatherService.fetchAverageTemperature(
        widget.latitude,
        widget.longitude,
        formattedDate,
      );

      setState(() {
        averageTemperature = temperature;
      });
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> _fetchWindVelocityForSelectedDay(DateTime selectedDay) async {
    WeatherService weatherService = WeatherService();
    try {
      String formattedDate =
          '${selectedDay.year}-${selectedDay.month.toString().padLeft(2, '0')}-${selectedDay.day.toString().padLeft(2, '0')}';

      double windVelocity = await weatherService.fetchAverageWindSpeed(
        widget.latitude,
        widget.longitude,
        formattedDate,
      );

      setState(() {
        averageWindSpeed = windVelocity;
      });
    } catch (error) {
      print('Error fetching wind velocity: $error');
    }
  }

  Future<void> _fetchMoistureForSelectedDay(DateTime selectedDay) async {
    WeatherService weatherService = WeatherService();
    try {
      String formattedDate =
          '${selectedDay.year}-${selectedDay.month.toString().padLeft(2, '0')}-${selectedDay.day.toString().padLeft(2, '0')}';

      double moisture = await weatherService.fetchAverageMoisture(
          widget.latitude, widget.longitude, formattedDate);

      setState(() {
        averageMoisture = moisture;
      });
    } catch (error) {
      print('Error fetching moisture: $error');
    }
  }

  void _updateRecommendations(DateTime selectedDay) {
    setState(() {
      isDrought = widget.droughtDates
          .any((droughtDate) => isSameDay(droughtDate, selectedDay));
      isRain = widget.intenseRainDates
          .any((rainDate) => isSameDay(rainDate, selectedDay));
      isFrost = widget.frostDates
          .any((frostDate) => isSameDay(frostDate, selectedDay));
      isWind = widget.strongWindDates
          .any((windDate) => isSameDay(windDate, selectedDay));
    });
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
                    const SizedBox(height: 20),
                    _buildRecommendations(isDrought, isRain, isFrost, isWind),
                    const SizedBox(height: 20),
                    _buildCriteriaInfo(
                      'assets/icons/strong_winds.png',
                      'Hot day',
                      averageTemperature != null
                          ? 'The average temperature will be ${averageTemperature!.toStringAsFixed(2)} °C'
                          : 'Temperature data not available yet',
                    ),
                    const SizedBox(height: 20),
                    _buildCriteriaInfo(
                      'assets/icons/strong_winds.png',
                      'Light winds',
                      averageWindSpeed != null
                          ? 'The average wind speed for the day will be ${averageWindSpeed!.toStringAsFixed(2)} km/h'
                          : 'Wind speed data not available yet',
                    ),
                    const SizedBox(height: 20),
                    _buildCriteriaInfo(
                      'assets/icons/strong_winds.png',
                      'Well-Moistened',
                      averageMoisture != null
                          ? 'The soil is expected to be healthy with a moisture level of ${averageMoisture!.toStringAsFixed(2)}%'
                          : 'Moisture data not available yet',
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCriteriaInfo(
      String imagePath, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(
                    imagePath,
                    width: 20,
                    height: 20,
                    color: neutral,
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: neutral,
                      ),
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                  color: neutral,
                ),
              ),
            ],
          ),
        ),
      ],
    );
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

  // Configurar el calendario para seleccionar la fecha
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
        _fetchTemperatureForSelectedDay(
            selectedDay); // Llamamos a la función para obtener la temperatura
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
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
    );
  }

  // Método para mostrar las recomendaciones
  Widget _buildRecommendations(
      bool isDrought, bool isRain, bool isFrost, bool isWind) {
    return Column(
      children: [
        if (isDrought)
          _buildRecommendation(
            recommendations[0].imagePath,
            recommendations[0].title,
            recommendations[0].description,
            const Color.fromARGB(255, 227, 130, 78),
          ),
        const SizedBox(height: 10),
        if (isRain)
          _buildRecommendation(
            recommendations[1].imagePath,
            recommendations[1].title,
            recommendations[1].description,
            const Color.fromARGB(255, 50, 159, 199),
          ),
        const SizedBox(height: 10),
        if (isFrost)
          _buildRecommendation(
            recommendations[2].imagePath,
            recommendations[2].title,
            recommendations[2].description,
            const Color.fromARGB(255, 113, 142, 151),
          ),
        if (isWind)
          _buildRecommendation(
            recommendations[3].imagePath,
            recommendations[3].title,
            recommendations[3].description,
            const Color.fromARGB(255, 119, 101, 101),
          ),
      ],
    );
  }

  // Mostrar una recomendación
  Widget _buildRecommendation(
      String imagePath, String title, String description, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(
                      imagePath,
                      width: 20,
                      height: 20,
                      color: color,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: neutral,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
