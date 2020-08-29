import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/orders.dart';
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/order_item_widget.dart';

class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Orders ordersProvider = Provider.of<Orders>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Pedidos'),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemCount: ordersProvider.itemsCount,
        itemBuilder: (ctx, i) => OrderItemWidget(
          ordersProvider.items[i],
        ),
      ),
    );
  }
}
