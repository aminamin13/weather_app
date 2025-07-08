import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/city_model.dart';
import 'package:weather_app/models/daily_forecast_model.dart';
import 'package:weather_app/models/hourly_forecast_model.dart';

class WeatherRepository extends GetxController {
  static const _baseUrl = "http://api.weatherapi.com/v1/forecast.json";
  static const _apiKey = "cfdbb543f2eb4d3cad991319252706";

  Future<List<DailyForecastModel>> fetchForecast(
    String lat,
    String lon,
    int days,
  ) async {
    final url = Uri.parse("$_baseUrl?key=$_apiKey&q=$lat,$lon&days=$days");

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      final List forecastDays = result['forecast']['forecastday'];

      return forecastDays
          .map((dayJson) => DailyForecastModel.fromJson(dayJson))
          .toList();
    } else {
      throw Exception("Failed to fetch weather data: ${response.reasonPhrase}");
    }
  }

Future<List<HourlyForecastModel>> fetchHourlyForecast(
  String lat,
  String lon,
  int days,
) async {
  final url = Uri.parse("$_baseUrl?key=$_apiKey&q=$lat,$lon&days=$days");

  final response = await http.get(url);
  if (response.statusCode == 200) {
    final result = json.decode(response.body);
    final List forecastDays = result['forecast']['forecastday'];

    List<HourlyForecastModel> allHourlyForecasts = [];

    for (var day in forecastDays) {
      final List hours = day['hour'];
      final hourlyForecasts = hours
          .map<HourlyForecastModel>((hourJson) => HourlyForecastModel.fromJson(hourJson))
          .toList();
      allHourlyForecasts.addAll(hourlyForecasts);
    }

    return allHourlyForecasts;
  } else {
    throw Exception("Failed to fetch weather data: ${response.reasonPhrase}");
  }
}


  Future<CityModel> fetchCityFromLatLng(String lat, String lon) async {
    final url = Uri.parse("$_baseUrl?key=$_apiKey&q=$lat,$lon&days=1");

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      final location = result['location']; // This is a Map

      return CityModel(
        name: location['name'],
        country: location['country'],
        lat: location['lat'].toString(),
        lon: location['lon'].toString(),
      );
    } else {
      throw Exception("Failed to fetch city data: ${response.reasonPhrase}");
    }
  }
}
