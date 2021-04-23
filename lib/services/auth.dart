import 'package:dio/dio.dart' as Dio;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:imusic_mobile/models/user.dart';
import 'package:imusic_mobile/services/dio.dart';

class Auth extends ChangeNotifier {
  bool _isLoggedIn = false;
  late User? _user;
  late String? _token;

  bool get authenticated => _isLoggedIn;
  User? get user => _user;

  final storage = new FlutterSecureStorage();

  void login({required Map creds}) async {
    print(creds);
    try {
      Dio.Response response = await dio().post('/auth/login', data: creds);
      print(response.data.toString());

      String token = response.data.toString();
      this.tryToken(token: token);
    } catch (e) {
      print(e);
    }
  }

  void tryToken({String? token}) async {
    if (token == null) {
      return;
    } else {
      try {
        Dio.Response response = await dio().get('/me',
            options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
        this._isLoggedIn = true;
        this._user = User.fromJson(response.data);
        this._token = token;
        this.storeToken(token: token);
        notifyListeners();
        print(_user);
      } catch (e) {
        cleanUp();
        print(e);
      }
    }
  }

  void storeToken({String? token}) async {
    this.storage.write(key: 'token', value: token);
  }

  void logout() async{
    try {
      Dio.Response response = await dio().get('/auth/logout' ,
        options: Dio.Options(headers: {'Authorization' : 'Bearer $_token'}));

      cleanUp();
      notifyListeners();
    } catch (e) {
      print(e);
    }

  }

  void cleanUp() async {
    this._user = null;
    this._isLoggedIn = false;
    this._token = null;
    await storage.delete(key: 'token');
  }
}
