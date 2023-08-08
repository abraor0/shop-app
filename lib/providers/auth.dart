import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// ignore: constant_identifier_names
const API_KEY = 'AIzaSyB2LhigOTMvdHUdOoyFSsUoQ5-f7UGC5BU';

class Auth with ChangeNotifier {
  String _token = '';
  DateTime _expiryDate = DateTime.now();
  String _userId = '';
  Timer? _authTimer;

  bool get isLogged {
    return token != null;
  }

  String? get token {
    if (_token.isNotEmpty && _expiryDate.isAfter(DateTime.now())) {
      return _token;
    }

    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> signup(String email, String password) async {
    final uri = Uri.https('identitytoolkit.googleapis.com',
        '/v1/accounts:signUp', {'key': API_KEY});
    try {
      final resp = await http.post(uri,
          body: json.encode({
            'email': email,
            'password': password,
            'retunSecureToken': true
          }));
      final respBody = json.decode(resp.body);
      if (resp.statusCode >= 400) {
        throw HttpException(respBody['error']['message']);
      } else {
        _token = respBody['idToken'];
        _expiryDate = DateTime.now()
            .add(Duration(seconds: int.parse(respBody['expiresIn'])));
        _userId = respBody['localId'];
        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signin(String email, String password) async {
    final uri = Uri.https('identitytoolkit.googleapis.com',
        '/v1/accounts:signInWithPassword', {'key': API_KEY});
    try {
      final resp = await http.post(uri,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));
      final respBody = json.decode(resp.body);
      if (resp.statusCode >= 400) {
        throw HttpException(respBody['error']['message']);
      } else {
        _token = respBody['idToken'];
        _expiryDate = DateTime.now()
            .add(Duration(seconds: int.parse(respBody['expiresIn'])));
        _userId = respBody['localId'];
        _autoLogout();
        notifyListeners();
        final prefs = await SharedPreferences.getInstance();
        final userData = json.encode({
          'token': _token,
          'userId': _userId,
          'expiryDate': _expiryDate.toIso8601String(),
        });
        prefs.setString('userData', userData);
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> tryAutoLogin() async {
    print('chegou no autolgin');
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final userData =
        json.decode(prefs.getString('userData')!) as Map<String, String>;
    final expiryDate = DateTime.parse(userData['expiryDate']!);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = userData['token']!;
    _userId = userData['userId']!;
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();

    return true;
  }

  Future<void> logout() async {
    _token = '';
    _userId = '';
    _expiryDate = DateTime.now();
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    notifyListeners();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final duration = _expiryDate.difference(DateTime.now());
    Timer(duration, () => logout());
  }
}
