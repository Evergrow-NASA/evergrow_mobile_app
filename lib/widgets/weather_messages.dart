import 'package:evergrow_mobile_app/models/soil_moisture.dart';
import 'package:evergrow_mobile_app/models/wind.dart';

import '../models/temperature.dart';

class WeatherMessages {
  String generateTemperatureMessage(List<Temperature> temperatures) {
    double maxTemp = temperatures
        .map((temp) => temp.temperature)
        .reduce((a, b) => a > b ? a : b);
    double minTemp = temperatures
        .map((temp) => temp.temperature)
        .reduce((a, b) => a < b ? a : b);

    if (maxTemp > 35) {
      return 'High temperatures can cause stress on crops. Consider using shade nets or increasing watering frequency during the hottest hours of the day.';
    } else if (minTemp < 5) {
      return 'Low temperatures may cause frost damage. It is recommended to cover sensitive crops or use irrigation systems to keep the soil warmer.';
    } else {
      return 'Today’s temperatures are favorable for crop growth. Take advantage of the conditions to perform maintenance tasks such as pruning or fertilization.';
    }
  }

  String generateWindMessage(List<WindSpeed> windSpeeds) {
    double maxWindSpeed =
        windSpeeds.map((wind) => wind.speed).reduce((a, b) => a > b ? a : b);

    if (maxWindSpeed > 25) {
      return 'Strong winds can damage tall, unprotected crops. Consider installing wind barriers or avoid applying pesticides today.';
    } else if (maxWindSpeed > 10) {
      return 'Moderate winds may affect the efficiency of sprinkler irrigation. Adjust irrigation systems to minimize water loss.';
    } else {
      return 'Gentle winds support natural pollination. It’s a good time to allow plants to bloom without disturbances.';
    }
  }

  String generateSoilMoistureMessage(
      List<SoilMoisture> soilMoistureData, String depth) {
    double avgMoisture =
        soilMoistureData.map((soil) => soil.moisture).reduce((a, b) => a + b) /
            soilMoistureData.length;

    if (avgMoisture > 0.8) {
      return 'The soil is too wet at a depth of $depth. Reduce watering to prevent root rot and ensure good drainage.';
    } else if (avgMoisture < 0.3) {
      return 'The soil is dry at a depth of $depth. It is recommended to increase watering frequency to prevent plants from suffering water stress.';
    } else {
      return 'The soil moisture at a depth of $depth is adequate. Maintain the current watering routine to ensure healthy crop growth.';
    }
  }
}
