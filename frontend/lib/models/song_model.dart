class Song {
  final String id;
  final String title;
  final String artist;
  final String coverUrl;
  final bool isFavorite;
  final String duration;
  final String mood;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.coverUrl,
    this.isFavorite = false,
    this.duration = '',
    this.mood = 'All',
  });

  factory Song.fromJson(
    Map<String, dynamic> json, {
    String? defaultMood,
    bool isFav = false,
  }) {
    return Song(
      id: json['videoId'] ?? json['id'] ?? '',
      title: json['title'] ?? '',
      artist: json['artist'] ?? '',
      coverUrl: json['thumbnail'] ?? json['coverUrl'] ?? '',
      duration: json['duration'] ?? '',
      mood: json['mood'] ?? defaultMood ?? 'All',
      isFavorite: json['isFavorite'] ?? isFav,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'videoId': id,
      'title': title,
      'artist': artist,
      'thumbnail': coverUrl,
      'duration': duration,
      'mood': mood,
      'isFavorite': true,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
}
