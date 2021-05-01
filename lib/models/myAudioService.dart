import 'package:audio_service/audio_service.dart';
import 'package:imusic_mobile/services/auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:imusic_mobile/services/dio.dart';
import 'package:provider/provider.dart';

class MyAudioService {

  final storage = new FlutterSecureStorage();



  static Future<void> skipToQueueItemWithServerId(String mediaId, int serverId) async {
    await AudioService.skipToQueueItem(mediaId);
    isLogged = Provider.of<Auth>(context, listen: false).authenticated;
    if(Auth().authenticated) {
      try {
        String? token = Auth().token;
        Dio.Response response = await dio().get('/songs/listen/$serverId',
            options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
        print(response);

      } catch (e, stacktrace) {
        print('caught $e : $stacktrace');
      }
    }

  }
}