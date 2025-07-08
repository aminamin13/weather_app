import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/models/city_model.dart';
import 'package:weather_app/ui/controllers/home_page_controller.dart';
import 'package:weather_app/ui/controllers/settings_page_controller.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsController = Get.put(SettingsController());
    final homeController = Get.find<HomePageController>();
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
                // Enhanced Header
                _buildEnhancedHeader(theme),

                // Settings Content
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // App Settings Section
                        _buildAppSettingsSection(settingsController, theme),

                        const SizedBox(height: 32),

                        // Units Settings Section
                        _buildUnitsSection(settingsController, theme),

                        const SizedBox(height: 32),

                        // Saved Cities Section
                        _buildSavedCitiesSection(homeController, theme),

                        const SizedBox(height: 32),

                        // Notifications Section
                        // _buildNotificationsSection(settingsController, theme),
                        const SizedBox(height: 32),

                        // About Section
                        _buildAboutSection(theme, settingsController),

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
            colorScheme.primary.withOpacity(0.05),
            colorScheme.secondary.withOpacity(0.03),
            colorScheme.tertiary.withOpacity(0.05),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Floating Orbs
          Positioned(
            top: 80,
            right: 30,
            child: _buildFloatingOrb(60, colorScheme.primary.withOpacity(0.08)),
          ),
          Positioned(
            top: 250,
            left: 20,
            child: _buildFloatingOrb(
              90,
              colorScheme.secondary.withOpacity(0.06),
            ),
          ),
          Positioned(
            bottom: 150,
            right: 60,
            child: _buildFloatingOrb(
              70,
              colorScheme.tertiary.withOpacity(0.08),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingOrb(double size, Color color) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(seconds: 3),
      tween: Tween(begin: 0, end: 1),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, -15 * value),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.2),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEnhancedHeader(ThemeData theme) {
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
                    color: colorScheme.shadow.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: colorScheme.onSurface,
                size: 20,
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
                  "Settings",
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1,
                  ),
                ),
                Text(
                  "Customize your weather experience",
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppSettingsSection(
    SettingsController controller,
    ThemeData theme,
  ) {
    return _buildSettingsSection("App Settings", theme, [
      Obx(
        () => _buildSwitchTile(
          "Dark Mode",
          "Enable dark theme",
          Icons.dark_mode_rounded,
          controller.isDarkMode.value,
          (value) => controller.toggleDarkMode(),
          theme,
        ),
      ),
      // Obx(
      //   () => _buildTile(
      //     "Notification Time",
      //     controller.notificationTime.value,
      //     Icons.access_time_rounded,
      //     theme,
      //     onTap: () => controller.showTimePickerDialog(controller, theme),
      //   ),
      // ),
      // Obx(
      //   () => _buildSwitchTile(
      //     "Auto Refresh",
      //     "Update weather automatically",
      //     Icons.refresh_rounded,
      //     controller.autoRefresh.value,
      //     (value) => controller.toggleAutoRefresh(),
      //     theme,
      //   ),
      // ),
      // _buildTile(
      //   "Refresh Interval",
      //   "Every 30 minutes",
      //   Icons.schedule_rounded,
      //   theme,
      //   onTap: () => _showRefreshIntervalDialog(controller, theme),
      // ),
    ]);
  }

  Widget _buildUnitsSection(SettingsController controller, ThemeData theme) {
    return _buildSettingsSection("Units", theme, [
      Obx(
        () => _buildTile(
          "Measurement System",
          controller.messureUnit.value,
          Icons.unarchive_outlined,
          theme,
          onTap: () => controller.showMeasurementUnitDialog(theme),
        ),
      ),
    ]);
  }

  Widget _buildSavedCitiesSection(
    HomePageController controller,
    ThemeData theme,
  ) {
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Saved Cities",
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Obx(
                () => Text(
                  "${controller.cities.length} cities",
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Cities List
        Obx(() {
          if (controller.cities.isEmpty) {
            return _buildEmptyCitiesCard(theme);
          }

          return Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              children: controller.cities.asMap().entries.map((entry) {
                final index = entry.key;
                final city = entry.value;
                final isLast = index == controller.cities.length - 1;

                return _buildCityTile(city, controller, theme, isLast: isLast);
              }).toList(),
            ),
          );
        }),
      ],
    );
  }

  // Widget _buildNotificationsSection(
  //   SettingsController controller,
  //   ThemeData theme,
  // ) {
  //   return _buildSettingsSection("Notifications", theme, [
  //     Obx(
  //       () => _buildSwitchTile(
  //         "Weather Alerts",
  //         "Severe weather notifications",
  //         Icons.warning_rounded,
  //         controller.weatherAlerts.value,
  //         (value) => controller.toggleWeatherAlerts(),
  //         theme,
  //       ),
  //     ),
  //     Obx(
  //       () => _buildSwitchTile(
  //         "Daily Forecast",
  //         "Daily weather summary",
  //         Icons.today_rounded,
  //         controller.dailyForecast.value,
  //         (value) => controller.toggleDailyForecast(),
  //         theme,
  //       ),
  //     ),
  //     _buildTile(
  //       "Notification Time",
  //       "8:00 AM",
  //       Icons.access_time_rounded,
  //       theme,
  //       onTap: () => _showTimePickerDialog(controller, theme),
  //     ),
  //   ]);
  // }

  void _showPrivacyPolicyDialog(ThemeData theme) {
    final colorScheme = theme.colorScheme;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: colorScheme.surface,
        child: Container(
          width: double.maxFinite,
          height: MediaQuery.of(Get.context!).size.height * 0.8,
          padding: const EdgeInsets.all(0),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.primary.withOpacity(0.8),
                      colorScheme.secondary.withOpacity(0.6),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.privacy_tip_rounded,
                      color: colorScheme.onPrimary,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Privacy Policy",
                        style: TextStyle(
                          color: colorScheme.onPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colorScheme.onPrimary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.close_rounded,
                          color: colorScheme.onPrimary,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Last updated: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                        style: TextStyle(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 20),

                      _buildPolicySection(
                        "Information We Collect",
                        "• Location data (when you grant permission) to provide accurate weather information for your area\n"
                            "• Search history for cities you've looked up\n"
                            "• App preferences and settings\n"
                            "• Device information for app optimization",
                        theme,
                      ),

                      _buildPolicySection(
                        "How We Use Your Information",
                        "• Provide personalized weather forecasts and alerts\n"
                            "• Improve app performance and user experience\n"
                            "• Send weather notifications (if enabled)\n"
                            "• Cache data for offline functionality",
                        theme,
                      ),

                      _buildPolicySection(
                        "Data Storage and Security",
                        "• Your data is stored locally on your device\n"
                            "• We use industry-standard encryption\n"
                            "• No personal data is sold to third parties\n"
                            "• Weather data is sourced from reliable weather services",
                        theme,
                      ),

                      _buildPolicySection(
                        "Location Data",
                        "• Location access is optional and can be disabled anytime\n"
                            "• Used only to provide weather for your current location\n"
                            "• Location data is not stored permanently\n"
                            "• You can manually add cities without location access",
                        theme,
                      ),

                      _buildPolicySection(
                        "Third-Party Services",
                        "• We use weather APIs to fetch current weather data\n"
                            "• These services may have their own privacy policies\n"
                            "• No personal information is shared with weather providers\n"
                            "• Only necessary data for weather requests is transmitted",
                        theme,
                      ),

                      _buildPolicySection(
                        "Your Rights",
                        "• Access and modify your app settings anytime\n"
                            "• Delete saved cities and preferences\n"
                            "• Disable location access and notifications\n"
                            "• Request data deletion by contacting us",
                        theme,
                      ),

                      _buildPolicySection(
                        "Changes to This Policy",
                        "We may update this privacy policy from time to time. We will notify you of any changes by posting the new privacy policy within the app. You are advised to review this privacy policy periodically for any changes.",
                        theme,
                      ),

                      _buildPolicySection(
                        "Contact Us",
                        "If you have any questions about this privacy policy, please contact us at:\n\n"
                            "Email: privacy@weatherapp.com\n"
                            "Address: 123 Weather St, Cloud City, CC 12345",
                        theme,
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              // Footer
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "By using this app, you agree to our privacy policy.",
                        style: TextStyle(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Get.back(),
                      child: Text(
                        "Got it",
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  void _showTermsOfServiceDialog(ThemeData theme) {
    final colorScheme = theme.colorScheme;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: colorScheme.surface,
        child: Container(
          width: double.maxFinite,
          height: MediaQuery.of(Get.context!).size.height * 0.8,
          padding: const EdgeInsets.all(0),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.primary.withOpacity(0.8),
                      colorScheme.secondary.withOpacity(0.6),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.description_rounded,
                      color: colorScheme.onPrimary,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Terms of Service",
                        style: TextStyle(
                          color: colorScheme.onPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colorScheme.onPrimary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.close_rounded,
                          color: colorScheme.onPrimary,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Last updated: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                        style: TextStyle(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 20),

                      _buildPolicySection(
                        "Acceptance of Terms",
                        "By downloading, installing, or using the Weather App, you agree to be bound by these Terms of Service. If you do not agree to these terms, please do not use our app.",
                        theme,
                      ),

                      _buildPolicySection(
                        "Description of Service",
                        "Weather App provides weather forecasts, current conditions, and weather-related information. The service includes:\n"
                            "• Current weather conditions\n"
                            "• Multi-day weather forecasts\n"
                            "• Weather alerts and notifications\n"
                            "• Location-based weather information",
                        theme,
                      ),

                      _buildPolicySection(
                        "User Responsibilities",
                        "• Provide accurate location information when requested\n"
                            "• Use the app in accordance with applicable laws\n"
                            "• Not attempt to reverse engineer or modify the app\n"
                            "• Report any bugs or security issues responsibly",
                        theme,
                      ),

                      _buildPolicySection(
                        "Weather Data Accuracy",
                        "While we strive to provide accurate weather information, we cannot guarantee the completeness or accuracy of weather data. Weather forecasts are predictions and should not be solely relied upon for critical decisions. Always consult official weather services for severe weather warnings.",
                        theme,
                      ),

                      _buildPolicySection(
                        "Limitation of Liability",
                        "Weather App and its developers shall not be liable for any direct, indirect, incidental, consequential, or punitive damages arising from your use of the app or reliance on weather information provided.",
                        theme,
                      ),

                      _buildPolicySection(
                        "App Availability",
                        "• We strive to maintain 99% uptime\n"
                            "• Service may be temporarily unavailable for maintenance\n"
                            "• We reserve the right to modify or discontinue features\n"
                            "• Weather data depends on third-party services",
                        theme,
                      ),

                      _buildPolicySection(
                        "Intellectual Property",
                        "The Weather App, including its design, code, and content, is protected by copyright and other intellectual property laws. You may not copy, modify, distribute, or create derivative works without permission.",
                        theme,
                      ),

                      _buildPolicySection(
                        "Updates and Modifications",
                        "• We may update the app to improve functionality\n"
                            "• New features may be added periodically\n"
                            "• These terms may be updated with app updates\n"
                            "• Continued use constitutes acceptance of new terms",
                        theme,
                      ),

                      _buildPolicySection(
                        "Termination",
                        "You may stop using the app at any time by deleting it from your device. We reserve the right to terminate or suspend access to our services for violations of these terms.",
                        theme,
                      ),

                      _buildPolicySection(
                        "Contact Information",
                        "For questions about these terms of service, please contact us at:\n\n"
                            "Email: support@weatherapp.com\n"
                            "Website: www.weatherapp.com\n"
                            "Address: 123 Weather St, Cloud City, CC 12345",
                        theme,
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              // Footer
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "By using this app, you agree to these terms of service.",
                        style: TextStyle(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Get.back(),
                      child: Text(
                        "Accept",
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  Widget _buildPolicySection(String title, String content, ThemeData theme) {
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.outline.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Text(
              content,
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: 14,
                height: 1.6,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(ThemeData theme, SettingsController controller) {
    return _buildSettingsSection("About", theme, [
      _buildTile("Version", "1.0.0", Icons.info_outline_rounded, theme),
      _buildTile(
        "Privacy Policy",
        "View privacy policy",
        Icons.privacy_tip_outlined,
        theme,
        onTap: () => _showPrivacyPolicyDialog(theme),
      ),
      _buildTile(
        "Terms of Service",
        "View terms",
        Icons.description_outlined,
        theme,
        onTap: () => _showTermsOfServiceDialog(theme),
      ),
      _buildTile(
        "Rate App",
        "Rate us on the store",
        Icons.star_outline_rounded,
        theme,
        onTap: () {
          controller.requestReview();
        },
      ),
    ]);
  }

  Widget _buildSettingsSection(
    String title,
    ThemeData theme,
    List<Widget> children,
  ) {
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 8),
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    Function(bool) onChanged,
    ThemeData theme,
  ) {
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.primary.withOpacity(0.8),
                  colorScheme.secondary.withOpacity(0.6),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primary.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: colorScheme.onPrimary, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Transform.scale(
            scale: 0.8,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: colorScheme.primary,
              activeTrackColor: colorScheme.primary.withOpacity(0.3),
              inactiveThumbColor: colorScheme.onSurfaceVariant,
              inactiveTrackColor: colorScheme.onSurfaceVariant.withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTile(
    String title,
    String subtitle,
    IconData icon,
    ThemeData theme, {
    VoidCallback? onTap,
  }) {
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme.primary.withOpacity(0.8),
                    colorScheme.secondary.withOpacity(0.6),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(icon, color: colorScheme.onPrimary, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              Icon(
                Icons.chevron_right_rounded,
                color: colorScheme.onSurfaceVariant,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCityTile(
    CityModel city,
    HomePageController controller,
    ThemeData theme, {
    bool isLast = false,
  }) {
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        border: !isLast
            ? Border(
                bottom: BorderSide(
                  color: colorScheme.outline.withOpacity(0.2),
                  width: 1,
                ),
              )
            : null,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorScheme.primary.withOpacity(0.8),
                colorScheme.secondary.withOpacity(0.6),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(
            Icons.location_city_rounded,
            color: colorScheme.onPrimary,
            size: 20,
          ),
        ),
        title: Text(
          city.name,
          style: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          city.country,
          style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 14),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Current city indicator
            if (controller.selectedCity.value?.name == city.name)
              Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "Current",
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            // Delete button
            GestureDetector(
              onTap: () => _showDeleteCityDialog(city, controller, theme),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.delete_outline_rounded,
                  color: colorScheme.error,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
        onTap: () {
          controller.updateSelectedCity(city);
          Get.back(); // Return to home page
        },
      ),
    );
  }

  Widget _buildEmptyCitiesCard(ThemeData theme) {
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.location_off_rounded,
              size: 30,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "No saved cities",
            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Search and add cities to see them here",
            style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showDeleteCityDialog(
    CityModel city,
    HomePageController controller,
    ThemeData theme,
  ) {
    final colorScheme = theme.colorScheme;

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: colorScheme.surface,
        title: Text(
          "Delete City",
          style: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          "Are you sure you want to remove ${city.name} from your saved cities?",
          style: TextStyle(color: colorScheme.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              "Cancel",
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
          ),
          TextButton(
            onPressed: () {
              controller.deleteCity(city);
              Get.back();
            },
            child: Text("Delete", style: TextStyle(color: colorScheme.error)),
          ),
        ],
      ),
    );
  }

  // void _showRefreshIntervalDialog(
  //   SettingsController controller,
  //   ThemeData theme,
  // ) {
  //   final colorScheme = theme.colorScheme;

  //   Get.dialog(
  //     AlertDialog(
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  //       backgroundColor: colorScheme.surface,
  //       title: Text(
  //         "Refresh Interval",
  //         style: TextStyle(
  //           color: colorScheme.onSurface,
  //           fontWeight: FontWeight.w700,
  //         ),
  //       ),
  //       content: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: ["15 minutes", "30 minutes", "1 hour", "2 hours"]
  //             .map(
  //               (interval) => ListTile(
  //                 title: Text(
  //                   interval,
  //                   style: TextStyle(color: colorScheme.onSurface),
  //                 ),
  //                 onTap: () {
  //                   controller.setRefreshInterval(interval);
  //                   Get.back();
  //                 },
  //               ),
  //             )
  //             .toList(),
  //       ),
  //     ),
  //   );
  // }
}
