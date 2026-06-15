class Song {
  final String id;
  final String title;
  final String artist;
  final String coverUrl;
  final bool isFavorite;
  final String duration;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.coverUrl,
    this.isFavorite = false,
    this.duration = '',
  });
 
 factory Song.fromJson(Map<String, dynamic> json){
  return Song(id: json['videoId'] ?? '',
   title: json['title'] ?? '',
    artist: json['artist'] ?? '',
     coverUrl: json['thumbnail'] ?? '',
     duration: json['duration'] ?? '',
     );
 }
}
