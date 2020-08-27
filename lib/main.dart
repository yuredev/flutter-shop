import 'package:flutter/material.dart';
import 'package:shop/providers/products_provider.dart';
import 'package:shop/views/product_details_screen.dart';
import 'package:shop/views/products_overview_screen.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => ProductsProvider(),
      child: MaterialApp(
        title: 'Minha Loja',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        routes: {
          '/': (_) => ProductsOverviewScreen(),
          '/product-details': (_) => ProductDetailsScreen(),
        },
      ),
    );
  }
}
