import 'package:dio/dio.dart' as Dio;
import 'package:flutter/material.dart';
import 'package:imusic_mobile/models/user.dart';
import 'package:imusic_mobile/services/dio.dart';
import 'package:imusic_mobile/utils/user_secure_storage.dart';

class Auth extends ChangeNotifier {
  bool _isLoggedIn = false;
  late User? _user;
  late String? _token;

  bool get authenticated => _isLoggedIn;
  User? get user => _user;
  String? get token => _token;

  // final storage = new FlutterSecureStorage();

  Future<int?> register({required Map creds}) async {
    print(creds);
    try {
      Dio.Response response = await dio().post('/auth/register', data: creds,
      options: Dio.Options(
        headers: {"Accept" : "application/json"},
        validateStatus: (status) { return status! < 500; },
      ));
      return response.statusCode;
    } catch (e) {
      print(e);
      // print(response.data.toString());
      // print(response.statusMessage);
      // print(response.statusCode);
      // // print(response.data['token'].toString());
      // if (response.statusCode != 200){
      //   print('-----');
      //   print(response.statusMessage);
      //   print('====');
      //   // throw Exception(response.statusMessage);
      // }


    }
  }

  Future<int?> login({required Map creds}) async {
    print(creds);
    try {
      Dio.Response response = await dio().post('/auth/login', data: creds);
      print(response.data.toString());

      String token = response.data.toString();
      this.tryToken(token: token);
      return response.statusCode;
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
        await UserSecureStorage.storeToken(token);
        notifyListeners();
        print(_user);
      } catch (e) {
        cleanUp();
        print(e);
      }
    }
  }


  void logout() async{
    try {
      Dio.Response response = await dio().get('/auth/logout' ,
        options: Dio.Options(headers: {'Authorization' : 'Bearer $_token'}));

      cleanUp();
      print(response);
      notifyListeners();
    } catch (e) {
      print(e);
    }

  }

  void cleanUp() async {
    this._user = null;
    this._isLoggedIn = false;
    this._token = null;
    await UserSecureStorage.deleteToken();
  }
}
