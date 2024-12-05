import 'dart:convert';
import 'package:http/http.dart' as http;

class MeteomaticsService {
  final String baseUrl = 'https://api.meteomatics.com/';
  final String username = 'upc_abigail_lucero';
  final String password = '8EbL4AdTs0';

  Future<List<DateTime>> fetchFrostDates(double lat, double lng) async {
    String rangeDates = '2024-10-07T00:00:00Z--2026-10-01T00:00:00Z';
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
    String rangeDates = '2024-10-07T00:00:00Z--2024-10-10T00:00:00Z';
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
    String rangeDates = '2024-10-07T00:00:00Z--2025-12-30T00:00:00Z';
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
      return strongWindDates;
    } else {
      print('Url: $apiUrl');
      throw Exception('Error al obtener datos de vientos fuertes');
    }
  }

  Future<List<DateTime>> fetchHeavyRainDates(double lat, double lng) async {
    String rangeDates = '2024-10-07T00:00:00Z--2025-12-05T00:00:00Z';
    final String apiUrl =
        '$baseUrl$rangeDates:PT6H/heavy_rain_warning_6h:idx,precip_6h:mm/$lat,$lng/json';

    final response = await http.get(Uri.parse(apiUrl), headers: {
      'Authorization':
          'Basic ${base64Encode(utf8.encode('$username:$password'))}',
    });

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      List<DateTime> heavyRainDates = [];

      final precipData = jsonData['data'][1]['coordinates'][0]['dates'];
      for (var dateEntry in precipData) {
        double value = (dateEntry['value'] as num).toDouble();

        // Get dates filter by (precipitation >= 20 mm)
        if (value > 20.0) {
          DateTime date = DateTime.parse(dateEntry['date']);
          heavyRainDates.add(date);
        }
      }

      return heavyRainDates;
    } else {
      print('Url: $apiUrl');
      throw Exception('Error al obtener datos de lluvias intensas');
    }
  }
}
