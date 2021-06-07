import 'dart:convert';

import 'package:audio_service/audio_service.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:imusic_mobile/models/playlist.dart';
import 'package:imusic_mobile/services/dio.dart';
import 'package:imusic_mobile/utils/user_secure_storage.dart';
import 'package:imusic_mobile/utils/MediaItemExtensions.dart';

class MyAudioService {

  static Future<List<MediaItem>> getRecommendSongForUser() async {
    try {
      String? token = await UserSecureStorage.getToken();
      Dio.Response response = await dio().get('/me/recommend', options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
      return (response.data as List)
          .map((x) => mediaItemFromApiJson(x))
          .toList();
    } catch (e, stacktrace) {
      print('caught $e : $stacktrace');
    }
    return [];
  }

  static Future<List<MediaItem>> getHotSong({String? time}) async {
    try {
      Dio.Response response = await dio()
          .get('/songs/hot', queryParameters: {'t': time});
      return (response.data as List)
          .map((x) => mediaItemFromApiJson(x))
          .toList();
    } catch (e, stacktrace) {
      print('caught $e : $stacktrace');
    }
    return [];
  }

  static Future<List<MediaItem>> getNewSongs({int? limit}) async {
    try {
      Dio.Response response = await dio()
          .get('/songs/new', queryParameters: {'lim': limit});
      return (response.data as List)
          .map((x) => mediaItemFromApiJson(x))
          .toList();
    } catch (e, stacktrace) {
      print('caught $e : $stacktrace');
    }
    return [];
  }

  static Future<List<MediaItem>> getRecentlySong({int? limit}) async {
    try {
      Dio.Response response = await dio()
          .get('/songs/recently', queryParameters: {'lim': limit});
      return (response.data as List)
          .map((x) => mediaItemFromApiJson(x))
          .toList();
    } catch (e, stacktrace) {
      print('caught $e : $stacktrace');
    }
    return [];
  }

  static Future<List<MediaItem>> getSongByGenre({required int genreId, int? limit}) async {
    try {
      Dio.Response response = await dio()
          .get('/songs/genre/$genreId', queryParameters: {'lim': limit});
      return (response.data as List)
          .map((x) => mediaItemFromApiJson(x))
          .toList();
    } catch (e, stacktrace) {
      print('caught $e : $stacktrace');
    }
    return [];
  }

  static Future<List<MediaItem>> getSongByLanguage({required int languageId, int? limit}) async {
    try {
      Dio.Response response = await dio()
          .get('/songs/language/$languageId', queryParameters: {'lim': limit});
      return (response.data as List)
          .map((x) => mediaItemFromApiJson(x))
          .toList();
    } catch (e, stacktrace) {
      print('caught $e : $stacktrace');
    }
    return [];
  }

  static Future<void> listenToItem(int serverId) async {
    try {
      String? token = await UserSecureStorage.getToken();
      if (token != null) {
        Dio.Response response = await dio().put('/me/listen/',
            data: {'serverId': serverId},
            options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
        print(response);
      } else {
        Dio.Response response = await dio().put(
          '/guest/listen/',
          data: {'serverId': serverId},
        );
        print(response);
      }
    } catch (e, stacktrace) {
      print('caught $e : $stacktrace');
    }
  }

  static Future<void> listenFor20Sec(int serverId) async {
    try {
      String? token = await UserSecureStorage.getToken();
      Dio.Response response = await dio().put('/me/plus-rcm-point',
          data: {'serverId': serverId},
          options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
      print(response);
    } catch (e, stacktrace) {
      print('caught $e : $stacktrace');
    }
  }

  static Future<List<MediaItem>> searchByKeyword(String keyword) async {
    try {
      Dio.Response response = await dio()
          .get('/songs/search', queryParameters: {'keyword': keyword});
      return (response.data as List)
          .map((x) => mediaItemFromApiJson(x))
          .toList();
    } catch (e, stacktrace) {
      print('caught $e : $stacktrace');
    }
    return [];
  }

  static Future<List<Playlist>> getPlaylists() async {
    try {
      String? token = await UserSecureStorage.getToken();
      Dio.Response response = await dio().get('/playlists',
          options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
      return (response.data as List).map((x) => Playlist.fromJson(x)).toList();
    } catch (e, stacktrace) {
      print('caught $e : $stacktrace');
    }
    return [];
  }

  static Future<Playlist?> getPlaylistInfo(int playlistId) async {
    try {
      String? token = await UserSecureStorage.getToken();
      Dio.Response response = await dio().get(
          '/playlists/' + playlistId.toString() + '/info',
          options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
      return Playlist.fromJson(response.data);
    } catch (e, stacktrace) {
      print('caught $e : $stacktrace');
    }
    return null;
  }

  static Future<List<MediaItem>> getSongsFromPlaylist(int playlistId) async {
    try {
      String? token = await UserSecureStorage.getToken();
      Dio.Response response = await dio().get(
          '/playlists/' + playlistId.toString(),
          options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
      return (response.data as List)
          .map((x) => mediaItemFromApiJson(x))
          .toList();
    } catch (e, stacktrace) {
      print('caught $e : $stacktrace');
    }
    return [];
  }

  static Future<void> addSongToPlaylist(int playlistId, int serverId) async {
    try {
      String? token = await UserSecureStorage.getToken();
      Dio.Response response = await dio().post(
          '/playlists/' + playlistId.toString() + '/add',
          data: {'serverId': serverId},
          options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
    } catch (e, stacktrace) {
      print('caught $e : $stacktrace');
    }
  }

  static Future<int?> createPlaylist(String playListName) async {
    try {
      String? token = await UserSecureStorage.getToken();
      Dio.Response response = await dio().post('/playlists/create',
          data: {'playlistName': playListName},
          options: Dio.Options(
            headers: {'Authorization': 'Bearer $token'},
            validateStatus: (status) {
              return status! < 500;
            },
          ));
      return response.statusCode;
    } catch (e, stacktrace) {
      print('caught $e : $stacktrace');
    }
  }

  static Future<int?> editPlaylistName(
      String playListName, int playlistId) async {
    try {
      String? token = await UserSecureStorage.getToken();
      Dio.Response response =
          await dio().put('/playlists/' + playlistId.toString() + '/edit',
              data: {'playlistName': playListName},
              options: Dio.Options(
                headers: {'Authorization': 'Bearer $token'},
                validateStatus: (status) {
                  return status! < 500;
                },
              ));
      return response.statusCode;
    } catch (e, stacktrace) {
      print('caught $e : $stacktrace');
    }
  }

  static Future<int?> modifyPlaylist(
  {required int playlistId, required List<Map<String, dynamic>> order} ) async {
    try {
      String? token = await UserSecureStorage.getToken();
      Dio.Response response =
      await dio().put('/playlists/' + playlistId.toString() + '/modify',
          data: json.encode(order),
          options: Dio.Options(
            headers: {'Authorization': 'Bearer $token'},
            validateStatus: (status) {
              return status! < 500;
            },
          ));
      return response.statusCode;
    } catch (e, stacktrace) {
      print('caught $e : $stacktrace');
    }
  }

  static Future<int?> deletePlaylist(int playlistId) async {
    try {
      String? token = await UserSecureStorage.getToken();
      Dio.Response response =
          await dio().delete('/playlists/' + playlistId.toString() + '/delete',
              options: Dio.Options(
                headers: {'Authorization': 'Bearer $token'},
                validateStatus: (status) {
                  return status! < 500;
                },
              ));
      return response.statusCode;
    } catch (e, stacktrace) {
      print('caught $e : $stacktrace');
    }
  }

  static Future<List<MediaItem>> getUserListenHistories() async {
    try {
      String? token = await UserSecureStorage.getToken();
      Dio.Response response = await dio().get('/me/listen-histories',
          options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
      return (response.data as List)
          .map((x) => mediaItemFromApiJson(x))
          .toList();
    } catch (e, stacktrace) {
      print('caught $e : $stacktrace');
    }
    return [];
  }

  static Future<void> removeSongFromPlaylist(
      int playlistId, int serverId) async {
    try {
      String? token = await UserSecureStorage.getToken();
      Dio.Response response = await dio().delete(
          '/playlists/' + playlistId.toString() + '/remove',
          data: {'serverId': serverId},
          options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
    } catch (e, stacktrace) {
      print('caught $e : $stacktrace');
    }
  }
}
