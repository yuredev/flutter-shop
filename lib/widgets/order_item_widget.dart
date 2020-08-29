import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop/providers/orders.dart';

class OrderItemWidget extends StatefulWidget {
  final Order order;

  OrderItemWidget(this.order);

  @override
  _OrderItemWidgetState createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  bool _showDetails = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('R\$ ${widget.order.total.toStringAsFixed(2)}'),
            subtitle: Text(
              DateFormat('dd/MM/yyyy hh:mm').format(widget.order.date),
            ),
            trailing: IconButton(
              icon: Icon(_showDetails ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _showDetails = !_showDetails;
                });
              },
            ),
          ),
          if (_showDetails)
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 6,
              ),
              // height: widget.order.products.length * 25.0 + 10,
              child: Column(
                children: widget.order.products.map((prod) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        prod.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${prod.quantity}x R\$${prod.price}',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
