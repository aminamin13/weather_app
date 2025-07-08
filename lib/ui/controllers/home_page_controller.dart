import 'dart:async';
import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/data/weather_repository.dart';
import 'package:weather_app/models/city_model.dart';
import 'package:weather_app/models/daily_forecast_model.dart';
import 'package:weather_app/models/hourly_forecast_model.dart';
import 'package:weather_app/ui/controllers/settings_page_controller.dart';

class HomePageController extends GetxController {
  static HomePageController get instance => Get.find();
  SettingsController settingsController = Get.put(SettingsController());

  final RxList<CityModel> cities = <CityModel>[].obs; // 🌍 Saved cities list
  final Rxn<CityModel> selectedCity =
      Rxn<CityModel>(); // ✅ Currently selected city
  final RxList<DailyForecastModel> forecastList =
      <DailyForecastModel>[].obs; // 🌦️ Forecast data

  final RxList<HourlyForecastModel> forecastHourlyList =
      <HourlyForecastModel>[].obs; // 🌦️ Forecast data

  RxInt temperature = 0.obs;
  RxInt maxTemp = 0.obs;
  RxString weatherStateName = 'Loading...'.obs;
  RxInt humidity = 0.obs;
  RxInt windSpeed = 0.obs;
  RxString currentDate = 'Loading...'.obs;
  RxString imageUrl = ''.obs;
  RxString sunRise = ''.obs;

  // RxInt temperatureHourly = 0.obs;
  // RxInt changeOfRainHourly = 0.obs;
  // RxInt maxTempHourly = 0.obs;
  // RxString weatherStateNameHourly = 'Loading...'.obs;
  // RxInt humidityHourly = 0.obs;
  // RxInt windSpeedHourly = 0.obs;
  // RxString currentDateHourly = 'Loading...'.obs;
  // RxString imageUrlHourly = ''.obs;

  final WeatherRepository _weatherRepository = Get.put(WeatherRepository());

  double? latitude;
  double? longitude;
  StreamSubscription<Position>? _positionSubscription;

  @override
  void onInit() {
    super.onInit();
    _loadCitiesFromPrefs().then((_) {
      // 🌐 If no saved cities, fallback to getting current location
      if (cities.isEmpty) {
        _initializeWeather();
      }
    });
    _startLocationUpdates();
  }

  void _startLocationUpdates() {
    _positionSubscription =
        Geolocator.getPositionStream(
          locationSettings: LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 5000,
          ),
        ).listen((Position position) async {
          final newLat = position.latitude;
          final newLon = position.longitude;

          if (latitude == null ||
              longitude == null ||
              (latitude! - newLat).abs() > 0.05 ||
              (longitude! - newLon).abs() > 0.05) {
            latitude = newLat;
            longitude = newLon;

            print("🔄 Location changed: $latitude, $longitude");

            await loadCityInfoAndWeather();
          }
        });
  }

  @override
  void onClose() {
    _positionSubscription?.cancel();
    super.onClose();
  }

  Future<void> _initializeWeather() async {
    try {
      await getCurrentLocation(); // 📍 Get GPS coordinates
      await loadCityInfoAndWeather(); // 🌆 Load city from coordinates
    } catch (e) {
      print("Initialization error: $e");
    }
  }

  Future<void> getCurrentLocation() async {
    // 📍 Check and request location permissions
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw 'Location services are disabled.';
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw 'Location permission denied';
      }
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    latitude = position.latitude;
    longitude = position.longitude;
    print("Latitude: $latitude, Longitude: $longitude");
  }

  Future<void> loadCityInfoAndWeather() async {
    try {
      CityModel city = await _weatherRepository.fetchCityFromLatLng(
        latitude.toString(),
        longitude.toString(),
      );

      final exists = cities.any(
        (c) => c.name == city.name || c.lat == city.lat || c.lon == city.lon,
      );

      if (!exists) {
        cities.add(city); // 📌 Add fetched city to the list
        _saveCitiesToPrefs(); // 💾 Save updated list to local storage
      }

      selectedCity.value = city; // ✅ Set as selected
      print("Selected city: ${city.name}");
      await fetchWeatherForSelectedCity(); // 🌤️ Load its forecast
      print("Finished loading weather for ${city.name}");
      await fetchHourlyWeather();
      print("Finished loading hourly weather for ${city.name}");
    } catch (e) {
      print("Error loading city info: $e");
    }
  }

  Future<void> fetchWeatherForSelectedCity() async {
    final city = selectedCity.value;
    if (city == null) return;

    try {
      final data = await _weatherRepository.fetchForecast(
        city.lat.toString(),
        city.lon.toString(),
        8,
      );
      forecastList.assignAll(data);
    } catch (e) {
      print("Error fetching weather: $e");
    }
  }

  Future<void> fetchHourlyWeather() async {
    final city = selectedCity.value;
    if (city == null) return;

    try {
      final data = await _weatherRepository.fetchHourlyForecast(
        city.lat.toString(),
        city.lon.toString(),
        1, // 1 day is enough for 24-hour forecast
      );

      forecastHourlyList.assignAll(data);
    } catch (e) {
      print("Error fetching weather: $e");
    }
  }

  void updateSelectedCity(CityModel city) async {
    selectedCity.value = city;

    final exists = cities.any((c) => c.lat == city.lat && c.lon == city.lon);

    if (!exists) {
      cities.add(city);
    }

    await fetchWeatherForSelectedCity();
    await fetchHourlyWeather(); // ✅ Add this
    _saveCitiesToPrefs();
  }

  Future<void> _saveCitiesToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final cityListJson = cities.map((city) => city.toJson()).toList();
    prefs.setString('saved_cities', jsonEncode(cityListJson));
  }

  Future<void> _loadCitiesFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('saved_cities');
    if (saved != null) {
      try {
        final List<dynamic> decoded = jsonDecode(saved);
        final loadedCities = decoded
            .whereType<
              Map<String, dynamic>
            >() // ✅ Only accept valid map entries
            .map((json) => CityModel.fromJson(json))
            .toList();

        cities.assignAll(loadedCities);

        if (loadedCities.isNotEmpty) {
          selectedCity.value = loadedCities.first;
          await fetchWeatherForSelectedCity();
        }
      } catch (e) {
        print("Error loading cities from prefs: $e");
      }
    }
  }

  void deleteCity(CityModel city) {
    // ❌ Prevent deleting the currently selected city
    if (selectedCity.value?.name == city.name &&
        selectedCity.value?.country == city.country) {
      Get.snackbar(
        "Can't delete",
        "You cannot delete the currently selected city.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error.withOpacity(0.9),
        colorText: Get.theme.colorScheme.onError,
      );
      return;
    }

    cities.removeWhere(
      (c) =>
          c.name == city.name &&
          c.country == city.country &&
          c.lat == city.lat &&
          c.lon == city.lon,
    );

    _saveCitiesToPrefs(); // 💾 Save updated list
  }
}
