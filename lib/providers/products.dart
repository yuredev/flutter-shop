import 'package:flutter/material.dart';
import 'package:shop/data/dummy_data.dart';
import 'package:shop/providers/product.dart';

class Products with ChangeNotifier{
  List<Product> _items = DUMMY_PRODUCTS;

  // bool _showFavoriteOnly = false;

  List<Product> get items {
    // if (_showFavoriteOnly) {
    //   return _items.where((p) => p.isFavorite).toList();
    // }
    return [ ..._items ];
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

  void addProduct (Product product) {
    _items.add(product);
    // notificar todos os observers interessados neste evento 
    notifyListeners();
  }
}