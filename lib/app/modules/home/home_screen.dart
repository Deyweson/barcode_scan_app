import 'dart:async';

import 'package:barcode_scan_app/app/data/models/item_model.dart';
import 'package:barcode_scan_app/app/modules/home/home_controller.dart';
import 'package:barcode_scan_app/app/modules/scan/scan_screen.dart';
import 'package:barcode_widget/barcode_widget.dart' as barcode_widget;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:printing/printing.dart';
import 'package:web_scraper/web_scraper.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? scannedCode;
  //List<Item> itens = [];

  final HomeController controller = Get.put(HomeController());

  Future<void> _openScanner() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ScanScreen()),
    );
    if (result != null) {
      setState(() {
        if (controller.itemList.any((item) => item.code == result)) {
          controller.updateQuantity(
            result,
            controller.itemList
                    .firstWhere((item) => item.code == result)
                    .quantity +
                1,
          );
        } else {
          controller.addItems(Item(code: result, title: '', quantity: 1));
        }
      });
    }
  }

  Timer? _incrementTimer;

  void _startIncrement(String code) {
    _incrementTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      controller.updateQuantity(
        code,
        controller.itemList.firstWhere((item) => item.code == code).quantity +
            1,
      );
    });
  }

  void _stopIncrement() {
    _incrementTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Barcode Scan App", style: TextStyle(color: Colors.white)),
        leading: Icon(Icons.barcode_reader, color: Colors.red),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: controller.sharePdf,
            icon: Icon(Icons.picture_as_pdf, color: Colors.white),
          ),
        ],
      ),
      body: Obx(() {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: controller.itemList.reversed.length,
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
                                onTap: () async {
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
                                              data:
                                                  controller
                                                      .itemList[index]
                                                      .code,
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
                                          TextButton(
                                            onPressed: () {
                                              final Uri url = Uri.parse(
                                                'https://www.google.com/search?q=${controller.itemList[index].code}',
                                              );
                                              launchUrl(
                                                url,
                                                mode:
                                                    LaunchMode.inAppBrowserView,
                                              );
                                            },
                                            child: Text('Buscar no Google'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Column(
                                  children: [
                                    barcode_widget.BarcodeWidget(
                                      barcode: barcode_widget.Barcode.code128(),
                                      data: controller.itemList[index].code,
                                    ),
                                    SizedBox(
                                      width: 200, // Largura
                                      child: Text(
                                        controller.itemList[index].title ?? '',
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontSize: 10,
                                          overflow: TextOverflow.clip,
                                        ),
                                      ),
                                    ),
                                  ],
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
                                      onLongPress:
                                          () => {
                                            controller.updateQuantity(
                                              controller.itemList[index].code,
                                              0,
                                            ),
                                          },
                                      onPressed:
                                          () => {
                                            controller
                                                        .itemList[index]
                                                        .quantity >
                                                    1
                                                ? controller.updateQuantity(
                                                  controller
                                                      .itemList[index]
                                                      .code,
                                                  controller
                                                          .itemList[index]
                                                          .quantity -
                                                      1,
                                                )
                                                : null,
                                          },
                                      child: Icon(Icons.remove),
                                    ),
                                  ),
                                  Text(
                                    controller.itemList[index].quantity
                                        .toString(),
                                    style: TextStyle(fontSize: 30),
                                  ),
                                  SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: GestureDetector(
                                      onLongPress: () {
                                        _startIncrement(
                                          controller.itemList[index].code,
                                        );
                                      },
                                      onLongPressUp: _stopIncrement,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.zero,
                                        ),

                                        onPressed:
                                            () => controller.updateQuantity(
                                              controller.itemList[index].code,
                                              controller
                                                      .itemList[index]
                                                      .quantity +
                                                  1,
                                            ),
                                        child: Icon(Icons.add),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              ElevatedButton(
                                onPressed:
                                    () => controller.deleteItem(
                                      controller.itemList[index].code,
                                    ),
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
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: _openScanner,
        backgroundColor: Colors.black,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
