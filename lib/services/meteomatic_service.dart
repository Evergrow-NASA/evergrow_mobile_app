import 'dart:convert';
import 'package:http/http.dart' as http;

class MeteomaticsService {
  final String baseUrl = 'https://api.meteomatics.com/';
  final String username = 'medalith_tatiana';
  final String password = 'l30wgOLbW7';

  Future<List<DateTime>> fetchFrostDates(double lat, double lng) async {
    String rangeDates = '2022-01-01T00:00:00Z--2026-12-31T00:00:00Z';
    final String apiUrl =
        '$baseUrl$rangeDates:PT24H/frost_warning_24h:idx/$lat,$lng/json';

    final response = await http.get(Uri.parse(apiUrl), headers: {
      'Authorization':
          'Basic ${base64Encode(utf8.encode('$username:$password'))}',
    });

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      List<DateTime> frostDates = [];

      // Get dates filter by (value == 1)
      final data = jsonData['data'][0]['coordinates'][0]['dates'];
      for (var dateEntry in data) {
        if (dateEntry['value'] == 1) {
          frostDates.add(DateTime.parse(dateEntry['date']));
        }
      }
      return frostDates;
    } else {
      print('Url: $apiUrl');
      throw Exception('Error al obtener datos de heladas');
    }
  }

  Future<List<DateTime>> fetchDroughtDates(double lat, double lng) async {
    String rangeDates = '2022-01-01T00:00:00Z--2024-10-10T00:00:00Z';
    final String apiUrl =
        '$baseUrl$rangeDates:PT24H/drought_index:idx/$lat,$lng/json';

    final response = await http.get(Uri.parse(apiUrl), headers: {
      'Authorization':
          'Basic ${base64Encode(utf8.encode('$username:$password'))}',
    });

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      List<DateTime> droughtDates = [];

      // Get dates filter by (-4 a -1)
      final data = jsonData['data'][0]['coordinates'][0]['dates'];
      for (var dateEntry in data) {
        int value = dateEntry['value'];
        if (value >= -4 && value <= -1) {
          DateTime date = DateTime.parse(dateEntry['date']);
          droughtDates.add(date);
        }
      }
      return droughtDates;
    } else {
      print('Url: $apiUrl');
      throw Exception('Error al obtener datos de sequía');
    }
  }

  Future<List<DateTime>> fetchStrongWindDates(double lat, double lng) async {
    String rangeDates = '2023-01-01T00:00:00Z--2025-12-30T00:00:00Z';
    final String apiUrl =
        '$baseUrl$rangeDates:PT1H/wind_warning_1h:idx,wind_gusts_10m_1h:kmh/$lat,$lng/json';

    final response = await http.get(Uri.parse(apiUrl), headers: {
      'Authorization':
          'Basic ${base64Encode(utf8.encode('$username:$password'))}',
    });

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      List<DateTime> strongWindDates = [];

      // Get dates filter by (wind velocity >= 105 km/h -> value >= 4)
      final data = jsonData['data'][0]['coordinates'][0]['dates'];
      for (var dateEntry in data) {
        int value = dateEntry['value'];

        if (value >= 4) {
          DateTime date = DateTime.parse(dateEntry['date']);
          strongWindDates.add(date);
        }
      }
      print('Url: $apiUrl');
      print('List: $strongWindDates');
      return strongWindDates;
    } else {
      print('Url: $apiUrl');
      throw Exception('Error al obtener datos de vientos fuertes');
    }
  }
}
