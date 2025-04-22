class Item {
  String code;
  String? title;
  int quantity;
  Item({required this.code, this.title, required this.quantity});

  Map<String, dynamic> toMap() {
    return {'code': code, 'title': title, 'quantity': quantity};
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      code: map['code'],
      title: map['title'] ?? '',
      quantity: map['quantity']?.toInt() ?? 0,
    );
  }
}
