import 'package:flutter/material.dart';
import 'package:shop/providers/product.dart';

class ProductDetailsScreen extends StatelessWidget {
 @override
  Widget build(BuildContext context) {
    final Product product = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      // body: Column(
      //   children: [
      //     Text(CounterProvider.of(context).state.value.toString()),
      //     RaisedButton(
      //       child: Text('+'),
      //       onPressed: () {
      //         setState(() {
      //           // sem o método of há como acessar os dados do provider 
      //           // context.dependOnInheritedWidgetOfExactType<CounterProvider>().state.inc();
      //           // no entanto, é bem mais fácil usar quando se tem o método: of() 
      //           CounterProvider.of(context).state.inc();
      //         });
      //       },
      //     ),
      //   ],
      // ),
    );
  }
}
