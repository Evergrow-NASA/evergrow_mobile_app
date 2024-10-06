import 'dart:convert';
import 'package:evergrow_mobile_app/models/temperature.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class WeatherService {
  final String baseUrl = 'https://api.meteomatics.com/';
  final String username = 'medalith_tatiana';
  final String password = 'l30wgOLbW7';

  Future<List<Temperature>?> fetchHourlyTemperature(
      double latitude, double longitude) async {
    String startDate =
        '${DateFormat('yyyy-MM-dd').format(DateTime.now())}T00:00:00Z';

    String endDate =
        '${DateFormat('yyyy-MM-dd').format(DateTime.now().add(const Duration(days: 1)))}T00:00:00Z';

    final String apiUrl =
        '$baseUrl/$startDate--$endDate:PT1H/t_2m:C/$latitude,$longitude/json';

    final response = await http.get(Uri.parse(apiUrl), headers: {
      'Authorization':
          'Basic ${base64Encode(utf8.encode('$username:$password'))}',
    });

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData['data'][0]['coordinates'][0]['dates'] != null) {
        List<Temperature> temperatures = [];

        List<dynamic> dateEntries =
            jsonData['data'][0]['coordinates'][0]['dates'];

        for (var entry in dateEntries) {
          String fullDateTime = entry['date'].toString();
          String date = fullDateTime.split('T')[0];
          String time = fullDateTime.split('T')[1].replaceAll('Z', '');

          temperatures.add(Temperature(
              temperature: entry['value'].toDouble(), date: date, time: time));
        }

        return temperatures;
      } else {
        throw Exception(
            'No se encontraron datos de temperatura para las fechas seleccionadas.');
      }
    }
    return null;
  }
}
