import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0C1D),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Notifications",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: FirestoreService().getNotificationsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print("🚨 FIREBASE ERROR: ${snapshot.error}");
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: const TextStyle(color: Colors.redAccent),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.purpleAccent),
            );
          }

          final notifications = snapshot.data ?? [];

          if (notifications.isEmpty) {
            return Center(
              child: Text(
                "No new notifications",
                style: GoogleFonts.poppins(color: Colors.white54, fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final note = notifications[index];

              final timestamp = note['timestamp'] as Timestamp?;
              final timeString = timestamp != null
                  ? _formatTimeAgo(timestamp.toDate())
                  : "Just now";

              final bool isNew = note['isNew'] ?? false;
              final String docId = note['id'] ?? '';

              return GestureDetector(
                onTap: () {
                  if (isNew && docId.isNotEmpty) {
                    FirestoreService().markNotificationAsRead(docId);
                  }
                },
                child: NotificationTile(
                  title: note['title'] ?? 'Notification',
                  subtitle: note['subtitle'] ?? '',
                  time: timeString,
                  icon: _getIcon(note['iconType']),
                  isNew: isNew,
                ),
              );
            },
          );
        },
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
        border: isNew
            ? Border.all(color: Colors.purpleAccent.withOpacity(0.5), width: 1)
            : null,
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
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          time,
                          style: GoogleFonts.poppins(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 14,
                          ),
                        ),
                        if (isNew) ...[
                          const SizedBox(width: 4),
                          const CircleAvatar(
                            radius: 4,
                            backgroundColor: Colors.purpleAccent,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

IconData _getIcon(String? type) {
  switch (type) {
    case 'music':
      return Icons.queue_music;
    case 'alert':
      return Icons.error_outline;
    case 'analytics':
      return Icons.analytics_outlined;
    case 'system':
      return Icons.settings_suggest_outlined;
    case 'success':
      return Icons.auto_awesome;
    default:
      return Icons.notifications_active_outlined;
  }
}

String _formatTimeAgo(DateTime date) {
  final difference = DateTime.now().difference(date);
  if (difference.inMinutes < 1) return 'Just now';
  if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
  if (difference.inHours < 24) return '${difference.inHours}h ago';
  if (difference.inDays == 1) return 'Yesterday';
  return '${difference.inDays} days ago';
}
