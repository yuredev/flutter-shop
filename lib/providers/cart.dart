import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:shop/providers/product.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;
  final String productId;

  CartItem({
    @required this.id,
    @required this.productId,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}

class Cart with ChangeNotifier {
  // o hashmap de itens terá como chave o id do item
  // do carrinho o segundo valor vai ser uma classe 
  // cartItem que terá os atributos do produto e a quantidade
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    double total = 0;
    _items.forEach((id, item) {
      total += item.price * item.quantity;
    });
    return total;
  }

  void addItem(Product product) {
    // caso o produto exista no carrinho será
    // preciso alteralo
    // porem apenas mudando a quantidade
    if (_items.containsKey(product.id)) {
      _items.update(
        product.id,
        (existingItem) => CartItem(
          productId: product.id,
          id: existingItem.id,
          title: existingItem.title,
          quantity: existingItem.quantity + 1,
          price: existingItem.price,
        ),
      );
    } else {
      // adicionar se não existe
      _items.putIfAbsent(
        product.id,
        () => CartItem(
          productId: product.id,
          id: Random().nextDouble().toString(),
          title: product.title,
          quantity: 1,
          price: product.price,
        ),
      );
    }
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (_items.containsKey(productId)) {
      if (_items[productId].quantity == 1) {
        removeItem(productId);
      } else {
        _items.update(
          productId,
          (existingItem) => CartItem(
            productId: productId,
            id: existingItem.id,
            title: existingItem.title,
            quantity: existingItem.quantity - 1,
            price: existingItem.price,
          ),
        );
        notifyListeners();
      }
    }
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
