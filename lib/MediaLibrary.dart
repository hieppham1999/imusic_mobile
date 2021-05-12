import 'package:dio/dio.dart' as Dio;
import 'package:imusic_mobile/services/dio.dart';
import 'package:imusic_mobile/utils/user_secure_storage.dart';
import 'package:audio_service/audio_service.dart';

import 'utils/MediaItemExtensions.dart';

class MediaLibrary {


  Future<List<MediaItem>> fetchItem(String url) async {

      try {
        Dio.Response response = await dio().get(url);
        return (response.data as List)
            .map((x) => mediaItemFromApiJson(x))
            .toList();
      } catch (e, stacktrace) {
        print('caught $e : $stacktrace');
      }
      return [];
  }
  Future<List<MediaItem>> fetchUserSongData(String url) async {

    try {
      String? token = await UserSecureStorage.getToken();
      Dio.Response response = await dio().get(url, options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
      return (response.data as List)
          .map((x) => mediaItemFromApiJson(x))
          .toList();
    } catch (e, stacktrace) {
      print('caught $e : $stacktrace');
    }
    return [];
  }






}