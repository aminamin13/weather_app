class CityModel {
  final String name;
  final String country;
  final String lat;
  final String lon;

  CityModel({
    required this.name,
    required this.country,
    required this.lat,
    required this.lon,
  });

  /// ✅ Safe parsing from nested JSON (API response) or flat JSON (SharedPreferences)
  factory CityModel.fromJson(Map<String, dynamic> json) {
    // 🔸 Handle both direct and nested "location" JSON (from API vs SharedPreferences)
    final isNested = json.containsKey('location');
    final Map<String, dynamic> data = isNested ? json['location'] : json;

    return CityModel(
      name: data['name'] ?? 'Unknown', // ✅ Default fallback
      country: data['country'] ?? 'Unknown', // ✅ Default fallback
      lat: data['lat'].toString(), // ✅ Ensure type consistency
      lon: data['lon'].toString(),
    );
  }

  /// ✅ Flat JSON format for SharedPreferences
  Map<String, dynamic> toJson() {
    return {'name': name, 'country': country, 'lat': lat, 'lon': lon};
  }

  // 📌 You may add an equality operator or ID logic if needed later
}
