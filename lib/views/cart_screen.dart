import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/providers/orders.dart';
import 'package:shop/widgets/cart_item_widget.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Cart cartProvider = Provider.of<Cart>(context, listen: false);
    List<CartItem> cartItemsList = cartProvider.items.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Carrinho'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(25),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(width: 10),
                  Consumer<Cart>(
                    builder: (ctx, cart, child) => Chip(
                      label: Text(
                        'R\$ ${cartProvider.totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Theme.of(context)
                              .primaryTextTheme
                              .headline6
                              .color,
                        ),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  ),
                  // ocupa resto do espaço
                  Spacer(),
                  FlatButton(
                    child: Text('COMPRAR'),
                    textColor: Theme.of(context).primaryColor,
                    onPressed: () {
                      Orders ordersProvider =
                          Provider.of<Orders>(context, listen: false);
                      ordersProvider.addOrder(cartItemsList);
                      cartProvider.clear();
                    },
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Consumer<Cart>(builder: (ctx, cart, child) {
            final itemCount = cart.items.values.toList().length;
            final cartItems = cart.items.values.toList();

            return Expanded(
              child: ListView.builder(
                itemCount: itemCount,
                itemBuilder: (ctx, index) => CartItemWidget(cartItems[index]),
              ),
            );
          })
        ],
      ),
    );
  }
}
