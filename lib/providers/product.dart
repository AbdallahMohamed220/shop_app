import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final double price;
  final String description;
  final String imgUrl;
  bool isfavoirte;

  Product(
      {@required this.id,
      @required this.title,
      @required this.price,
      @required this.description,
      @required this.imgUrl,
      this.isfavoirte = false});

  Future<void> toggleFavoriteStauts(String authToken, String userId) async {
    final url =
        'https://myshopapp-898ad.firebaseio.com/userProductFavorite/$userId/$id.json?auth=$authToken';
    final oldstauts = isfavoirte;
    isfavoirte = !isfavoirte;
    notifyListeners();
    try {
      final response = await http.put(url, body: json.encode(isfavoirte));
      if (response.statusCode >= 400) {
        isfavoirte = oldstauts;
        notifyListeners();
      }
    } catch (error) {
      isfavoirte = oldstauts;
      notifyListeners();
    }
  }
}
