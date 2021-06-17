import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shop/providers/product.dart';

class Products with ChangeNotifier {
  final _url = Uri.parse('https://yuredev-flutter-shop-default-rtdb.firebaseio.com/products.json');
  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }
  
  List<Product> get favoriteItems {
    return _items.where((item) => item.isFavorite).toList();
  }

  Future<void> loadProducts() async {
    final response = await http.get(_url);
    final data = json.decode(response.body) as Map<String, dynamic>;

    _items.clear();

    data.forEach((productId, productData) {
      _items.add(Product(
        id: productId,
        description: productData['description'],
        price: productData['price'],
        imageUrl: productData['imageUrl'],
        title: productData['title'],
        isFavorite: productData['isFavorite'],
      ));
    });

    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    // o firebase obriga a terminação com .json
    Response response = await http.post(
      _url,
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
