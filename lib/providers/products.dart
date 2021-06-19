import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shop/errors/http_request_error.dart';
import 'package:shop/providers/product.dart';

class Products with ChangeNotifier {
  final _apiBaseUrl =
      'https://yuredev-flutter-shop-default-rtdb.firebaseio.com/products';
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
    final response = await http.get(Uri.parse('$_apiBaseUrl.json'));
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
      Uri.parse('$_apiBaseUrl.json'),
      body: json.encode({
        'title': product.title,
        'price': product.price,
        'description': product.description,
        'imageUrl': product.imageUrl,
        'isFavorite': product.isFavorite,
      }),
    );
    final decodedBodyResponse = json.decode(response.body);

    _items.add(Product(
      title: product.title,
      description: product.description,
      isFavorite: product.isFavorite,
      imageUrl: product.imageUrl ,
      price: product.price,
      id: decodedBodyResponse['name']
    ));
    // notificar todos os observers interessados neste evento
    notifyListeners();
  }

  Future<void> removeProduct(String id) async {
    Product product = _items.where((p) => p.id == id).toList()[0];

    _items.remove(product);
    notifyListeners();

    // a requisição de delete não dá lança nenhuma excessão, vai entender o porquê
    // assim devemos pegar o statusCode da response
    final res = await http.delete(
      Uri.parse('$_apiBaseUrl/${product.id}.json'),
    );

    if (res.statusCode >= 400) {
      _items.add(product);
      notifyListeners();
      throw RequestError(
        message: 'Erro durante a requisição',
        statusCode: res.statusCode,
      );
    }
  }

  Future<void> updateProduct(Product product) async {
    final index = _items.indexWhere((p) => product.id == p.id);
    if (index > -1) {
      await http.put(Uri.parse('$_apiBaseUrl/${product.id}.json'),
          body: json.encode({
            'title': product.title,
            'price': product.price,
            'description': product.description,
            'imageUrl': product.imageUrl,
          }));
      _items[index] = product;
      notifyListeners();
    }
  }
}
