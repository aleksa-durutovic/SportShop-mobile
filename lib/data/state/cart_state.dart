import 'package:flutter/foundation.dart';

class CartItem {
  final String name;
  final String desc;
  final String image;
  final int price;
  int quantity;

  CartItem({
    required this.name,
    required this.desc,
    required this.image,
    required this.price,
    this.quantity = 1,
  });
}

class CartState extends ChangeNotifier {
  CartState._();
  static final CartState instance = CartState._();

  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get total =>
      _items.fold(0, (sum, item) => sum + (item.price * item.quantity));

  void addItem({
    required String name,
    required String desc,
    required String image,
    required int price,
  }) {
    final idx = _items.indexWhere((e) => e.name == name);
    if (idx >= 0) {
      _items[idx].quantity += 1;
    } else {
      _items.add(
        CartItem(
          name: name,
          desc: desc,
          image: image,
          price: price,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String name) {
    _items.removeWhere((e) => e.name == name);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}