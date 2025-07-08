import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/data/city_repository.dart';
import 'package:weather_app/models/city_model.dart';
import 'package:weather_app/ui/controllers/home_page_controller.dart';

class CitySearchController extends GetxController {
  final CitiesRepository _repository = CitiesRepository();
  final TextEditingController searchController = TextEditingController();

  var searchResults = <CityModel>[].obs;
  var isLoading = false.obs;
  var hasSearched = false.obs;
  Timer? _debounceTimer;

  void searchCities(String query) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      if (query.trim().isEmpty) {
        searchResults.clear();
        hasSearched.value = false;
        return;
      }

      isLoading.value = true;
      hasSearched.value = true;

      try {
        final cities = await _repository.searchCities(query);
        searchResults.value = cities;
      } catch (e) {
        searchResults.clear();
        Get.snackbar(
          "Error",
          "Failed to search cities. Please try again.",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      } finally {
        isLoading.value = false;
      }
    });
  }

 void selectCity(CityModel city) {
  final homeController = Get.find<HomePageController>(); // FIXED
  homeController.updateSelectedCity(city);
 }


  void clearSearch() {
    searchController.clear();
    searchResults.clear();
    hasSearched.value = false;
  }

  @override
  void onClose() {
    _debounceTimer?.cancel();
    searchController.dispose();
    super.onClose();
  }
}
