import 'dart:typed_data';

import 'package:barcode_scan_app/app/data/database/database_helper.dart';
import 'package:barcode_scan_app/app/data/models/item_model.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:share_plus/share_plus.dart';

import 'package:pdf/widgets.dart' as pw;

class HomeController extends GetxController {
  var itemList = <Item>[].obs;
  final DatabaseHelper databaseHelper = DatabaseHelper();

  void loadItems() async {
    final List<Item> items = await databaseHelper.getItems();
    itemList.assignAll(items.reversed);
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

  Future<void> sharePdf() async {
    final pdf = generatePdf();
    final Uint8List pdfData = await pdf.save();

    final temp = await getTemporaryDirectory();
    final filePath = "${temp.path}/relatorio.pdf";
    final file = File(filePath);
    await file.writeAsBytes(pdfData);

    await Share.shareXFiles([XFile(filePath)]);
  }

  pw.Document generatePdf() {
    final pdf = pw.Document();

    DateTime now = DateTime.now();
    String formattedDate = "${now.day}/${now.month}/${now.year}";

    pdf.addPage(
      pw.MultiPage(
        build: (pw.Context context) {
          return [
            pw.Center(
              child: pw.Column(
                children: [
                  pw.Text('Lista dia: $formattedDate'),
                  pw.SizedBox(height: 20),

                  // Gerando a lista de itens de dois em dois
                  for (int i = 0; i < itemList.length; i += 2)
                    pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        _buildItem(itemList[i]),
                        if (i + 1 < itemList.length) ...[
                          pw.SizedBox(width: 40), // espaçamento entre os itens
                          _buildItem(itemList[i + 1]),
                        ],
                        pw.SizedBox(height: 70),
                      ],
                    ),
                ],
              ),
            ),
          ];
        },
      ),
    );

    return pdf;
  }

  pw.Widget _buildItem(Item item) {
    return pw.Row(
      children: [
        pw.BarcodeWidget(
          barcode: Barcode.code128(),
          data: item.code,
          width: 150,
          height: 60,
          drawText: true,
        ),
        pw.SizedBox(height: 5),
        pw.Text('Quantity: ${item.quantity}'),
      ],
    );
  }

  @override
  void onInit() {
    super.onInit();
    loadItems();
  }
}
