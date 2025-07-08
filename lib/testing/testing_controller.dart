import 'package:get/get.dart';

 import 'package:weather_app/models/hourly_forecast_model.dart';
import 'package:weather_app/data/weather_repository.dart'; // Ensure this contains fetchHourlyForecast

class TestingController extends GetxController {
  final RxList<HourlyForecastModel> hourlyForecastList = <HourlyForecastModel>[].obs;

  final WeatherRepository _weatherRepository = Get.put(WeatherRepository());

  RxBool isLoading = false.obs;
  RxString error = ''.obs;

  Future<void> loadHourlyForecast(String lat, String lon, int days) async {
    try {
      isLoading.value = true;
      error.value = '';

      final List<HourlyForecastModel> result =
          await _weatherRepository.fetchHourlyForecast(lat, lon, days);

      hourlyForecastList.assignAll(result);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
