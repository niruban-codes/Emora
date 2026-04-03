import 'package:flutter/material.dart';

// ── Mood types ─────────────────────────────────────────────────────────────
// Single enum used everywhere in the app.
// mood_data.dart's MoodType.neutral and MoodType.excited have been
// replaced with MoodType.peaceful and MoodType.melancholy.
enum MoodType { happy, sad, peaceful, energetic, anxious, melancholy }

// ── Mood Model ─────────────────────────────────────────────────────────────
class MoodModel {
  final MoodType type;
  final String label; // uppercase display label  e.g. "HAPPY"
  final String emoji;
  final String songTitle;
  final String artist;
  final String genre;
  final String description;

  const MoodModel({
    required this.type,
    required this.label,
    required this.emoji,
    required this.songTitle,
    required this.artist,
    required this.genre,
    required this.description,
  });

  // Converts the MoodModel into a Map for Firestore storage.
  Map<String, dynamic> toMap() {
    return {
      'type': type.name, 
      'label': label,
      'songTitle': songTitle,
      'artist': artist,
      'genre': genre,
      'playlistTitles': playlistTitles, 
      'emoji': emoji,
    };
  }

  // ── Colours ───────────────────────────────────────────────────────────────
  // Computed from type so callers never need to pass colours manually.
  // Previously mood_data.dart hardcoded Color(0xFF8B2D8B) for every mood —
  // that's now replaced with distinct per-mood palettes.

  /// Primary accent — drives buttons, borders, play button, badge bg.
  Color get primaryColor {
    switch (type) {
      case MoodType.happy:
        return const Color(0xFFFFB347); // warm amber
      case MoodType.sad:
        return const Color(0xFF42A5F5); // cool blue
      case MoodType.peaceful:
        return const Color(0xFF64B5F6); // soft sky
      case MoodType.energetic:
        return const Color(0xFF66BB6A); // vibrant green
      case MoodType.anxious:
        return const Color(0xFFEF5350); // tense red
      case MoodType.melancholy:
        return const Color(0xFF9575CD); // muted violet
    }
  }

  /// Secondary — used as the gradient pair with [primaryColor].
  Color get secondaryColor {
    switch (type) {
      case MoodType.happy:
        return const Color(0xFFFFF176); // yellow
      case MoodType.sad:
        return const Color(0xFF7E57C2); // purple-blue
      case MoodType.peaceful:
        return const Color(0xFF80DEEA); // teal
      case MoodType.energetic:
        return const Color(0xFFFFEE58); // yellow-green
      case MoodType.anxious:
        return const Color(0xFFFF7043); // deep orange
      case MoodType.melancholy:
        return const Color(0xFFCE93D8); // lavender
    }
  }

  /// Label colour — used for the large mood heading text.
  Color get labelColor {
    switch (type) {
      case MoodType.happy:
        return const Color(0xFFFFD54F);
      case MoodType.sad:
        return const Color(0xFF90CAF9);
      case MoodType.peaceful:
        return const Color(0xFF81D4FA);
      case MoodType.energetic:
        return const Color(0xFFA5D6A7);
      case MoodType.anxious:
        return const Color(0xFFFF8A80);
      case MoodType.melancholy:
        return const Color(0xFFD4A0D4);
    }
  }

  // ── Playlists ─────────────────────────────────────────────────────────────
  List<String> get playlistTitles {
    switch (type) {
      case MoodType.happy:
        return ['Sunshine Hits', 'Feel Good Vibes', 'Golden Hour'];
      case MoodType.sad:
        return ['Healing Waves', 'Quiet Tears', 'Gentle Ache'];
      case MoodType.peaceful:
        return ['Calm Waters', 'Morning Zen', 'Soft Focus'];
      case MoodType.energetic:
        return ['Midnight Pulse', 'Power Hour', 'Peak Energy'];
      case MoodType.anxious:
        return ['Steady Ground', 'Breathe Easy', 'Anchor Tones'];
      case MoodType.melancholy:
        return ['Rainy Echoes', 'Blue Hours', 'Nostalgic Dreams'];
    }
  }

