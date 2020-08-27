import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/products_provider.dart';
import 'package:shop/widgets/product_widget.dart';

class ProductGrid extends StatelessWidget {
  final bool showFavoriteOnly;

  ProductGrid(this.showFavoriteOnly);

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
    final products = showFavoriteOnly
        ? productsProvider.favoriteItems
        : productsProvider.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.6 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      // como o componente App já tem o ChangeNotifierProvider
      // a documentação recomenda utilizar o construtor value do
      // ChangeNotifierProvider, pois ao reusar o ChangeNotifierProvider
      // que tem o create dentro de um ChangeNotifierProvider que já existe
      // pode ocorrer erros na hora de deletar os produtos por exemplo
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: products[i],
        child: ProductWidget(),
      ),
    );
  }
}
