import 'package:dio/dio.dart' as Dio;
import 'package:imusic_mobile/services/dio.dart';
import 'package:imusic_mobile/utils/user_secure_storage.dart';

class MyAudioService {


  static Future<void> listenToItem(int serverId) async {
      try {
        String? token = await UserSecureStorage.getToken();
        if(token != null) {
          Dio.Response response = await dio().put('/me/listen/',
              data: {'serverId': serverId},
              options: Dio.Options(
                  headers: {'Authorization': 'Bearer $token'}));
          print(response);
        } else {
          Dio.Response response = await dio().put('/guest/listen/',
              data: {'serverId': serverId},);
          print(response);
        }
      } catch (e, stacktrace) {
        print('caught $e : $stacktrace');
      }
  }

  static Future<void> listenFor15Sec(int serverId) async {
    try {
      String? token = await UserSecureStorage.getToken();
      Dio.Response response = await dio().put('/me/plus-rcm-point',
          data: {'serverId' : serverId},
          options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
      print(response);
    } catch (e, stacktrace) {
      print('caught $e : $stacktrace');
    }
  }
}