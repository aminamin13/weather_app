import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/utils/app_theme.dart';

class SettingsController extends GetxController {
  // App Settings
  RxBool isDarkMode = false.obs;
  RxBool autoRefresh = true.obs;
  RxString refreshInterval = "30 minutes".obs;

  // Units Settings

  RxString messureUnit = "Celsius (°C)".obs;

  // Notifications Settings
  RxBool weatherAlerts = true.obs;
  RxBool dailyForecast = true.obs;
  RxString notificationTime = "8:00 AM".obs;

  @override
  void onInit() {
    super.onInit();
    loadSettings();
  }

  // App Settings Methods
  void toggleDarkMode() {
    isDarkMode.value = !isDarkMode.value;
    _saveSettings();
    Get.changeTheme(
      isDarkMode.value ? AppTheme.darkTheme : AppTheme.lightTheme,
    );
  }

  void showTimePickerDialog(
    SettingsController controller,
    ThemeData theme,
  ) async {
    final TimeOfDay? picked = await showTimePicker(
      context: Get.context!,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      controller.setNotificationTime(picked);
      notificationTime.value = picked.format(Get.context!);
      _saveSettings();
    }
  }

  // void toggleAutoRefresh() {
  //   autoRefresh.value = !autoRefresh.value;
  //   _saveSettings();
  // }

  // void setRefreshInterval(String interval) {
  //   refreshInterval.value = interval;
  //   _saveSettings();
  // }

  // Units Settings Methods
  void setMesureUnit(String unit) {
    messureUnit.value = unit;

    _saveSettings();
  }

  // Notifications Settings Methods
  void toggleWeatherAlerts() {
    weatherAlerts.value = !weatherAlerts.value;
    _saveSettings();
  }

  void toggleDailyForecast() {
    dailyForecast.value = !dailyForecast.value;
    _saveSettings();
  }

  void setNotificationTime(TimeOfDay time) {
    final String formattedTime =
        "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
    final String displayTime =
        "${time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod}:${time.minute.toString().padLeft(2, '0')} ${time.period == DayPeriod.am ? 'AM' : 'PM'}";
    notificationTime.value = displayTime;
    _saveSettings();
  }

  // Helper Methods for Temperature Conversion

  // Helper Methods for Wind Speed Conversion

  // Refresh Interval Helper Methods
  // int getRefreshIntervalInMinutes() {
  //   switch (refreshInterval.value) {
  //     case "15 minutes":
  //       return 15;
  //     case "30 minutes":
  //       return 30;
  //     case "1 hour":
  //       return 60;
  //     case "2 hours":
  //       return 120;
  //     default:
  //       return 30;
  //   }
  // }

  // Duration getRefreshIntervalDuration() {
  //   return Duration(minutes: getRefreshIntervalInMinutes());
  // }

  // Theme Helper Methods
  bool get isLightMode => !isDarkMode.value;

  ThemeData get currentTheme {
    return isDarkMode.value ? _darkTheme : _lightTheme;
  }

