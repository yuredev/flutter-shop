import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/product.dart';
import 'package:shop/providers/products.dart';

class ProductFormScreen extends StatefulWidget {
  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  final _formData = Map<String, Object>();

  @override
  void initState() {
    super.initState();
    _imageUrlFocusNode.addListener(_updateImage);
  }

  bool _imageUrlIsValid(String url) {
    bool startWithHttp = url.toLowerCase().startsWith('http://');
    bool startWithHttps = url.toLowerCase().startsWith('https://');
    bool protocolIsValid = startWithHttp || startWithHttps;

    bool endsWithPng = url.toLowerCase().endsWith('.png');
    bool endsWithJpg = url.toLowerCase().endsWith('.jpg');
    bool endsWithJpeg = url.toLowerCase().endsWith('.jpeg');
    bool imageExtensionIsValid = endsWithPng || endsWithJpg || endsWithJpeg;

    return protocolIsValid && imageExtensionIsValid;
  }

  void _updateImage() {
    if (_imageUrlIsValid(_imageUrlController.text)) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
    // limpar memória ao sair
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.removeListener(_updateImage);
    _imageUrlFocusNode.dispose();
  }

  void _saveForm() {
    // se todos os validators do form estiverem ok
    if (_form.currentState.validate()) {
      // chama o onSave de cada método
      _form.currentState.save();
      Product newProduct = Product(
        title: _formData['title'],
        description: _formData['description'],
        price: _formData['price'],
        imageUrl: _formData['image-url'],
        id: Random().nextDouble().toString(),
      );
      Provider.of<Products>(context, listen: false).addProduct(newProduct);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulário Produto'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              _saveForm();
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Título',
                ),
                // trocar o botão de done pelo de next no teclado
                // para não submeter o formulário inteiro
                textInputAction: TextInputAction.next,
                // quando o next for pressionado, colocar o foco no próximo input
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                onSaved: (value) => _formData['title'] = value,
                // qualquer coisa que o validator retorne que
                // seja diferente de null
                // será interpretada como erro na validação
                // fazendo com que o currentState.validate()
                // retorne falso

                // os retornos dos validators são justamente o
                // texto da mensagem de erro que aparecerá no campo
                validator: (title) {
                  // trim(): tira espaços em branco
                  if (title.trim().isEmpty) {
                    return 'O campo de título não pode estar vazio';
                  } else if (title.trim().length < 3) {
                    return 'O Título deve conter no mínimo 3 caracteres';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Preço',
                  // errorBorder: InputBorder(
                  //   borderSide: BorderSide.
                  // )
                ),
                focusNode: _priceFocusNode,
                keyboardType: TextInputType.numberWithOptions(
                  decimal: true,
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                onSaved: (value) => _formData['price'] = double.parse(value),
                validator: (price) {
                  if (price.trim().isEmpty) {
                    return 'O campo de preço não pode estar vazio';
                  } else if (double.tryParse(price.trim()) <= 0) {
                    return 'O produto não pode ser gratuito';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Descrição',
                ),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
                onSaved: (value) => _formData['description'] = value,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // o TextFormField precisa estar em um widget
                  // com o tamanho definido, desta forma
                  // é preciso usar esse Expanded
                  // caso contrário, ele não é exibido
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'URL da Imagem',
                      ),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      focusNode: _imageUrlFocusNode,
                      controller: _imageUrlController,
                      onFieldSubmitted: (_) => _saveForm(),
                      onSaved: (value) => _formData['image-url'] = value,
                      validator: (url) {
                        bool isNotEmpty = url.trim().isNotEmpty;
                        bool isValid = _imageUrlIsValid(url);

                        if (isNotEmpty && isValid) {
                          return null;
                        }
                        return 'Informe uma URL valida';
                      },
                    ),
                  ),
                  Container(
                    height: 100,
                    width: 100,
                    margin: EdgeInsets.only(
                      top: 8,
                      left: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: _imageUrlController.text.isEmpty
                        ? Text('Informe a URL')
                        : FittedBox(
                            child: Image.network(_imageUrlController.text),
                            fit: BoxFit.cover,
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
