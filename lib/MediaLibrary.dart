import 'dart:convert';

import 'package:audio_service/audio_service.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:imusic_mobile/models/myMediaItem.dart';
import 'package:imusic_mobile/services/dio.dart';

class MediaLibrary {


  Future<List<MyMediaItem>> fetchItem(String url) async {

      try {
        Dio.Response response = await dio().get(url);
        return (response.data as List)
            .map((x) => MyMediaItem.fromJson(x))
            .toList();
      } catch (e, stacktrace) {
        print('caught $e : $stacktrace');
      }
      return [];
  }





}