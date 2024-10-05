import 'dart:convert';
import 'package:evergrow_mobile_app/models/Temperature.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class WeatherService {
  final String baseUrl = 'https://power.larc.nasa.gov/api/temporal/hourly/point';

  Future<List<Temperature>?> fetchHourlyTemperature(double latitude, double longitude) async {
    String startDate = DateFormat('yyyyMMdd').format(DateTime.now());
    String endDate = DateFormat('yyyyMMdd').format(DateTime.now().add(const Duration(days: 1)));
    final String apiUrl = '$baseUrl?parameters=T2M&community=AG&longitude=$longitude&latitude=$latitude&start=$startDate&end=$endDate&format=JSON';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['properties']?['parameter']?['T2M'] != null) {
          Map<String, dynamic> t2mData = data['properties']['parameter']['T2M'];
          List<Temperature> temperatures = [];

          t2mData.forEach((key, value) {
            temperatures.add(Temperature(
              temperature: value,
              date: key,
            ));
          });

          return temperatures;
        } else {
          throw Exception('No data available for the selected date.');
        }
      } else {
        throw Exception('Failed to load data from API: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching weather data: $e');
    }
  }
}