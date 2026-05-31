import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0C1D), // Dark purple background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Notifications", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          NotificationTile(
            title: "Mood Sync Successful!",
            subtitle: "Your morning mood scan was successful! Check your new Peaceful playlist.",
            time: "2m ago",
            icon: Icons.auto_awesome,
            isNew: true,
          ),
          NotificationTile(
            title: "Playlist Update",
            subtitle: "3 new tracks added to your 'Energetic Afternoon' collection.",
            time: "1h ago",
            icon: Icons.queue_music,
            isNew: true,
          ),
          NotificationTile(
            title: "System Alert",
            subtitle: "Weekly mood analytics report is now ready for review.",
            time: "5h ago",
            icon: Icons.analytics_outlined,
          ),
          NotificationTile(
            title: "AI Model Update",
            subtitle: "We've enhanced your facial expression detection for better mood accuracy.",
            time: "Yesterday",
            icon: Icons.settings_suggest_outlined,
          ),
          NotificationTile(
            title: "Security Check",
            subtitle: "Your account data is safely encrypted and backed up to the cloud.",
            time: "2 days ago",
            icon: Icons.verified_user_outlined,
          ),
        ],
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final String title, subtitle, time;
  final IconData icon;
  final bool isNew;

  const NotificationTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.icon,
    this.isNew = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
        border: isNew ? Border.all(color: Colors.purpleAccent.withOpacity(0.5), width: 1) : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.purple.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.purpleAccent, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16)),
                    Row(
                      children: [
                        Text(time, style: GoogleFonts.poppins(color: Colors.white.withOpacity(0.5), fontSize: 14)),
                        if (isNew) ...[
                          const SizedBox(width: 4),
                          const CircleAvatar(radius: 4, backgroundColor: Colors.purpleAccent),
                        ]
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(subtitle, style: GoogleFonts.poppins(color: Colors.white.withOpacity(0.7), fontSize: 13, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}