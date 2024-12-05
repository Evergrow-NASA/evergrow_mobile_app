import 'dart:convert';
import 'package:evergrow_mobile_app/models/soil_moisture.dart';
import 'package:evergrow_mobile_app/models/temperature.dart';
import 'package:evergrow_mobile_app/models/wind.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class WeatherService {
  final String baseUrl = 'https://api.meteomatics.com/';
  final String username = 'upc_abigail_lucero';
  final String password = '8EbL4AdTs0';

  // Método para obtener la temperatura
  Future<List<Temperature>?> fetchHourlyTemperature(
      double latitude, double longitude) async {
    String startDate =
        '${DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateTime.now())}Z';

    String endDate =
        '${DateFormat('yyyy-MM-dd').format(DateTime.now().add(const Duration(days: 1)))}T${DateFormat('HH:mm:ss').format(DateTime.now())}Z';

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

  // Método para obtener el índice de humedad del suelo
  Future<List<SoilMoisture>?> fetchSoilMoisture(
      double latitude, double longitude, String depth) async {
    String startDate =
        '${DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateTime.now())}Z';

    String endDate =
        '${DateFormat('yyyy-MM-dd').format(DateTime.now().add(const Duration(days: 1)))}T${DateFormat('HH:mm:ss').format(DateTime.now())}Z';

    final String apiUrl =
        '$baseUrl/$startDate--$endDate:PT1H/soil_moisture_index_$depth:idx/$latitude,$longitude/json';

    final response = await http.get(Uri.parse(apiUrl), headers: {
      'Authorization':
          'Basic ${base64Encode(utf8.encode('$username:$password'))}',
    });

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData['data'][0]['coordinates'][0]['dates'] != null) {
        List<SoilMoisture> soilMoistures = [];

        List<dynamic> dateEntries =
            jsonData['data'][0]['coordinates'][0]['dates'];

        for (var entry in dateEntries) {
          String fullDateTime = entry['date'].toString();
          String date = fullDateTime.split('T')[0];
          String time = fullDateTime.split('T')[1].replaceAll('Z', '');

          soilMoistures.add(SoilMoisture(
              moisture: entry['value'].toDouble(), date: date, time: time));
        }

        return soilMoistures;
      } else {
        throw Exception(
            'No se encontraron datos de humedad del suelo para las fechas seleccionadas.');
      }
    }
    return null;
  }

  Future<List<WindSpeed>?> fetchWindSpeed(
      double latitude, double longitude) async {
    String startDate =
        '${DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateTime.now())}Z';

    String endDate =
        '${DateFormat('yyyy-MM-dd').format(DateTime.now().add(const Duration(days: 1)))}T${DateFormat('HH:mm:ss').format(DateTime.now())}Z';

    final String apiUrl =
        '$baseUrl/$startDate--$endDate:PT1H/wind_speed_10m:kmh/$latitude,$longitude/json';

    final response = await http.get(Uri.parse(apiUrl), headers: {
      'Authorization':
          'Basic ${base64Encode(utf8.encode('$username:$password'))}',
    });

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData['data'][0]['coordinates'][0]['dates'] != null) {
        List<WindSpeed> windSpeeds = [];

        List<dynamic> dateEntries =
            jsonData['data'][0]['coordinates'][0]['dates'];

        for (var entry in dateEntries) {
          String fullDateTime = entry['date'].toString();
          String date = fullDateTime.split('T')[0];
          String time = fullDateTime.split('T')[1].replaceAll('Z', '');

          windSpeeds.add(WindSpeed(
              speed: entry['value'].toDouble(), date: date, time: time));
        }

        return windSpeeds;
      } else {
        throw Exception(
            'No se encontraron datos de velocidad del viento para las fechas seleccionadas.');
      }
    }
    return null;
  }

  Future<List<WindDirection>?> fetchWindDirection(
      double latitude, double longitude) async {
    String startDate =
        '${DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateTime.now())}Z';

    String endDate =
        '${DateFormat('yyyy-MM-dd').format(DateTime.now().add(const Duration(days: 1)))}T${DateFormat('HH:mm:ss').format(DateTime.now())}Z';

    final String apiUrl =
        '$baseUrl/$startDate--$endDate:PT1H/wind_dir_10m:d/$latitude,$longitude/json';

    final response = await http.get(Uri.parse(apiUrl), headers: {
      'Authorization':
          'Basic ${base64Encode(utf8.encode('$username:$password'))}',
    });

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData['data'][0]['coordinates'][0]['dates'] != null) {
        List<WindDirection> windDirections = [];

        List<dynamic> dateEntries =
            jsonData['data'][0]['coordinates'][0]['dates'];

        for (var entry in dateEntries) {
          String fullDateTime = entry['date'].toString();
          String date = fullDateTime.split('T')[0];
          String time = fullDateTime.split('T')[1].replaceAll('Z', '');

          windDirections.add(WindDirection(
              direction: entry['value'].toDouble(), date: date, time: time));
        }

        return windDirections;
      } else {
        throw Exception(
            'No se encontraron datos de dirección del viento para las fechas seleccionadas.');
      }
    }
    return null;
  }

  // Metodo para obtener el tiempo promedio de temperatura en base a 1 dia en especifico como parametro
  Future<double> fetchAverageTemperature(
      double latitude, double longitude, String date) async {
    String startDate = '${date}T00:00:00Z';
    String endDate = '${date}T23:59:59Z';

    final String apiUrl =
        '$baseUrl/$startDate--$endDate:PT1H/t_2m:C/$latitude,$longitude/json';

    final response = await http.get(Uri.parse(apiUrl), headers: {
      'Authorization':
          'Basic ${base64Encode(utf8.encode('$username:$password'))}',
    });

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData['data'][0]['coordinates'][0]['dates'] != null) {
        List<dynamic> dateEntries =
            jsonData['data'][0]['coordinates'][0]['dates'];

        double sum = 0;
        int count = 0;

        for (var entry in dateEntries) {
          sum += entry['value'].toDouble();
          count++;
        }

        return sum / count;
      } else {
        throw Exception(
            'No se encontraron datos de temperatura para las fechas seleccionadas.');
      }
    }
    return 0;
  }

  //Metodo para obtener la velocidad del viento promedio en base a 1 dia en especifico como parametro
  Future<double> fetchAverageWindSpeed(
      double latitude, double longitude, String date) async {
    String startDate = '${date}T00:00:00Z';
    String endDate = '${date}T23:59:59Z';

    final String apiUrl =
        '$baseUrl/$startDate--$endDate:PT1H/wind_speed_10m:kmh/$latitude,$longitude/json';

    final response = await http.get(Uri.parse(apiUrl), headers: {
      'Authorization':
          'Basic ${base64Encode(utf8.encode('$username:$password'))}',
    });

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData['data'][0]['coordinates'][0]['dates'] != null) {
        List<dynamic> dateEntries =
            jsonData['data'][0]['coordinates'][0]['dates'];

        double sum = 0;
        int count = 0;

        for (var entry in dateEntries) {
          sum += entry['value'].toDouble();
          count++;
        }

        return sum / count;
      } else {
        throw Exception(
            'No se encontraron datos de velocidad del viento para las fechas seleccionadas.');
      }
    }
    return 0;
  }

  //Metodo para obtener la humedad del suelo promedio en base a 1 dia en especifico como parametro
  Future<double> fetchAverageMoisture(
      double latitude, double longitude, String date) async {
    String startDate = '${date}T00:00:00Z';
    String endDate = '${date}T23:59:59Z';

    final String apiUrl =
        '$baseUrl/$startDate--$endDate:PT1H/soil_moisture_index_-5cm:idx,soil_moisture_index_-15cm:idx,soil_moisture_index_-50cm:idx,soil_moisture_index_-150cm:idx/$latitude,$longitude/json';

    final response = await http.get(Uri.parse(apiUrl), headers: {
      'Authorization':
          'Basic ${base64Encode(utf8.encode('$username:$password'))}',
    });

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData['data'][0]['coordinates'][0]['dates'] != null) {
        List<dynamic> dateEntries =
            jsonData['data'][0]['coordinates'][0]['dates'];

        double sum = 0;
        int count = 0;

        for (var entry in dateEntries) {
          sum += entry['value'].toDouble() * 100;
          count++;
        }

        print('Api url: $apiUrl');
        return sum / count;
      } else {
        throw Exception(
            'No se encontraron datos de humedad del suelo para las fechas seleccionadas.');
      }
    }
    return 0;
  }
}
