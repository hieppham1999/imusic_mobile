import 'package:audio_service/audio_service.dart';

extension ServerMediaItem on MediaItem {
  int getServerId() => this.extras?['serverId'] ?? 0;
}

MediaItem mediaItemFromApiJson(Map raw) => MediaItem(
      id: raw['url'],
      album: raw['album_name'],
      title: raw['title'],
      artist: raw['artist'],
      genre: raw['genre_name'],
      duration: raw['duration'] != null
          ? Duration(milliseconds: raw['duration'])
          : null,
      artUri: raw['art_uri'] != null ? Uri.parse(raw['art_uri']) : null,
      playable: raw['playable'],
      displayTitle: raw['displayTitle'],
      displaySubtitle: raw['displaySubtitle'],
      displayDescription: raw['displayDescription'],
      rating: null,
      extras: {'serverId': raw['song_id']},
    );
