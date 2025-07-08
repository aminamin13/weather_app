import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/models/city_model.dart';
import 'package:weather_app/models/daily_forecast_model.dart';
import 'package:weather_app/ui/controllers/home_page_controller.dart';

class WeatherDetailPage extends StatelessWidget {
  final DailyForecastModel forecast;
  final CityModel city;

  const WeatherDetailPage({
    super.key,
    required this.forecast,
    required this.city,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Animated Background
          _buildAnimatedBackground(theme),

          // Main Content
          SafeArea(
            child: Column(
              children: [
                // Custom App Bar
                _buildCustomAppBar(theme),

                // Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Hero Weather Card
                        _buildHeroWeatherCard(theme),

                        const SizedBox(height: 32),

                        // Enhanced Weather Details
                        _buildEnhancedWeatherDetails(theme),

                        const SizedBox(height: 32),

                        // Additional Details Section
                        _buildAdditionalDetails(theme),

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

  Widget _buildCustomAppBar(ThemeData theme) {
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        children: [
          // Back Button
          GestureDetector(
            onTap: () => Get.back(),
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
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: colorScheme.onSurface,
                size: 22,
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatDate(forecast.date),
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "${city.name}, ${city.country}",
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Share Button
          //   GestureDetector(
          //     onTap: () {
          //       // Implement share functionality
          //     },
          //     child: Container(
          //       width: 45,
          //       height: 45,
          //       decoration: BoxDecoration(
          //         color: colorScheme.surface.withOpacity(0.9),
          //         borderRadius: BorderRadius.circular(15),
          //         boxShadow: [
          //           BoxShadow(
          //             color: Colors.black.withOpacity(
          //               theme.brightness == Brightness.dark ? 0.3 : 0.1,
          //             ),
          //             blurRadius: 10,
          //             offset: const Offset(0, 5),
          //           ),
          //         ],
          //       ),
          //       child: Icon(
          //         Icons.share_rounded,
          //         color: colorScheme.onSurface,
          //         size: 22,
          //       ),
          //     ),
          //   ),
        ],
      ),
    );
  }

  Widget _buildHeroWeatherCard(ThemeData theme) {
    final colorScheme = theme.colorScheme;

    return Hero(
      tag: 'weather_card_${forecast.date}',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date Header with Animation
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
                            Icons.calendar_today_rounded,
                            color: colorScheme.primary,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _getDayName(forecast.date),
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
                        _formatFullDate(forecast.date),
                        style: TextStyle(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 32),

          // Main Weather Card
          Container(
            width: double.infinity,
            height: 280,
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
                              width: 100,
                              height: 100,
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
                                  "https:${forecast.iconUrl}",
                                  width: 80,
                                  height: 80,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(
                                        Icons.wb_sunny_rounded,
                                        color: Colors.white,
                                        size: 60,
                                      ),
                                ),
                              ),
                            ),

                            const Spacer(),

                            // Temperature with Gradient Text
                            Obx(() {
                              final isMetric =
                                  HomePageController
                                      .instance
                                      .settingsController
                                      .messureUnit
                                      .toString() ==
                                  "Metric";
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  ShaderMask(
                                    shaderCallback: (bounds) => LinearGradient(
                                      colors: [Colors.white, Colors.white70],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ).createShader(bounds),
                                    child: Text(
                                      isMetric
                                          ? "${forecast.avgTemp}°"
                                          : "${forecast.avgTempF}°",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 80,
                                        fontWeight: FontWeight.w200,
                                        letterSpacing: -2,
                                      ),
                                    ),
                                  ),
                                  // High/Low Temperature
                                  Row(
                                    children: [
                                      Text(
                                        isMetric
                                            ? "H:${forecast.maxTemp}°"
                                            : "H:${forecast.maxTempF}°",
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        isMetric
                                            ? "L:${forecast.minTemp}°"
                                            : "L:${forecast.minTempF}°",
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            }),
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
                                forecast.conditionText,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            // Feels Like Temperature
                            Obx(() {
                              final isMetric =
                                  HomePageController
                                      .instance
                                      .settingsController
                                      .messureUnit
                                      .toString() ==
                                  "Metric";
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Text(
                                  isMetric
                                      ? "Feels like ${forecast.avgTemp}°C"
                                      : "Feels like ${forecast.avgTempF}°",
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            }),
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
  }

  Widget _buildEnhancedWeatherDetails(ThemeData theme) {
    return Obx(() {
      final isMetric =
          HomePageController.instance.settingsController.messureUnit
              .toString() ==
          "Metric";
      return Column(
        children: [
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildDetailCard(
                  "Max Temp",
                  isMetric ? "${forecast.maxTemp}" : "${forecast.maxTempF}",
                  isMetric ? "°C" : "°F",
                  Icons.thermostat_rounded,
                  const Color(0xFFEF4444),
                  theme,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDetailCard(
                  "Min Temp",
                  isMetric ? "${forecast.minTemp}" : "${forecast.minTempF}",
                  isMetric ? "°C" : "°F",
                  Icons.ac_unit_rounded,
                  const Color(0xFF3B82F6),
                  theme,
                ),
              ),
            ],
          ),
        ],
      );
    });
  }

  Widget _buildAdditionalDetails(ThemeData theme) {
    final colorScheme = theme.colorScheme;

    return Obx(() {
      final isMetric =
          HomePageController.instance.settingsController.messureUnit
              .toString() ==
          "Metric";
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Additional Details",
            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 24,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 20),

          // Additional weather metrics
          Row(
            children: [
              Expanded(
                child: _buildDetailCard(
                  "UV Index",
                  forecast.uv
                      .toString(), // You can get this from your weather API
                  "",
                  Icons.wb_sunny_outlined,
                  const Color(0xFFF59E0B),
                  theme,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDetailCard(
                  "Visibility",
                  isMetric
                      ? "${forecast.avgVisibilityKm}"
                      : "${forecast.avgVisibilityMiles}",
                  isMetric ? "km" : "miles",
                  Icons.visibility_rounded,
                  const Color(0xFF10B981),
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
                  "Sunset",
                  forecast.sunset,
                  "",
                  Icons.sunny,
                  const Color.fromARGB(255, 185, 16, 16),
                  theme,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDetailCard(
                  "Sunrise",
                  forecast.sunrise, // You can get this from your weather API
                  "",
                  Icons.cloud,
                  const Color(0xFF6B7280),
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
    return weekdays[dateTime.weekday - 1];
  }

  String _formatFullDate(String date) {
    final DateTime dateTime = DateTime.tryParse(date) ?? DateTime.now();
    final List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return "${dateTime.day} ${months[dateTime.month - 1]}, ${dateTime.year}";
  }

  String _getDayName(String date) {
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

    return weekdays[dateTime.weekday - 1];
  }
}

// Custom Painter for Weather Pattern Background (same as in HomePage)
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
