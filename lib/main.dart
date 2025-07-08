import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/ui/controllers/settings_page_controller.dart';
import 'package:weather_app/ui/get_started.dart';
import 'package:weather_app/ui/home_page.dart';
import 'package:weather_app/utils/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final settingsController = Get.put(SettingsController()); // Put before runApp
  await settingsController.loadSettings(); // Ensure settings are loaded
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingsController settingsController = Get.find();

    return Obx(
      () => GetMaterialApp(
        title: 'Weather App',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: settingsController.isDarkMode.value
            ? ThemeMode.dark
            : ThemeMode.light,
        debugShowCheckedModeBanner: false,
        home: const Launcher(),
      ),
    );
  }
}

class Launcher extends StatelessWidget {
  const Launcher({super.key});

  Future<Widget> _getStartPage() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenIntro = prefs.getBool('seen') ?? false;
    return hasSeenIntro ? const HomePage() : const GetStarted();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _getStartPage(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData) {
          return snapshot.data!;
        } else {
          return const Scaffold(
            body: Center(child: Text('Something went wrong')),
          );
        }
      },
    );
  }
}
