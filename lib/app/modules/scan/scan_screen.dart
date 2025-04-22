import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanScreen extends StatefulWidget {
  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  MobileScannerController controller = MobileScannerController();

  void _onDetect(BarcodeCapture barcode) async {
    final String? code = barcode.barcodes.first.rawValue;
    if (code != null) {
      debugPrint("Barcode found! $code");
      await controller.stop();
      Navigator.pop(context, code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan'),
        actions: [
          IconButton(
            icon: Icon(Icons.flash_on),
            onPressed: () => controller.toggleTorch(),
          ),
          IconButton(
            icon: Icon(Icons.flip_camera_android),
            onPressed: () => controller.switchCamera(),
          ),
        ],
      ),
      body: MobileScanner(controller: controller, onDetect: _onDetect),
    );
  }
}
