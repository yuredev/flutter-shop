import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shop/data/dummy_data.dart';
import 'package:shop/providers/product.dart';
import 'package:shop/utils.dart';

class Products with ChangeNotifier {
  List<Product> _items = DUMMY_PRODUCTS;

  // bool _showFavoriteOnly = false;

  List<Product> get items {
    // if (_showFavoriteOnly) {
    //   return _items.where((p) => p.isFavorite).toList();
    // }
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  List<Product> get favoriteItems {
    return _items.where((item) => item.isFavorite).toList();
  }

  // void showFavoriteOnly() {
  //   _showFavoriteOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoriteOnly = false;
  //   notifyListeners();
  // }

  Future<void> addProduct(Product product) async {
    // o firebase obriga a terminação com .json
    const url =
        'https://yuredev-flutter-shop-default-rtdb.firebaseio.com/products.json';

    try {
      Response response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'title': product.title,
          'price': product.price,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'isFavorite': product.isFavorite,
        }),
      );
      final decodedBodyResponse = json.decode(response.body);
      print(decodedBodyResponse);
    } catch (error) {
      print(error);
    }

    _items.add(product);
    // notificar todos os observers interessados neste evento
    notifyListeners();
  }

  void removeProduct(String id) {
    _items.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  void updateProduct(Product product) {
    final index = _items.indexWhere((p) => product.id == p.id);
    if (index > -1) {
      _items[index] = product;
      notifyListeners();
    }
  }
}
