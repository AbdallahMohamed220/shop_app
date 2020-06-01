import 'package:flutter/material.dart';
import '../providers/product.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routName = 'edit_product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageController = TextEditingController();

  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  var _editProduct =
      Product(id: null, title: '', description: '', imgUrl: '', price: 0);
  var _isInt = true;
//  var _intiValues = {'title': '', 'description': '', 'price': '', 'imgUrl': ''};

  var _isloading = false;
  @override
  void initState() {
    _imageFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void dispose() {
    _imageFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageFocusNode.hasFocus) {
      if (!_imageFocusNode.hasFocus) {
        if (_imageController.text.isEmpty ||
            _imageController.text.length < 6 ||
            !_imageController.text.startsWith('http') &&
                !_imageController.text.startsWith('https') ||
            (!_imageController.text.endsWith('.png') &&
                !_imageController.text.endsWith('.jpg') &&
                !_imageController.text.endsWith('jpeg'))) return;
      }
      setState(() {});
    }
  }

  @override
  void didChangeDependencies() {
    if (_isInt) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editProduct = Provider.of<Products>(context).findById(productId);
        // _intiValues = {
        //   'title': _editProduct.title,
        //   'description': _editProduct.description,
        //   'price': _editProduct.price.toString(),
        //   'imgUrl': ''
        // };
        _titleController.text = _editProduct.title;
        _descriptionController.text = _editProduct.description;
        _priceController.text = _editProduct.price.toString();
        _imageController.text = _editProduct.imgUrl;
      }
    }
    super.didChangeDependencies();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();

    setState(() {
      _isloading = true;
    });
    try {
      if (_editProduct.id != null) {
        await Provider.of<Products>(context, listen: false)
            .updateProduct(_editProduct.id, _editProduct);
      } else {
        await Provider.of<Products>(context).addProduct(_editProduct);
      }
    } catch (error) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('An error occurred!'),
          content: Text('Something went wrong.'),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      );
    } finally {
      setState(() {
        _isloading = false;
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        actions: <Widget>[
          IconButton(
            color: Theme.of(context).cardColor,
            icon: Icon(Icons.save),
            onPressed: () {
              _submitForm();
            },
          )
        ],
        centerTitle: true,
        title: Text(
          _editProduct.id == null ? 'Add Product' : 'Edit Product',
          style: TextStyle(
              color: Theme.of(context).cardColor,
              fontSize: 24,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: _isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                    Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0, 1],
                ),
              ),
              child: Form(
                  key: _formKey,
                  child: ListView(
                    children: <Widget>[
                      TextFormField(
                        // initialValue: _intiValues['title'],
                        controller: _titleController,
                        validator: (value) {
                          if (value.isEmpty || value.length < 6) {
                            return 'Enter valid Value';
                          }
                          if (value.isEmpty || value.length > 17) {
                            return 'Name is too Long try shorter one';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editProduct = Product(
                              id: _editProduct.id,
                              isfavoirte: _editProduct.isfavoirte,
                              title: value,
                              description: _editProduct.description,
                              imgUrl: _editProduct.imgUrl,
                              price: _editProduct.price);
                        },
                        decoration: InputDecoration(labelText: 'Title'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                      ),
                      TextFormField(
                        controller: _priceController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter valid Value';
                          }
                          if (double.tryParse(value) <= 0) {
                            return 'Enter valid Value';
                          }
                          if (double.parse(value) == null) {
                            return 'Enter valid Value';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editProduct = Product(
                              id: _editProduct.id,
                              isfavoirte: _editProduct.isfavoirte,
                              title: _editProduct.title,
                              description: _editProduct.description,
                              imgUrl: _editProduct.imgUrl,
                              price: double.parse(value));
                        },
                        decoration: InputDecoration(labelText: 'Price'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                      ),
                      TextFormField(
                        controller: _descriptionController,
                        validator: (value) {
                          if (value.isEmpty || value.length < 6) {
                            return 'Enter valid Value';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editProduct = Product(
                              id: _editProduct.id,
                              isfavoirte: _editProduct.isfavoirte,
                              title: _editProduct.title,
                              description: value,
                              imgUrl: _editProduct.imgUrl,
                              price: _editProduct.price);
                        },
                        maxLines: 4,
                        minLines: 2,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: 'Description',
                        ),
                        focusNode: _descriptionFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_imageFocusNode);
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(5),
                              margin: EdgeInsets.only(top: 8, right: 8),
                              alignment: Alignment.center,
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1, color: Colors.black)),
                              child: _imageController.text.isEmpty
                                  ? Text('Image Url')
                                  : FittedBox(
                                      child: Image.network(
                                        _imageController.text,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                            Expanded(
                              child: TextFormField(
                                validator: (value) {
                                  if (value.isEmpty || value.length < 6) {
                                    return 'Enter valid Value';
                                  }
                                  if (!value.startsWith('http') &&
                                      value.startsWith('https')) {
                                    return 'Enter valid Value';
                                  }
                                  if (!value.endsWith('.png') &&
                                      !value.endsWith('.jpg') &&
                                      !value.endsWith('jpeg')) {
                                    return 'Enter valid Value';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _editProduct = Product(
                                      id: _editProduct.id,
                                      isfavoirte: _editProduct.isfavoirte,
                                      title: _editProduct.title,
                                      description: _editProduct.description,
                                      imgUrl: value,
                                      price: _editProduct.price);
                                },
                                controller: _imageController,
                                keyboardType: TextInputType.url,
                                focusNode: _imageFocusNode,
                                textInputAction: TextInputAction.done,
                                decoration: InputDecoration(
                                  labelText: 'Image Url',
                                ),
                              ),
                            ),
                          ]),
                    ],
                  )),
            ),
    );
  }
}
