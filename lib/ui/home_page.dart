import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/models/city_model.dart';
import 'package:weather_app/ui/controllers/home_page_controller.dart';
import 'package:weather_app/ui/settings_page.dart';
import 'package:weather_app/ui/weather_detail_page.dart';

import 'city_search_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomePageController());
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      ),
      body: Stack(
        children: [
          // Animated Background
          _buildAnimatedBackground(theme),

          // Main Content
          SafeArea(
            child: Column(
              children: [
                // Enhanced Top Header
                _buildEnhancedTopHeader(controller, theme),

                // Main Content with Parallax Effect
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Hero Weather Card with Glassmorphism
                        _buildHeroWeatherCard(controller, theme),

                        const SizedBox(height: 32),
                        _buildHourlyWeatherSection(controller, theme),
                        const SizedBox(height: 32),

                        // Enhanced Weather Details with Micro-animations
                        _buildEnhancedWeatherDetails(controller, theme),

                        const SizedBox(height: 40),

                        // Modern Forecast Section
                        _buildModernForecastSection(controller, theme),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground(ThemeData theme) {
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary.withOpacity(0.1),
            colorScheme.secondary.withOpacity(0.05),
            colorScheme.tertiary.withOpacity(0.1),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Floating Orbs
          Positioned(
            top: 100,
            right: 50,
            child: _buildFloatingOrb(80, colorScheme.primary.withOpacity(0.1)),
          ),
          Positioned(
            top: 300,
            left: 30,
            child: _buildFloatingOrb(
              120,
              colorScheme.secondary.withOpacity(0.08),
            ),
          ),
          Positioned(
            bottom: 200,
            right: 80,
            child: _buildFloatingOrb(
              100,
              colorScheme.tertiary.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingOrb(double size, Color color) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(seconds: 4),
      tween: Tween(begin: 0, end: 1),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, -20 * value),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 30,
                  spreadRadius: 10,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEnhancedTopHeader(
    HomePageController controller,
    ThemeData theme,
  ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Enhanced Profile Avatar with Glow Effect
          _buildCustomDropdown(controller, theme),

          // Dropdown + Icons
          Row(
            children: [
              // Search Icon
              _buildIconButton(
                Icons.search_rounded,
                theme,
                () => Get.to(CitySearchPage()),
              ),

              const SizedBox(width: 12),

              // Settings Icon
              _buildIconButton(Icons.settings, theme, () {
                Get.to(SettingsPage());
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCustomDropdown(HomePageController controller, ThemeData theme) {
    final colorScheme = theme.colorScheme;

    return Obx(() {
      return PopupMenuButton<CityModel>(
        onSelected: (CityModel newCity) {
          controller.updateSelectedCity(newCity);
        },
        itemBuilder: (BuildContext context) {
          return controller.cities.map((city) {
            return PopupMenuItem<CityModel>(
              value: city,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                child: Row(
                  children: [
                    // City Icon
                    Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            colorScheme.primary.withOpacity(0.8),
                            colorScheme.secondary.withOpacity(0.6),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.primary.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.location_city_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),

                    // City Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            city.name,
                            style: TextStyle(
                              color: colorScheme.onSurface,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            city.country,
                            style: TextStyle(
                              color: colorScheme.onSurfaceVariant,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Selected Indicator
                    if (controller.selectedCity.value?.name == city.name)
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              colorScheme.primary,
                              colorScheme.secondary,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: colorScheme.primary.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                  ],
                ),
              ),
            );
          }).toList();
        },
        // FIXED: Use a safe animation curve instead of easeOutBack
        popUpAnimationStyle: AnimationStyle(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic, // Changed from Curves.easeOutBack
        ),
        // Enhanced popup decoration
        constraints: const BoxConstraints(
          minWidth: 200,
          maxWidth: 280,
          maxHeight: 300,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: colorScheme.surface,
        elevation: 0,
        shadowColor: Colors.transparent,
        // Custom popup container with glassmorphism effect
        menuPadding: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        // Custom child button
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorScheme.surface,
                colorScheme.surface.withOpacity(0.95),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: colorScheme.primary.withOpacity(0.1),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(
                  theme.brightness == Brightness.dark ? 0.3 : 0.08,
                ),
                blurRadius: 15,
                offset: const Offset(0, 5),
                spreadRadius: 1,
              ),
              BoxShadow(
                color: colorScheme.primary.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
                spreadRadius: 2,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Location Icon with Gradient
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [colorScheme.primary, colorScheme.secondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.location_on_rounded,
                  color: Colors.white,
                  size: 14,
                ),
              ),
              const SizedBox(width: 8),

              // City Name
              Container(
                constraints: const BoxConstraints(maxWidth: 120),
                child: Text(
                  controller.selectedCity.value?.name ?? 'Select City',
                  style: TextStyle(
                    color: controller.selectedCity.value != null
                        ? colorScheme.onSurface
                        : colorScheme.onSurfaceVariant,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),

              // Animated Dropdown Arrow
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 200),
                tween: Tween(begin: 0, end: 1),
                builder: (context, value, child) {
                  return Transform.rotate(
                    angle: value * 0.1,
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: colorScheme.primary,
                      size: 20,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildIconButton(IconData icon, ThemeData theme, Function()? onTap) {
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: colorScheme.surface.withOpacity(0.9),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(
                theme.brightness == Brightness.dark ? 0.3 : 0.1,
              ),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Icon(icon, color: colorScheme.onSurface, size: 22),
      ),
    );
  }

  Widget _buildHeroWeatherCard(HomePageController controller, ThemeData theme) {
    final colorScheme = theme.colorScheme;

    return Obx(() {
      if (controller.selectedCity.value == null) {
        return _buildSelectCityCard(theme);
      }

      if (controller.forecastList.isEmpty) {
        return _buildShimmerWeatherCard(theme);
      }

      final currentWeather = controller.forecastList.first;

      return Hero(
        tag: 'weather_card',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Location with Subtle Animation
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 800),
              tween: Tween(begin: 0, end: 1),
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, 30 * (1 - value)),
                  child: Opacity(
                    opacity: value,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_rounded,
                              color: colorScheme.primary,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              controller.selectedCity.value!.name,
                              style: TextStyle(
                                color: colorScheme.onSurface,
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -1,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          controller.selectedCity.value!.country,
                          style: TextStyle(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatDate(currentWeather.date),
                          style: TextStyle(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 32),

            // Glassmorphism Weather Card
            Container(
              width: double.infinity,
              height: 240,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme.primary,
                    colorScheme.secondary,
                    colorScheme.tertiary,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: const [0.0, 0.6, 1.0],
                ),
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withOpacity(0.4),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: Stack(
                  children: [
                    // Animated Background Pattern
                    Positioned.fill(
                      child: CustomPaint(painter: WeatherPatternPainter()),
                    ),

                    // Glassmorphism Overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.1),
                            Colors.white.withOpacity(0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),

                    // Content
                    Padding(
                      padding: const EdgeInsets.all(28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Weather Icon and Temperature
                          Row(
                            children: [
                              // Enhanced Weather Icon
                              Container(
                                width: 90,
                                height: 90,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.25),
                                  borderRadius: BorderRadius.circular(25),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Center(
                                  child: Image.network(
                                    "https:${currentWeather.iconUrl}",
                                    width: 70,
                                    height: 70,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(
                                              Icons.wb_sunny_rounded,
                                              color: Colors.white,
                                              size: 50,
                                            ),
                                  ),
                                ),
                              ),

                              const Spacer(),

                              // Temperature with Gradient Text
                              ShaderMask(
                                shaderCallback: (bounds) => LinearGradient(
                                  colors: [Colors.white, Colors.white70],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ).createShader(bounds),
                                child: Text(
                                  controller.settingsController.messureUnit
                                              .toString() ==
                                          "Metric"
                                      ? "${currentWeather.avgTemp}°"
                                      : "${currentWeather.avgTempF}°",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 80,
                                    fontWeight: FontWeight.w200,
                                    letterSpacing: -2,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const Spacer(),

                          // Weather Condition with Styling
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  currentWeather.conditionText,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),

                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Text(
                                  "Sunrise: ${currentWeather.sunrise}\nSunset: ${currentWeather.sunset}",

                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildHourlyWeatherSection(
    HomePageController controller,
    ThemeData theme,
  ) {
    final colorScheme = theme.colorScheme;

    return Obx(() {
      if (controller.forecastHourlyList.isEmpty) {
        return _buildShimmerHourlySection(theme);
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Hourly Forecast",
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "Today",
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Hourly Cards
          Obx(
            () => SizedBox(
              height: 140,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: controller.forecastHourlyList.length,
                itemBuilder: (context, index) {
                  final hourlyData = controller.forecastHourlyList[index];
                  final now = DateTime.now();
                  final hourlyTime = DateTime.parse(
                    hourlyData.time,
                  ); // make sure it's parsed
                  final bool isCurrentHour =
                      now.hour == hourlyTime.hour && now.day == hourlyTime.day;
                  return Container(
                    width: 80,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      gradient: isCurrentHour
                          ? LinearGradient(
                              colors: [
                                colorScheme.primary,
                                colorScheme.secondary,
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            )
                          : null,
                      color: isCurrentHour ? null : colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: isCurrentHour
                          ? null
                          : Border.all(
                              color: colorScheme.outline.withOpacity(0.1),
                              width: 1,
                            ),
                      boxShadow: [
                        BoxShadow(
                          color: isCurrentHour
                              ? colorScheme.primary.withOpacity(0.3)
                              : Colors.black.withOpacity(
                                  theme.brightness == Brightness.dark
                                      ? 0.2
                                      : 0.05,
                                ),
                          blurRadius: isCurrentHour ? 20 : 10,
                          offset: Offset(0, isCurrentHour ? 8 : 4),
                          spreadRadius: isCurrentHour ? 2 : 0,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12, // Reduced from 16 to 12
                        horizontal: 8,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize:
                            MainAxisSize.min, // Added to prevent overflow
                        children: [
                          // Time
                          Text(
                            isCurrentHour
                                ? "Now"
                                : _formatHourTime(hourlyData.time),
                            style: TextStyle(
                              color: isCurrentHour
                                  ? Colors.white
                                  : colorScheme.onSurfaceVariant,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 8), // Added spacing
                          // Weather Icon with Rain Indicator
                          Stack(
                            alignment: Alignment.center,
                            clipBehavior: Clip.none,
                            children: [
                              // Main Weather Icon
                              Container(
                                width: 32, // Reduced from 36 to 32
                                height: 32, // Reduced from 36 to 32
                                decoration: BoxDecoration(
                                  color: isCurrentHour
                                      ? Colors.white.withOpacity(0.2)
                                      : colorScheme.surfaceContainer,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Icon(
                                    _getWeatherIcon(hourlyData.conditionIcon),
                                    color: isCurrentHour
                                        ? Colors.white
                                        : _getWeatherIconColor(
                                            hourlyData.conditionIcon,
                                          ),
                                    size: 18, // Reduced from 20 to 18
                                  ),
                                ),
                              ),

                              // Rain Indicator
                              if (hourlyData.chanceOfRain > 0)
                                Positioned(
                                  top: -6, // Adjusted from -8 to -6
                                  right: -6, // Adjusted from -8 to -6
                                  child: Container(
                                    width: 18, // Reduced from 20 to 18
                                    height: 18, // Reduced from 20 to 18
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF3B82F6),
                                      borderRadius: BorderRadius.circular(9),
                                      border: Border.all(
                                        color: isCurrentHour
                                            ? Colors.white
                                            : colorScheme.surface,
                                        width: 2,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(
                                            0xFF3B82F6,
                                          ).withOpacity(0.4),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.water_drop_rounded,
                                      color: Colors.white,
                                      size: 9, // Reduced from 10 to 9
                                    ),
                                  ),
                                ),
                            ],
                          ),

                          const SizedBox(height: 8), // Added spacing
                          // Temperature
                          Obx(() {
                            final isMetric =
                                controller
                                    .settingsController
                                    .messureUnit
                                    .value ==
                                "Metric";
                            return Text(
                              isMetric
                                  ? "${hourlyData.tempC.round()}°C"
                                  : "${hourlyData.tempF.round()}°",
                              style: TextStyle(
                                color: isCurrentHour
                                    ? Colors.white
                                    : colorScheme.onSurface,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            );
                          }),

                          // Rain Percentage (if applicable)
                          if (hourlyData.chanceOfRain > 0) ...[
                            const SizedBox(height: 4), // Small spacing
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: isCurrentHour
                                    ? Colors.white.withOpacity(0.2)
                                    : const Color(0xFF3B82F6).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "${hourlyData.chanceOfRain}%",
                                style: TextStyle(
                                  color: isCurrentHour
                                      ? Colors.white
                                      : const Color(0xFF3B82F6),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ] else
                            const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      );
    });
  }

  // Helper method to format time to show only hour
  String _formatHourTime(String dateTimeString) {
    try {
      final DateTime dateTime = DateTime.parse(dateTimeString);
      final int hour = dateTime.hour;

      // Format as 12-hour with AM/PM
      if (hour == 0) {
        return "12AM";
      } else if (hour < 12) {
        return "${hour}AM";
      } else if (hour == 12) {
        return "12PM";
      } else {
        return "${hour - 12}PM";
      }
    } catch (e) {
      // Fallback if parsing fails
      return dateTimeString.split(' ').last.substring(0, 2);
    }
  }

  // Helper method to get weather icon based on condition
  IconData _getWeatherIcon(String? condition) {
    if (condition == null) return Icons.wb_sunny_rounded;

    final conditionLower = condition.toLowerCase();

    if (conditionLower.contains('sun') || conditionLower.contains('clear')) {
      return Icons.wb_sunny_rounded;
    } else if (conditionLower.contains('cloud')) {
      return conditionLower.contains('partly')
          ? Icons.wb_cloudy_rounded
          : Icons.cloud_rounded;
    } else if (conditionLower.contains('rain') ||
        conditionLower.contains('drizzle')) {
      return Icons.grain_rounded;
    } else if (conditionLower.contains('storm') ||
        conditionLower.contains('thunder')) {
      return Icons.thunderstorm_rounded;
    } else if (conditionLower.contains('snow')) {
      return Icons.ac_unit_rounded;
    } else if (conditionLower.contains('fog') ||
        conditionLower.contains('mist')) {
      return Icons.foggy;
    }

    // Default to sunny if condition doesn't match
    return Icons.wb_sunny_rounded;
  }

  // Helper method to get weather icon color based on condition
  Color _getWeatherIconColor(String? condition) {
    if (condition == null) return const Color(0xFFFFA726);

    final conditionLower = condition.toLowerCase();

    if (conditionLower.contains('sun') || conditionLower.contains('clear')) {
      return const Color(0xFFFFA726); // Orange
    } else if (conditionLower.contains('cloud')) {
      return const Color(0xFF90A4AE); // Blue Grey
    } else if (conditionLower.contains('rain') ||
        conditionLower.contains('drizzle')) {
      return const Color(0xFF42A5F5); // Blue
    } else if (conditionLower.contains('storm') ||
        conditionLower.contains('thunder')) {
      return const Color(0xFF7E57C2); // Purple
    } else if (conditionLower.contains('snow')) {
      return const Color(0xFF81C784); // Light Blue
    } else if (conditionLower.contains('fog') ||
        conditionLower.contains('mist')) {
      return const Color(0xFFBDBDBD); // Grey
    }

    // Default to orange if condition doesn't match
    return const Color(0xFFFFA726);
  }

  // Shimmer effect for loading state
  Widget _buildShimmerHourlySection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildShimmerContainer(140, 20, theme),
            _buildShimmerContainer(50, 16, theme),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 8,
            itemBuilder: (context, index) {
              return Container(
                width: 80,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 8,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildShimmerContainer(30, 12, theme),
                      _buildShimmerContainer(36, 36, theme, isCircular: false),
                      _buildShimmerContainer(25, 16, theme),
                      _buildShimmerContainer(20, 12, theme),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Helper method to generate mock hourly data
  // List<Map<String, dynamic>> _generateHourlyData() {
  //   final now = DateTime.now();
  //   final conditions = ['sunny', 'cloudy', 'rainy', 'partly_cloudy', 'stormy'];
  //   final temperatures = [22, 24, 21, 23, 20, 19, 25, 26, 23, 21, 20, 22];

  //   return List.generate(12, (index) {
  //     final hour = (now.hour + index) % 24;
  //     final condition = conditions[index % conditions.length];
  //     final hasRain = condition == 'rainy' || condition == 'stormy';

  //     return {
  //       'time': hour == 0
  //           ? '12 AM'
  //           : hour < 12
  //           ? '$hour AM'
  //           : hour == 12
  //           ? '12 PM'
  //           : '${hour - 12} PM',
  //       'temp': temperatures[index],
  //       'condition': condition,
  //       'hasRain': hasRain,
  //       'rainChance': hasRain ? [30, 60, 80, 45, 70][index % 5] : 0,
  //     };
  //   });
  // }

  // Helper method to get weather icon

  // Shimmer effect for loading state

  Widget _buildEnhancedWeatherDetails(
    HomePageController controller,
    ThemeData theme,
  ) {
    return Obx(() {
      if (controller.forecastList.isEmpty) {
        return _buildShimmerDetailsRow(theme);
      }

      final currentWeather = controller.forecastList.first;
      final isMetric =
          controller.settingsController.messureUnit.toString() == "Metric";
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildDetailCard(
                  "Wind Speed",
                  !isMetric
                      ? "${currentWeather.maxWindMph}"
                      : "${currentWeather.maxWindKph}",
                  !isMetric ? "mph" : "km/h",
                  Icons.air_rounded,
                  theme.colorScheme.primary,
                  theme,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDetailCard(
                  "Humidity",
                  "${currentWeather.humidity}",
                  "%",
                  Icons.water_drop_rounded,
                  theme.colorScheme.tertiary,
                  theme,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildDetailCard(
                  "Feels Like",
                  isMetric
                      ? "${currentWeather.avgTemp}"
                      : "${currentWeather.avgTempF}",
                  isMetric ? "°C" : "°F",
                  Icons.thermostat_rounded,
                  theme.colorScheme.secondary,
                  theme,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDetailCard(
                  "Visibility",
                  isMetric
                      ? "${currentWeather.avgVisibilityKm}"
                      : "${currentWeather.avgVisibilityMiles}",
                  isMetric ? "km" : "miles",
                  Icons.visibility_rounded,
                  const Color(0xFF10B981),
                  theme,
                ),
              ),
            ],
          ),
        ],
      );
    });
  }

  Widget _buildDetailCard(
    String title,
    String value,
    String unit,
    IconData icon,
    Color color,
    ThemeData theme,
  ) {
    final colorScheme = theme.colorScheme;

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 600),
      tween: Tween(begin: 0, end: 1),
      builder: (context, animValue, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * animValue),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color, color.withOpacity(0.7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: Colors.white, size: 24),
                ),
                const SizedBox(height: 12),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: value,
                        style: TextStyle(
                          color: colorScheme.onSurface,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const WidgetSpan(child: SizedBox(width: 4)),
                      TextSpan(
                        text: unit,
                        style: TextStyle(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildModernForecastSection(
    HomePageController controller,
    ThemeData theme,
  ) {
    final colorScheme = theme.colorScheme;

    return Obx(() {
      if (controller.forecastList.isEmpty) {
        return _buildShimmerForecastSection(theme);
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "7-Day Forecast",
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "Next Week",
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Horizontal scrolling forecast cards
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: controller.forecastList.length - 1,
              itemBuilder: (context, index) {
                final forecast = controller.forecastList[index + 1];

                return GestureDetector(
                  onTap: () {
                    Get.to(
                      () => WeatherDetailPage(
                        forecast: forecast,
                        city: controller.selectedCity.value!,
                      ),
                      transition: Transition.rightToLeftWithFade,
                      duration: const Duration(milliseconds: 300),
                    );
                  },
                  child: Container(
                    width: 160,
                    margin: const EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          colorScheme.surface,
                          colorScheme.surface.withOpacity(0.9),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(
                            theme.brightness == Brightness.dark ? 0.3 : 0.08,
                          ),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Day
                          Text(
                            _getDayName(forecast.date),
                            style: TextStyle(
                              color: colorScheme.onSurface,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          // Weather Icon
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainer,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(
                                    theme.brightness == Brightness.dark
                                        ? 0.2
                                        : 0.05,
                                  ),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Image.network(
                                "https:${forecast.iconUrl}",
                                width: 40,
                                height: 40,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(
                                      Icons.cloud_rounded,
                                      color: colorScheme.primary,
                                      size: 32,
                                    ),
                              ),
                            ),
                          ),

                          // Temperature
                          Obx(() {
                            final isMetric =
                                controller.settingsController.messureUnit
                                    .toString() ==
                                "Metric";
                            return Text(
                              isMetric
                                  ? "${forecast.avgTemp}° C"
                                  : "${forecast.avgTempF}° F",
                              style: TextStyle(
                                color: colorScheme.onSurface,
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                              ),
                            );
                          }),

                          // Condition
                          Text(
                            forecast.conditionText,
                            style: TextStyle(
                              color: colorScheme.onSurfaceVariant,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }

  // Shimmer Effect Widgets (Enhanced)
  Widget _buildShimmerWeatherCard(ThemeData theme) {
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Shimmer Location
        Row(
          children: [
            _buildShimmerContainer(24, 24, theme, isCircular: true),
            const SizedBox(width: 8),
            _buildShimmerContainer(200, 32, theme),
          ],
        ),
        const SizedBox(height: 8),
        _buildShimmerContainer(120, 16, theme),
        const SizedBox(height: 4),
        _buildShimmerContainer(180, 16, theme),
        const SizedBox(height: 32),

        // Main Weather Card Shimmer
        Container(
          width: double.infinity,
          height: 240,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [theme.primaryColor, theme.colorScheme.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: theme.primaryColor.withOpacity(0.3),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildShimmerContainer(
                      90,
                      90,
                      theme,
                      isCircular: false,
                      color: Colors.white.withOpacity(0.3),
                    ),
                    const Spacer(),
                    _buildShimmerContainer(
                      140,
                      80,
                      theme,
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ],
                ),
                const Spacer(),
                _buildShimmerContainer(
                  160,
                  40,
                  theme,
                  color: Colors.white.withOpacity(0.3),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildShimmerDetailsRow(ThemeData theme) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildShimmerDetailCard(theme)),
            const SizedBox(width: 16),
            Expanded(child: _buildShimmerDetailCard(theme)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildShimmerDetailCard(theme)),
            const SizedBox(width: 16),
            Expanded(child: _buildShimmerDetailCard(theme)),
          ],
        ),
      ],
    );
  }

  Widget _buildShimmerDetailCard(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildShimmerContainer(50, 50, theme, isCircular: false),
          const SizedBox(height: 12),
          _buildShimmerContainer(60, 20, theme),
          const SizedBox(height: 4),
          _buildShimmerContainer(80, 12, theme),
        ],
      ),
    );
  }

  Widget _buildShimmerForecastSection(ThemeData constants) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildShimmerContainer(180, 24, constants),
            _buildShimmerContainer(80, 24, constants),
          ],
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              return Container(
                width: 160,
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildShimmerContainer(80, 16, constants),
                      _buildShimmerContainer(
                        60,
                        60,
                        constants,
                        isCircular: false,
                      ),
                      _buildShimmerContainer(40, 24, constants),
                      _buildShimmerContainer(100, 12, constants),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildShimmerContainer(
    double width,
    double height,
    ThemeData theme, {
    bool isCircular = false,
    Color? color,
  }) {
    return _ShimmerEffect(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color ?? Colors.grey[300],
          borderRadius: isCircular
              ? BorderRadius.circular(height / 2)
              : BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildSelectCityCard(ThemeData theme) {
    return Container(
      width: double.infinity,
      height: 240,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.white.withOpacity(0.9)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 30,
            offset: const Offset(0, 15),
            spreadRadius: 5,
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: theme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Icon(
                Icons.location_on_rounded,
                size: 40,
                color: theme.primaryColor,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Select a city to view weather",
              style: TextStyle(
                color: theme.colorScheme.secondary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Tap to choose your location",
              style: TextStyle(
                color: theme.colorScheme.secondary.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String date) {
    final DateTime dateTime = DateTime.tryParse(date) ?? DateTime.now();
    final List<String> weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    final List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return "${weekdays[dateTime.weekday - 1]}, ${dateTime.day} ${months[dateTime.month - 1]}";
  }

  String _getDayName(String date) {
    final DateTime dateTime = DateTime.tryParse(date) ?? DateTime.now();
    final List<String> weekdays = [
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun',
    ];

    return weekdays[dateTime.weekday - 1];
  }
}

// Custom Painter for Weather Pattern Background
class WeatherPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    // Draw floating shapes
    for (int i = 0; i < 8; i++) {
      final dx = (i * size.width / 8) + (i * 20);
      final dy = (i % 2 == 0) ? size.height * 0.3 : size.height * 0.7;

      canvas.drawCircle(Offset(dx % size.width, dy), 15 + (i * 3), paint);
    }

    // Draw wave pattern
    final wavePaint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();
    path.moveTo(0, size.height * 0.6);

    for (double x = 0; x <= size.width; x += 20) {
      final y = size.height * 0.6 + 20 * sin((x / size.width) * 2 * pi);
      path.lineTo(x, y);
    }

    canvas.drawPath(path, wavePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class _ShimmerEffect extends StatefulWidget {
  final Widget child;

  const _ShimmerEffect({required this.child});

  @override
  _ShimmerEffectState createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<_ShimmerEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            // Clamp the values to ensure they stay within [0, 1] range
            final double animValue = _animation.value;
            final double start = (animValue - 0.3).clamp(0.0, 1.0);
            final double middle = animValue.clamp(0.0, 1.0);
            final double end = (animValue + 0.3).clamp(0.0, 1.0);

            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: const [
                Colors.transparent,
                Colors.white54,
                Colors.transparent,
              ],
              stops: [start, middle, end],
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcATop,
          child: widget.child,
        );
      },
    );
  }
}
