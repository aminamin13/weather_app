import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/ui/home_page.dart';

class GetStartedController extends GetxController {
  goToHomePage( ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seen', true);
    Get.off(
      HomePage(),
      transition: Transition.fadeIn,
      duration: Duration(milliseconds: 400),
    );
  }
}
