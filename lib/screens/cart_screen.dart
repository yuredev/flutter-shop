import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/providers/orders.dart';
import 'package:shop/widgets/cart_item_widget.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carrinho'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(25),
            child: Padding(
              padding: const EdgeInsets.all(10),
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
                    // o Chip cria um widget de pílula
                    builder: (ctx, cart, child) => Chip(
                      label: Text(
                        'R\$ ${cart.totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Theme.of(context)
                              .primaryTextTheme
                              .headline6!
                              .color,
                        ),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  ),
                  // ocupa resto do espaço
                  Spacer(),
                  Consumer<Cart>(
                    builder: (ctx, cart, child) {
                      List<CartItem> cartItemsList = cart.items.values.toList();
                      return OrderButton(cart);
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

class OrderButton extends StatefulWidget {
  OrderButton(this.cart);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  
  @override
  Widget build(BuildContext context) {
    final _messengerOfContext = ScaffoldMessenger.of(context);

    return  TextButton(
      child: _isLoading ? CircularProgressIndicator() : Text('COMPRAR'),
      style: TextButton.styleFrom(
        textStyle: TextStyle(
          color: Theme.of(context).primaryColor,
        ),
      ),
      onPressed: widget.cart.items.values.isEmpty ? null : () async {
        Orders ordersProvider = Provider.of<Orders>(context, listen: false);
        setState(() => _isLoading = true);
        try {
          await ordersProvider.addOrder(widget.cart.items.values.toList());
          widget.cart.clear();
        } catch (e) {
          _messengerOfContext.showSnackBar(
            SnackBar(content: Text('Não foi possível cadastrar o pedido')),
          );
        }
        setState(() => _isLoading = false);
        ordersProvider.thereAreNewOrders = true;
      },
    );
  }
}
