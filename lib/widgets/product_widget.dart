import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/product.dart';

class ProductWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Product product = Provider.of<Product>(
      context,
      // o atributo nomeado listen indica se este widget
      // ficará ou não ouvindo mudanças nos dados de Product
      // o padrão é true

      // é indicado usá-lo para poupar que o widget renderize
      // novamente desnecessariamente
      // quando os atributos a serem
      // exibidos não irão ser alterados, ou seja
      // atributos finais
      listen: false,
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              '/product-details',
              arguments: product,
            );
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (ctx) => ProductDetailsScreen(
            //       product,
            //     ),
            //   ),
            // );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          // o unico ponto onde são ouvidas mudanças 
          // é a parte do isFavorite
          // para isto, basta-se utilizar o Widget Consumer
          leading: Consumer<Product>(
            // no child coloca-se partes do elemento que não irão mudar
            // child: Text('Nunca muda'),
            builder: (ctx, product, child) => IconButton(
              icon: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border,
              ),
              color: Theme.of(context).accentColor,
              onPressed: () {
                product.toggleFavorite();
              },
            ),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            color: Theme.of(context).accentColor,
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}
