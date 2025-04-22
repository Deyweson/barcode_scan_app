import 'dart:typed_data';

import 'package:barcode_scan_app/app/data/database/database_helper.dart';
import 'package:barcode_scan_app/app/data/models/item_model.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:pdf/widgets.dart' as pw;

class HomeController extends GetxController {
  var itemList = <Item>[].obs;
  final DatabaseHelper databaseHelper = DatabaseHelper();

  void loadItems() async {
    final List<Item> items = await databaseHelper.getItems();
    itemList.assignAll(items);
  }

  void addItems(Item item) async {
    await databaseHelper.insertItem(item);
    loadItems();
  }

  void deleteItem(String code) async {
    final deletedItem = itemList.firstWhere((item) => item.code == code);

    await databaseHelper.deleteItem(code);

    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        content: Text('Item deleted: ${code}'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            addItems(deletedItem);
          },
        ),
      ),
    );

    loadItems();
  }

  void updateQuantity(String code, int quantity) async {
    await databaseHelper.updateQuantity(code, quantity);
    loadItems();
  }

  Future<Uint8List> generatePDF() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (pw.Context context) {
          return [
            pw.Center(
              child: pw.Column(
                children: [
                  pw.Text('Items List'),
                  pw.SizedBox(height: 20),

                  // Gerando a lista de itens com código de barras e quantidade
                  for (var item in itemList) ...[
                    pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.BarcodeWidget(
                          barcode: Barcode.code128(),
                          data: item.code,
                          width: 150,
                          height: 60,
                          drawText: true,
                        ),
                        pw.SizedBox(width: 20),
                        pw.Text('Quantity: ${item.quantity}'),
                      ],
                    ),
                    pw.SizedBox(height: 10),
                  ],
                ],
              ),
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }

  @override
  void onInit() {
    super.onInit();
    loadItems();
  }
}
