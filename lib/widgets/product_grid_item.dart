import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/errors/http_request_error.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/providers/product.dart';

class ProductGridItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final messengerOfContext = ScaffoldMessenger.of(context);

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

    final Cart cart = Provider.of<Cart>(
      context,
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
              onPressed: () async {
                try {
                  await product.toggleFavorite();
                } catch (e) {
                  // não é possível usar o ScaffoldMessenger.of(context) dentro de funcoes async
                  // assim precisamos definir esse messengerOfContext fora da funcao assincrona
                  messengerOfContext.showSnackBar(
                    SnackBar(content: Text('Não foi possível realizar a ação')),
                  );
                }
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
            onPressed: () {
              // ScaffoldMessenger.of subirá a hierarquia de widgets
              // até achar o Scaffold
              // quando achar é possível usar métodos desse Scaffold
              // como por exemplo abrir o Drawer se tiver

              // Scaffold.of(context).openDrawer();

              // abrindo Snack bar
              // ScaffoldMessenger.of(context).showSnackBar(SnackBar(

              // esconder SnackBar atual para não criar muitas
              // SnackBars aparecendo uma após a outra se o usuário
              // pressionar muitas vezes
              ScaffoldMessenger.of(context).hideCurrentSnackBar();

              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  'Produto adicionado ao carrinho!',
                  // textAlign: TextAlign.center,
                ),
                duration: Duration(
                  seconds: 2,
                ),
                action: SnackBarAction(
                  label: 'DESFAZER',
                  onPressed: () {
                    cart.removeSingleItem(product.id);
                  },
                ),
              ));
              cart.addItem(product);
            },
          ),
        ),
      ),
    );
  }
}
