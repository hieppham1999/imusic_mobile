import 'package:audio_service/audio_service.dart';

class MyMediaItem extends MediaItem {
  final int serverId;

  const MyMediaItem({
    required this.serverId,
    id,
    album,
    title,
    artist,
    genre,
    duration,
    artUri,
    playable = true,
    displayTitle,
    displaySubtitle,
    displayDescription,
    rating,
    extras,
  }) : super(
            id: id,
            album: album,
            title: title,
            artist: artist,
            genre: genre,
            duration: duration,
            artUri: artUri,
            playable: playable,
            displayTitle: displayTitle,
            displaySubtitle: displaySubtitle,
            displayDescription: displayDescription,
            rating: rating,
            extras: extras);

  factory MyMediaItem.fromJson(Map raw) {
    return new MyMediaItem(
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
        extras: raw['extras']?.cast<String, dynamic>(),
        serverId: raw['song_id']);
  }
}
