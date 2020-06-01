import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_app/model/http_exception.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryData;
  String _userId;
  String useremail;
  String userpassword;

  bool get isAuth {
    return token != null;
  }

  String get userId {
    return _userId;
  }

  String get token {
    if (_expiryData != null &&
        _expiryData.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> _athunticateUser(
      String email, String password, String segmetUel) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/$segmetUel?key= AIzaSyBssF2pqNkjuPaycJpuwLf3NZQo24Jf6Lg';

    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));

      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      useremail = email;
      userpassword = password;
      _token = responseData['idToken'];
      _userId = responseData['localId'];

      _expiryData = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _athunticateUser(email, password, 'accounts:signUp');
  }

  Future<void> signIn(String email, String password) async {
    return _athunticateUser(email, password, 'accounts:signInWithPassword');
  }

  void logout() {
    _token = null;
    _userId = null;
    _expiryData = null;
    notifyListeners();
  }
}
