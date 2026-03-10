class Song {
  final String id;
  final String title;
  final String artist;
  final String coverUrl;
  final bool isFavorite;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.coverUrl,
    this.isFavorite = false,
  });

  // Dummy Data
  static List<Song> dummyPlaylist = [
    Song(
      id: '1',
      title: 'Midnight City',
      artist: 'M83',
      coverUrl: 'https://picsum.photos/200?1',
    ),
    Song(
      id: '2',
      title: 'Blinding Lights',
      artist: 'The Weeknd',
      coverUrl: 'https://picsum.photos/200?2',
      isFavorite: true,
    ),
    Song(
      id: '3',
      title: 'Levitating',
      artist: 'Dua Lipa',
      coverUrl: 'https://picsum.photos/200?3',
    ),
  ];
}
