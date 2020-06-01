import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_app/model/http_exception.dart';
import '../providers/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _item = [
    // Product(
    //   id: '1',
    //   title: 'Seafoods',
    //   price: 50,
    //   imgUrl:
    //       'https://i.pinimg.com/originals/5f/12/36/5f1236f3d67311c472965c6022512431.png',
    //   description:
    //       'This light home-cooked food is low salt and low oil with balanced nutrition, selected from high-quality ingredients. This delicious food maybe your best healthy choice.',
    // ),
    // Product(
    //   id: '2',
    //   title: 'Asian Food',
    //   price: 55,
    //   imgUrl:
    //       'https://d37rttg87jr6ah.cloudfront.net/static/product_photo_web/spaghetti_turkey_bolognese-2018-12-09-23-00-17_768x768.png',
    //   description:
    //       'This light home-cooked food is low salt and low oil with balanced nutrition, selected from high-quality ingredients. This delicious food maybe your best healthy choice.',
    // ),
    // Product(
    //   id: '3',
    //   title: 'Assorted',
    //   price: 60,
    //   imgUrl:
    //       'https://d37rttg87jr6ah.cloudfront.net/static/product_photo_web/naked_salmon-2018-12-09-23-57-16_768x768.png',
    //   description:
    //       'This light home-cooked food is low salt and low oil with balanced nutrition, selected from high-quality ingredients. This delicious food maybe your best healthy choice.',
    // ),
    // Product(
    //   id: '5',
    //   title: 'Romesco Chicken',
    //   price: 65,
    //   imgUrl:
    //       'https://d37rttg87jr6ah.cloudfront.net/static/product_photo_web/romesco_chicken-2018-12-10-00-17-38_1242x1242.png',
    //   description:
    //       'This light home-cooked food is low salt and low oil with balanced nutrition, selected from high-quality ingredients. This delicious food maybe your best healthy choice.',
    // ),
    // Product(
    //   id: '4',
    //   title: 'Chickenp Piccata',
    //   price: 70,
    //   imgUrl:
    //       'https://images.pexels.com/photos/1234535/pexels-photo-1234535.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
    //   description:
    //       'This light home-cooked food is low salt and low oil with balanced nutrition, selected from high-quality ingredients. This delicious food maybe your best healthy choice.',
    // ),
  ];

  List<Product> get item {
    return [..._item];
  }

  final String authToken;
  final String userId;

  Products(this.authToken, this.userId, this._item);

  List<Product> get favoriteItems {
    return _item.where((prodId) => prodId.isfavoirte).toList();
  }

  Product findById(String id) {
    return _item.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetData([bool filteringByUser = false]) async {
    String filtering =
        filteringByUser ? '&orderBy="creatorId"&equalTo="$userId"' : '';
    var url =
        'https://myshopapp-898ad.firebaseio.com/products.json?auth=$authToken$filtering';

    try {
      final response = await http.get(url);
      final extractData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadData = [];
      if (extractData == null) {
        return;
      }
      url =
          'https://myshopapp-898ad.firebaseio.com/userProductFavorite/$userId.json?auth=$authToken';
      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);
      extractData.forEach((prodId, prodData) {
        loadData.add(Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            imgUrl: prodData['imgUrl'],
            isfavoirte:
                favoriteData == null ? false : favoriteData[prodId] ?? false));
      });

      _item = loadData.reversed.toList();

      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://myshopapp-898ad.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'price': product.price,
            'description': product.description,
            'imgUrl': product.imgUrl,
            'creatorId': userId
          }));

      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          price: product.price,
          description: product.description,
          imgUrl: product.imgUrl);

      _item.insert(0, newProduct);

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product product) async {
    final prodIndex = _item.indexWhere((prod) => prod.id == id);

    final url =
        'https://myshopapp-898ad.firebaseio.com/products/$id.json?auth=$authToken';
    if (prodIndex >= 0) {
      try {
        await http.patch(url,
            body: json.encode({
              'title': product.title,
              'price': product.price,
              'description': product.description,
              'imgUrl': product.imgUrl,
            }));
        _item[prodIndex] = product;
        notifyListeners();
      } catch (error) {
        throw error;
      }
    }
  }

  Future<void> removeProduct(String id) async {
    final url =
        'https://myshopapp-898ad.firebaseio.com/products/$id.json?auth=$authToken';

    final existingProductIndex = _item.indexWhere((prod) => prod.id == id);
    var existingProduct = _item[existingProductIndex];
    _item.removeAt(existingProductIndex);
    notifyListeners();

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _item.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could Not delete Product');
    }
    existingProduct = null;
  }
}
