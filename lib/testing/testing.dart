import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/testing/testing_controller.dart';

class TestingPage extends StatelessWidget {
  const TestingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TestingController());

    controller.loadHourlyForecast("33.8938", "35.5018", 1); // Example: Beirut

    return Scaffold(
      appBar: AppBar(title: Text("Hourly Forecast")),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.error.isNotEmpty) {
          return Center(child: Text("Error: ${controller.error}"));
        }

        if (controller.hourlyForecastList.isEmpty) {
          return Center(child: Text("No data found."));
        }

        return ListView.builder(
          itemCount: controller.hourlyForecastList.length,
          itemBuilder: (context, index) {
            final forecast = controller.hourlyForecastList[index];
            return ListTile(
              leading: Icon(Icons.access_time),
              title: Text(forecast.time),
              subtitle: Text(
                "${forecast.tempC}°C",
              ), // Uncomment if tempC is used
            );
          },
        );
      }),
    );
  }
}
