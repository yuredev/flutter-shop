import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/errors/delete_request_error.dart';
import 'package:shop/providers/product.dart';
import 'package:shop/providers/products.dart';
import 'package:shop/utils.dart';

class ProductItem extends StatelessWidget {
  final Product product;
  final BuildContext scaffoldContext;

  ProductItem(this.product, { required this.scaffoldContext });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      title: Text(product.title),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.of(context).pushNamed(
                  '/product-form',
                  arguments: product,
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              color: Theme.of(context).errorColor,
              onPressed: () async {
                bool productShouldBeDeleted = await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Excluir Produto'),
                    content: Text('Tem certeza?'),
                    actions: [
                      FlatButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text('Não'),
                      ),
                      FlatButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: Text('Sim'),
                      ),
                    ],
                  ),
                ) as bool;
                if (productShouldBeDeleted) {
                  try {
                    await Provider.of<Products>(context, listen: false)
                        .removeProduct(product.id);
                    showSnackbar(
                      context: scaffoldContext,
                      contentText: 'Produto deletado com sucesso',
                    );
                  } on DeleteRequestException {
                    showSnackbar(
                      context: scaffoldContext,
                      contentText: 'Não foi possível deletar o produto',
                    );
                  }
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
