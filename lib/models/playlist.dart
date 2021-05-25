class Playlist{
  int id;
  String name;
  int tracks;
  String lastUpdated;

  Playlist({
    required this.id,
    required this.name,
    required this.tracks,
    required this.lastUpdated,
  });

  Playlist.fromJson(Map<String, dynamic> json)
  : id = json['playlist_id'],
    name = json['playlist_name'],
    tracks = json['tracks'],
    lastUpdated = json['last_updated'];
}