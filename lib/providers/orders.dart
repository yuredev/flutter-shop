import 'dart:convert';
import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shop/errors/http_request_error.dart';
import 'package:shop/providers/cart.dart';

class Order {
  final String id;
  final double total;
  final List<CartItem> products;
  final DateTime date;

  Order({
    required this.id,
    required this.total,
    required this.products,
    required this.date,
  });
}

class Orders with ChangeNotifier {
  final _apiBaseUrl =
      'https://yuredev-flutter-shop-default-rtdb.firebaseio.com/orders';

  List<Order> _items = [];

  List<Order> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  set thereAreNewOrders(bool thereAreNewOrders) {}

  Future<void> addOrder(List<CartItem> cartItems) async {
    final total = cartItems.fold<double>(0, (acc, cur) {
      return acc + cur.price * cur.quantity;
    });

    final res = await http.post(
      Uri.parse('$_apiBaseUrl.json'),
      body: json.encode({
        'total': total,
        'date': DateTime.now().toIso8601String(),
        'products': cartItems.map((item) => {
          'title': item.title,
          'quantity': item.quantity,
          'price': item.price,
          'productId': item.productId,
        }).toList(),
      }),
    );

    if (res.statusCode >= 400) {
      throw RequestError(
        message: 'Erro ao cadastrar o pedido',
        statusCode: res.statusCode,
      );
    }

    _items.insert(
      0,
      Order(
        id: json.decode(res.body)['name'],
        total: total,
        date: DateTime.now(),
        products: cartItems,
      ),
    );
    notifyListeners();
  }
}