  ThemeData get _lightTheme => ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
    ),
  );

  ThemeData get _darkTheme => ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
    ),
  );

  // Notification Helper Methods
  TimeOfDay get notificationTimeOfDay {
    try {
      final timeParts = notificationTime.value.split(' ');
      final hourMinute = timeParts[0].split(':');
      final hour = int.parse(hourMinute[0]);
      final minute = int.parse(hourMinute[1]);
      final isPM = timeParts[1] == 'PM';

      final adjustedHour = isPM
          ? (hour == 12 ? 12 : hour + 12)
          : (hour == 12 ? 0 : hour);

      return TimeOfDay(hour: adjustedHour, minute: minute);
    } catch (e) {
      return const TimeOfDay(hour: 8, minute: 0);
    }
  }

  bool get shouldShowNotifications =>
      weatherAlerts.value || dailyForecast.value;

  // Data Persistence Methods
  Future<void> loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      notificationTime.value = prefs.getString('notificationTime') ?? "8:00 AM";
      // Load App Settings
      isDarkMode.value = prefs.getBool('isDarkMode') ?? false;
      autoRefresh.value = prefs.getBool('autoRefresh') ?? true;
      refreshInterval.value =
          prefs.getString('refreshInterval') ?? "30 minutes";

      // Load Units Settings
      messureUnit.value = prefs.getString('messurementUnit') ?? "Metric";

      // Load Notifications Settings
      weatherAlerts.value = prefs.getBool('weatherAlerts') ?? true;
      dailyForecast.value = prefs.getBool('dailyForecast') ?? true;
      notificationTime.value = prefs.getString('notificationTime') ?? "8:00 AM";
    } catch (e) {
      print('Error loading settings: $e');
    }
  }

  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('notificationTime', notificationTime.value);

      // Save App Settings
      await prefs.setBool('isDarkMode', isDarkMode.value);
      await prefs.setBool('autoRefresh', autoRefresh.value);
      await prefs.setString('refreshInterval', refreshInterval.value);

      // Save Units Settings
      await prefs.setString('messurementUnit', messureUnit.value);

      // Save Notifications Settings
      await prefs.setBool('weatherAlerts', weatherAlerts.value);
      await prefs.setBool('dailyForecast', dailyForecast.value);
      await prefs.setString('notificationTime', notificationTime.value);
    } catch (e) {
      print('Error saving settings: $e');
    }
  }

  // Reset Methods
  Future<void> resetToDefaults() async {
    // Reset App Settings
    isDarkMode.value = false;
    autoRefresh.value = true;
    refreshInterval.value = "30 minutes";

    // Reset Units Settings
    messureUnit.value = "Metric";

    // Reset Notifications Settings
    weatherAlerts.value = true;
    dailyForecast.value = true;
    notificationTime.value = "8:00 AM";

    await _saveSettings();
  }

  Future<void> clearAllSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      await resetToDefaults();
    } catch (e) {
      print('Error clearing settings: $e');
    }
  }

  void showMeasurementUnitDialog(ThemeData theme) {
    final colorScheme = theme.colorScheme;

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: colorScheme.surface,
        title: Text(
          "Measurement Units",
          style: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ["Imperial", "Metric"]
              .map(
                (unit) => ListTile(
                  title: Text(
                    unit,
                    style: TextStyle(color: colorScheme.onSurface),
                  ),
                  onTap: () {
                    setMesureUnit(unit);
                    Get.back();
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  bool isValidRefreshInterval(String interval) {
    return ["15 minutes", "30 minutes", "1 hour", "2 hours"].contains(interval);
  }

  // Export/Import Settings (for future use)
  Map<String, dynamic> exportSettings() {
    return {
      'isDarkMode': isDarkMode.value,
      'autoRefresh': autoRefresh.value,
      'refreshInterval': refreshInterval.value,
      'messurementUnit': messureUnit.value,

      'weatherAlerts': weatherAlerts.value,
      'dailyForecast': dailyForecast.value,
      'notificationTime': notificationTime.value,
    };
  }

  Future<void> importSettings(Map<String, dynamic> settings) async {
    try {
      if (settings.containsKey('isDarkMode')) {
        isDarkMode.value = settings['isDarkMode'] ?? false;
      }
      if (settings.containsKey('autoRefresh')) {
        autoRefresh.value = settings['autoRefresh'] ?? true;
      }
      if (settings.containsKey('refreshInterval') &&
          isValidRefreshInterval(settings['refreshInterval'])) {
        refreshInterval.value = settings['refreshInterval'];
      }

      if (settings.containsKey('weatherAlerts')) {
        weatherAlerts.value = settings['weatherAlerts'] ?? true;
      }
      if (settings.containsKey('dailyForecast')) {
        dailyForecast.value = settings['dailyForecast'] ?? true;
      }
      if (settings.containsKey('notificationTime')) {
        notificationTime.value = settings['notificationTime'] ?? "8:00 AM";
      }

      await _saveSettings();
    } catch (e) {
      print('Error importing settings: $e');
    }
  }

  final InAppReview _inAppReview = InAppReview.instance;

  void requestReview() {
    _inAppReview.openStoreListing(
      appStoreId: 'com.artprograms2xz.flutter_movie_go',
    );
  }
}
