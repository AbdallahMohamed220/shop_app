import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:food_app/model/http_exception.dart';
import 'package:http/http.dart' as http;
import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;
  final String username;
  final String creatorid;
  final String password;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
    @required this.username,
    @required this.password,
    @required this.creatorid,
  });
}

class Orders with ChangeNotifier {
  final String authToken;
  final String userId;
  Orders(this.authToken, this.userId, this._orders);
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetData([bool filteringByUser = false]) async {
    String filtering =
        filteringByUser ? '&orderBy="creatorId"&equalTo="$userId"' : '';

    final url =
        'https://myshopapp-898ad.firebaseio.com/orders.json?auth=$authToken$filtering';
    try {
      final response = await http.get(url);
      final extractData = json.decode(response.body) as Map<String, dynamic>;
      final List<OrderItem> loadData = [];
      if (extractData == null) {
        return;
      }
      extractData.forEach((prodId, orderData) {
        loadData.add(OrderItem(
            username: orderData['email'],
            password: orderData['password'],
            creatorid: orderData['creatorId'],
            id: prodId,
            amount: orderData['amount'],
            dateTime: DateTime.parse(orderData['dateTime']),
            products: (orderData['products'] as List<dynamic>)
                .map((item) => CartItem(
                    id: item['id'],
                    price: item['price'],
                    quantity: item['quantity'],
                    title: item['title'],
                    imgUrl: item['imgUrl']))
                .toList()));
      });

      _orders = loadData.reversed.toList();

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total, String email,
      String password) async {
    final url =
        'https://myshopapp-898ad.firebaseio.com/orders.json?auth=$authToken';
    final timestamp = DateTime.now();

    final response = await http.post(url,
        body: json.encode({
          'email': email,
          'password': password,
          'creatorId': userId,
          'amount': total,
          'dateTime': timestamp.toIso8601String(),
          'products': cartProducts
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'quantity': cp.quantity,
                    'price': cp.price
                  })
              .toList()
        }));
    _orders.insert(
      0,
      OrderItem(
        password: password,
        creatorid: userId,
        username: email,
        id: json.decode(response.body)['name'],
        amount: total,
        dateTime: DateTime.now(),
        products: cartProducts,
      ),
    );
    if (response.statusCode >= 400) {
      _orders.removeAt(0);
      notifyListeners();
      throw HttpException('Order Faild');
    }
  }

  Future<void> removeOrder(String id) async {
    final url =
        'https://myshopapp-898ad.firebaseio.com/orders/$id.json?auth=$authToken';

    final existingProductIndex = _orders.indexWhere((prod) => prod.id == id);
    var existingProduct = _orders[existingProductIndex];
    _orders.removeAt(existingProductIndex);
    notifyListeners();

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _orders.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could Not delete Product');
    }
    existingProduct = null;
  }
}
