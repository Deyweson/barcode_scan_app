import 'package:barcode_scan_app/app/data/database/database_helper.dart';
import 'package:barcode_scan_app/app/data/models/item_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  @override
  void onInit() {
    super.onInit();
    loadItems();
  }
}
