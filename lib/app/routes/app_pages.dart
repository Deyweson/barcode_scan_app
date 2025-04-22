import 'package:barcode_scan_app/app/modules/home/home_screen.dart';
import 'package:barcode_scan_app/app/modules/scan/scan_screen.dart';
import 'package:barcode_scan_app/app/modules/splash/splash_screen.dart';
import 'package:barcode_scan_app/app/routes/app_routes.dart';
import 'package:get/get_navigation/get_navigation.dart';

class AppPages {
  static final routes = [
    GetPage(name: AppRoutes.SPLASH, page: () => SplashScreen()),
    GetPage(name: AppRoutes.HOME, page: () => HomeScreen()),
    GetPage(name: AppRoutes.SCAN, page: () => ScanScreen()),
  ];
}
