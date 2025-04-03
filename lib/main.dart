import 'package:barcode_widget/barcode_widget.dart' as barcode_widget;
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            textStyle: TextStyle(fontSize: 20),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Item {
  String code;
  int quantity;
  Item({required this.code, required this.quantity});
}

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? scannedCode;
  List<Item> itens = [];

  Future<void> _openScanner() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ScanScreen()),
    );
    if (result != null) {
      setState(() {
        if (itens.any((item) => item.code == result)) {
          itens.firstWhere((item) => item.code == result).quantity++;
        } else {
          itens.add(Item(code: result, quantity: 1));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Barcode Scan App", style: TextStyle(color: Colors.white)),
        leading: Icon(Icons.barcode_reader, color: Colors.red),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: itens.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Card(
                      margin: EdgeInsets.all(5),

                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                debugPrint("Item: ${itens[index].code}");
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Barcode"),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          barcode_widget.BarcodeWidget(
                                            barcode:
                                                barcode_widget
                                                    .Barcode.code128(),
                                            data: itens[index].code,
                                          ),
                                        ],
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text("Close"),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: barcode_widget.BarcodeWidget(
                                barcode: barcode_widget.Barcode.code128(),
                                data: itens[index].code,
                              ),
                            ),
                            Column(
                              children: [
                                SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.zero,
                                    ),
                                    onPressed:
                                        () => setState(() {
                                          if (itens[index].quantity > 0) {
                                            itens[index].quantity--;
                                          }
                                        }),
                                    child: Icon(Icons.remove),
                                  ),
                                ),
                                Text(
                                  itens[index].quantity.toString(),
                                  style: TextStyle(fontSize: 30),
                                ),
                                SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.zero,
                                    ),
                                    onPressed:
                                        () => setState(() {
                                          itens[index].quantity++;
                                        }),
                                    child: Icon(Icons.add),
                                  ),
                                ),
                              ],
                            ),
                            ElevatedButton(
                              onPressed:
                                  () => setState(() {
                                    itens.removeAt(index);
                                  }),
                              child: Icon(Icons.delete),
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
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openScanner,
        backgroundColor: Colors.black,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

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
