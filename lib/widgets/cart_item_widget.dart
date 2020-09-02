import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/cart.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;

  CartItemWidget(this.cartItem);

  @override
  Widget build(BuildContext context) {
    // componente deslizavel pros lados
    return Dismissible(
      key: ValueKey(cartItem.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Tem certeza?'),
            content: Text('Quer remover o item do carrino?'),
            actions: [
              FlatButton(
                child: Text('Não'),
                onPressed: () {
                  // o showDialog retorna uma Future 

                  // essa Future só é resolvida na chamada do método 
                  // Navigator.of().pop
                  // o confirmDismiss espera uma função Future que ao 
                  // resolvida retorna um boolean 
                  // dessa forma podemos passar o valor para o pop 
                  // assim o showDialog retorna uma Furure<bool>
                  // compatível com o atriuto confirmDismiss
                  Navigator.of(context).pop(false);
                },
              ),
              FlatButton(
                child: Text('Sim'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              )
            ],
          ),
        );
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false)
            .removeItem(cartItem.productId);
      },
      background: Container(
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Theme.of(context).errorColor,
            ],
          ),
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(
          right: 10,
        ),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            title: Text(cartItem.title),
            subtitle: Text(
              'Total: R\$ ${(cartItem.price * cartItem.quantity).toStringAsFixed(2)}',
            ),
            trailing: Text('${cartItem.quantity}x'),
            leading: CircleAvatar(
              child: Padding(
                padding: EdgeInsets.all(5),
                child: FittedBox(
                  child: Text('${cartItem.price}'),
                ),
              ),
            ),
            // leading: ,
          ),
        ),
        // child: ,
      ),
    );
  }
}
