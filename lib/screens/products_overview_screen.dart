import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/providers/products.dart';
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/badge.dart';
import 'package:shop/widgets/product_grid.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showFavoriteOnly = false;
  bool _isLoadingProducts = false;

  @override
  void initState() {
    super.initState();

    setState(() => _isLoadingProducts = true);

    refreshProducts();
  }

  Future<void> refreshProducts() async {
    setState(() => _isLoadingProducts = true);

    await Provider.of<Products>(
      context,
      listen: false,
    ).loadProducts();

    setState(() => _isLoadingProducts = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minha Loja'),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            onSelected: (FilterOptions selectedValue) {
              if (selectedValue == FilterOptions.Favorites) {
                // products.showFavoriteOnly();
                setState(() {
                  _showFavoriteOnly = true;
                });
              } else {
                setState(() {
                  _showFavoriteOnly = false;
                });
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Somente Favoritos'),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text('Todos'),
                value: FilterOptions.All,
              ),
            ],
          ),
          // O consumer é uma forma de consumir o provider
          // uma vez que este componente esteja em um
          // ponto da arvore de componentes que seja
          // alimentado por um ChangeNotifierProvider
          Consumer<Cart>(
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed('/cart');
              },
            ),
            // o Badge serve para colocar o ícone de notificação
            // em cima do widget
            builder: (ctx, cart, child) => Badge(
              value: '${cart.itemCount}',
              child: child!,
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoadingProducts
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: refreshProducts,
              child: ProductGrid(
                _showFavoriteOnly,
              ),
            ),
    );
  }
}