  // ── fromString ────────────────────────────────────────────────────────────
  // Called with the raw string returned by your emotion-detection API.
  // e.g.  MoodModel.fromString('happy')  or  MoodModel.fromString('ENERGETIC')
  factory MoodModel.fromString(String raw) {
    switch (raw.trim().toLowerCase()) {
      case 'happy':
        return const MoodModel(
          type: MoodType.happy,
          label: 'HAPPY',
          emoji: '😊',
          songTitle: 'Walking on Sunshine',
          artist: 'Katrina & The Waves',
          genre: 'Pop',
          description: "You're radiating good energy. Let the music match!",
        );
      case 'sad':
        return const MoodModel(
          type: MoodType.sad,
          label: 'SAD',
          emoji: '😢',
          songTitle: 'Someone Like You',
          artist: 'Adele',
          genre: 'Soul',
          description: 'Feeling low. These songs understand.',
        );
      case 'peaceful':
        return const MoodModel(
          type: MoodType.peaceful,
          label: 'PEACEFUL',
          emoji: '☁️',
          songTitle: 'Weightless',
          artist: 'Marconi Union',
          genre: 'Ambient',
          description: 'Calm and centred. Lean into the tranquility.',
        );
      case 'energetic':
        return const MoodModel(
          type: MoodType.energetic,
          label: 'ENERGETIC',
          emoji: '⚡',
          songTitle: 'Midnight Pulse',
          artist: 'Daft Punk',
          genre: 'Electronic',
          description: "You're buzzing. Time to turn it up.",
        );
      case 'anxious':
        return const MoodModel(
          type: MoodType.anxious,
          label: 'ANXIOUS',
          emoji: '😰',
          songTitle: 'Breathe (2 AM)',
          artist: 'Anna Nalick',
          genre: 'Acoustic Pop',
          description: 'Your mind is racing. Let the music slow you down.',
        );
      case 'melancholy':
      default:
        return const MoodModel(
          type: MoodType.melancholy,
          label: 'MELANCHOLY',
          emoji: '🌙',
          songTitle: 'The Night We Met',
          artist: 'Lord Huron',
          genre: 'Indie Folk',
          description: 'A bittersweet haze surrounds you. Embrace it.',
        );
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// ALL MOODS  —  replaces mood_data.dart entirely.
//
// Use [allMoods] anywhere you need to iterate over every mood:
//   • Mood grid on HomeScreen
//   • Detectable-emotions legend on EmotionDetectionScreen
//   • Any future mood-picker widget
//
// Use [getMoodByType] for a direct type → MoodModel lookup.
// Use [MoodModel.fromString] when handling an API response string.
// ═══════════════════════════════════════════════════════════════════════════

const List<MoodModel> allMoods = [
  MoodModel(
    type: MoodType.happy,
    label: 'HAPPY',
    emoji: '😊',
    songTitle: 'Walking on Sunshine',
    artist: 'Katrina & The Waves',
    genre: 'Pop',
    description: "You're radiating good energy. Let the music match!",
  ),
  MoodModel(
    type: MoodType.sad,
    label: 'SAD',
    emoji: '😢',
    songTitle: 'Someone Like You',
    artist: 'Adele',
    genre: 'Soul',
    description: 'Feeling low. These songs understand.',
  ),
  MoodModel(
    type: MoodType.peaceful,
    label: 'PEACEFUL',
    emoji: '☁️',
    songTitle: 'Weightless',
    artist: 'Marconi Union',
    genre: 'Ambient',
    description: 'Calm and centred. Lean into the tranquility.',
  ),
  MoodModel(
    type: MoodType.energetic,
    label: 'ENERGETIC',
    emoji: '⚡',
    songTitle: 'Midnight Pulse',
    artist: 'Daft Punk',
    genre: 'Electronic',
    description: "You're buzzing. Time to turn it up.",
  ),
  MoodModel(
    type: MoodType.anxious,
    label: 'ANXIOUS',
    emoji: '😰',
    songTitle: 'Breathe (2 AM)',
    artist: 'Anna Nalick',
    genre: 'Acoustic Pop',
    description: 'Your mind is racing. Let the music slow you down.',
  ),
  MoodModel(
    type: MoodType.melancholy,
    label: 'MELANCHOLY',
    emoji: '🌙',
    songTitle: 'The Night We Met',
    artist: 'Lord Huron',
    genre: 'Indie Folk',
    description: 'A bittersweet haze surrounds you. Embrace it.',
  ),
];

// Convenience lookup — throws a StateError if type isn't found (shouldn't happen).
MoodModel getMoodByType(MoodType type) {
  return allMoods.firstWhere((m) => m.type == type);
}
