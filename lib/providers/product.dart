import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop/errors/http_request_error.dart';

class Product with ChangeNotifier {
  final _apiBaseUrl =
      'https://yuredev-flutter-shop-default-rtdb.firebaseio.com/products';
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  late bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    bool? isFavorite,
  }) {
    this.isFavorite = isFavorite == null ? false : isFavorite;
  }

  Future<void> toggleFavorite() async {
    this.isFavorite = !this.isFavorite;
    notifyListeners();

    final res = await http.patch(
      Uri.parse('$_apiBaseUrl/$id.json'),
      body: json.encode({
        'isFavorite': isFavorite,
      }),
    );

    if (res.statusCode >= 400) {
      this.isFavorite = !this.isFavorite;
      notifyListeners();
      throw RequestError(
        message: 'Não foi possível mudar o estado de favorito',
        statusCode: res.statusCode,
      );
    }
  }
}
