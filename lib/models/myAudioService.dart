import 'package:dio/dio.dart' as Dio;
import 'package:imusic_mobile/services/dio.dart';
import 'package:imusic_mobile/utils/user_secure_storage.dart';

class MyAudioService {

  // final storage = new FlutterSecureStorage();



  static Future<void> listenToItem(int serverId) async {
      try {
        String? token = await UserSecureStorage.getToken();
        Dio.Response response = await dio().put('/me/listen/',
            data: {'serverId' : serverId},
            options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
        print(response);

      } catch (e, stacktrace) {
        print('caught $e : $stacktrace');
      }
  }
}