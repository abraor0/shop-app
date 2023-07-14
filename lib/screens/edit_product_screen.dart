import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({super.key});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageFocusNode = FocusNode();
  final _imageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _newProduct = {
    'id': null,
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
    'isFavorite': false
  };
  bool _didInit = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    _imageFocusNode.addListener(_updateImageURL);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!_didInit) {
      final productId = ModalRoute.of(context)!.settings.arguments as String?;
      if (productId != null) {
        final product =
            Provider.of<Products>(context).getProductById(productId);
        _newProduct['title'] = product.title;
        _newProduct['id'] = product.id;
        _newProduct['description'] = product.description;
        _newProduct['price'] = product.price.toString();
        _newProduct['imageUrl'] = product.imageUrl;
        _newProduct['isFavorite'] = product.isFavorite;

        _imageController.text = product.imageUrl;
      }

      _didInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageFocusNode.removeListener(_updateImageURL);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageController.dispose();
    _imageFocusNode.dispose();
    super.dispose();
  }

  void _updateImageURL() {
    if (!_imageFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;

    _formKey.currentState!.save();
    if (_newProduct['id'] == null) {
      setState(() {
        _isSubmitting = true;
      });
      try {
        await Provider.of<Products>(context, listen: false).addProduct(
          _newProduct['title'],
          _newProduct['description'],
          double.parse(_newProduct['price']),
          _newProduct['imageUrl'],
        );
      } catch (error) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('An error ocurred'),
            content: const Text('Something went wrong adding the product.'),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Ok'),
              )
            ],
          ),
        );
      }
    } else {
      await Provider.of<Products>(context, listen: false).updateProduct(Product(
        id: _newProduct['id'],
        title: _newProduct['title'],
        description: _newProduct['description'],
        imageUrl: _newProduct['imageUrl'],
        price: double.parse(_newProduct['price']),
        isFavorite: _newProduct['isFavorite'],
      ));
    }
    setState(() {
      _isSubmitting = false;
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit product'),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Column(
        children: [
          if (_isSubmitting)
            LinearProgressIndicator(
              backgroundColor: Theme.of(context).colorScheme.primary,
              color: Theme.of(context).colorScheme.secondary,
              semanticsLabel: 'Adding product to server',
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(children: [
                    TextFormField(
                      enabled: !_isSubmitting,
                      initialValue: _newProduct['title'],
                      decoration: const InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        if (value != null) {
                          if (value.isEmpty) return 'Please enter a title';

                          return null;
                        }
                      },
                      onSaved: (newValue) => _newProduct['title'] = newValue,
                    ),
                    TextFormField(
                      enabled: !_isSubmitting,
                      initialValue: _newProduct['price'],
                      decoration: const InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      validator: (value) {
                        if (value != null) {
                          if (value.isEmpty) return 'Please enter a price';
                          try {
                            double number = double.parse(value);
                            if (number <= 0)
                              return 'Please enter a valid price';
                          } catch (err) {
                            return 'Please enter a valid number';
                          }

                          return null;
                        }
                      },
                      onFieldSubmitted: (value) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      onSaved: (newValue) => _newProduct['price'] = newValue,
                    ),
                    TextFormField(
                      enabled: !_isSubmitting,
                      initialValue: _newProduct['description'],
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      onSaved: (newValue) =>
                          _newProduct['description'] = newValue,
                      validator: (value) {
                        if (value != null) {
                          if (value.isEmpty)
                            return 'Please enter a description';

                          return null;
                        }
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          margin: const EdgeInsets.only(
                            top: 10,
                            right: 12,
                          ),
                          child: _imageController.text.isEmpty
                              ? const Text('Enter a URL')
                              : Image.network(
                                  _imageController.text,
                                  fit: BoxFit.cover,
                                  key: ValueKey(DateTime.now().toString()),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            enabled: !_isSubmitting,
                            decoration:
                                const InputDecoration(labelText: 'Image URL'),
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.url,
                            controller: _imageController,
                            focusNode: _imageFocusNode,
                            onSaved: (newValue) =>
                                _newProduct['imageUrl'] = newValue,
                            onFieldSubmitted: (_) => _saveForm(),
                            validator: (value) {
                              if (value != null) {
                                if (value.isEmpty) {
                                  return 'Please enter an image URL';
                                }
                                if (!value.startsWith('http') &&
                                    !value.startsWith('https')) {
                                  return 'Please enter a valid URL';
                                }
                                if (!value.endsWith('.jpg') &&
                                    !value.endsWith('.jpeg') &&
                                    !value.endsWith('.png')) {
                                  return 'Please enter a valid image URL';
                                }

                                return null;
                              }
                            },
                          ),
                        ),
                      ],
                    )
                  ]),
                )),
          ),
        ],
      ),
    );
  }
}
