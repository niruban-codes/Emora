import 'package:flutter/material.dart';
import '../../models/song_model.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  double _sliderValue = 30;
  final Song currentSong = Song.dummyPlaylist[0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Now Playing', style: TextStyle(fontSize: 16)),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Album Art
            Hero(
              tag: 'album_art',
              child: Container(
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                  image: DecorationImage(
                    image: NetworkImage(currentSong.coverUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 48),

            // Title & Artist
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentSong.title,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      currentSong.artist,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(
                    currentSong.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                  ),
                  color: currentSong.isFavorite ? Colors.red : null,
                  iconSize: 32,
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Progress Slider
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 4,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              ),
              child: Slider(
                value: _sliderValue,
                min: 0,
                max: 100,
                onChanged: (val) => setState(() => _sliderValue = val),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text('1:24'), Text('3:45')],
              ),
            ),
            const Spacer(),

            // Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(icon: const Icon(Icons.shuffle), onPressed: () {}),
                IconButton(
                  icon: const Icon(Icons.skip_previous, size: 40),
                  onPressed: () {},
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.pause,
                      size: 48,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.skip_next, size: 40),
                  onPressed: () {},
                ),
                IconButton(icon: const Icon(Icons.repeat), onPressed: () {}),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
