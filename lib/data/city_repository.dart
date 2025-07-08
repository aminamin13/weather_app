import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/city_model.dart';

class CitiesRepository {
  static const String _baseUrl = "https://wft-geo-db.p.rapidapi.com/v1/geo";
  static const Map<String, String> _headers = {
    'X-RapidAPI-Key': 'd156378d5dmshee6eea062431a95p1f4ba5jsn767aa933565c',
    'X-RapidAPI-Host': 'wft-geo-db.p.rapidapi.com',
  };

  Future<List<CityModel>> searchCities(String query) async {
    final url = Uri.parse("$_baseUrl/cities?namePrefix=$query&limit=10");

    final response = await http.get(url, headers: _headers);
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      final List cities = result['data'];

      return cities.map((city) {
        return CityModel(
          name: city['name'],
          country: city['country'],
          lat: city['latitude'].toString(),
          lon: city['longitude'].toString(),
        );
      }).toList();
    } else {
      throw Exception("Failed to fetch cities: ${response.reasonPhrase}");
    }
  }
}
