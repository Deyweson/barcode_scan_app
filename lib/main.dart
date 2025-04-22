import 'package:barcode_scan_app/app/routes/app_pages.dart';
import 'package:barcode_scan_app/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Barcode Scan App',
      initialRoute: AppRoutes.SPLASH,
      getPages: AppPages.routes,
    );
  }
}
