import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/products.dart';
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/product_item.dart';

class ProductManagerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Products productsProvider = Provider.of<Products>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Gerenciar de Produtos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed('/product-form');
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: productsProvider.itemsCount,
          itemBuilder: (ctx, index) => Column(
            children: [
              ProductItem(
                productsProvider.items[index],
              ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
