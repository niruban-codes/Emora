import 'package:flutter/material.dart';
import '/api_service.dart';

class DashboardScreen extends StatefulWidget {
  final VoidCallback? onExitAdmin;
  const DashboardScreen({super.key, this.onExitAdmin});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<List<dynamic>> _dashboardFuture;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _dashboardFuture = Future.wait([
      ApiService().getAdminStats(),
      ApiService().getAdminLogs(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0C1D),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          "Admin Dashboard",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (widget.onExitAdmin != null) {
              widget.onExitAdmin!();
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _dashboardFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF6C5CE7)),
            );
          }

          final stats = (snapshot.data?[0] as Map<String, dynamic>?) ?? {};
          final logs = (snapshot.data?[1] as List<dynamic>?) ?? [];

          final totalUsers = "${stats['total_users'] ?? 0}";
          final totalDetections = "${stats['total_detections'] ?? 0}";
          final topEmotion =
              (stats['most_common_emotion']?.toString().toUpperCase()) ??
              "NONE";
          final totalLogs = "${logs.length}";

          return RefreshIndicator(
            onRefresh: () async => setState(() => _loadData()),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Welcome Back, Admin!",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    "Overview of system activity",
                    style: TextStyle(color: Colors.white54, fontSize: 13),
                  ),
                  const SizedBox(height: 20),

                  // 1. TOP STATS GRID
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15,
                    childAspectRatio: 1.5,
                    children: [
                      _buildStatCard(
                        "Total Users",
                        totalUsers,
                        "Registered",
                        Icons.person,
                        const Color(0xFF6C5CE7),
                      ),
                      _buildStatCard(
                        "Total Detections",
                        totalDetections,
                        "Face Scans",
                        Icons.face_retouching_natural,
                        const Color(0xFFD43FB1),
                      ),
                      _buildStatCard(
                        "Top Emotion",
                        topEmotion,
                        "Most common",
                        Icons.psychology,
                        Colors.purple,
                      ),
                      _buildStatCard(
                        "Admin Actions",
                        totalLogs,
                        "Logged events",
                        Icons.history,
                        Colors.orangeAccent,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  _buildRecentActivitySection(logs),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    String sub,
    IconData icon,
    Color color, {
    bool isTrend = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF252648),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 10, color: Colors.white70),
          ),
          if (isTrend)
            Text(
              sub,
              style: const TextStyle(
                fontSize: 10,
                color: Color(0xFF00FFCC),
                fontWeight: FontWeight.bold,
              ),
            )
          else if (sub.isNotEmpty)
            Text(
              sub,
              style: const TextStyle(fontSize: 9, color: Colors.white38),
            ),
        ],
      ),
    );
  }

  Widget _buildRecentActivitySection(List<dynamic> logs) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF252648),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Recent Activity",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 15),
          if (logs.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                "No admin activity logged yet",
                style: TextStyle(color: Colors.white38, fontSize: 12),
              ),
            )
          else
            ...logs.take(4).map((log) {
              final action = log['action']?.toString() ?? 'Action';
              final time = log['timestamp']?.toString().substring(0, 10) ?? '';
              return Column(
                children: [
                  _activityItem(action, time, const Color(0xFF00FFCC)),
                  const Divider(color: Colors.white10),
                ],
              );
            }),
        ],
      ),
    );
  }

  Widget _activityItem(String text, String time, Color dotColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          CircleAvatar(radius: 5, backgroundColor: dotColor),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 12, color: Colors.white),
            ),
          ),
          Text(
            time,
            style: const TextStyle(color: Colors.white38, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

// Helper Widgets
class _legend extends StatelessWidget {
  final Color col;
  final String txt;
  const _legend(this.col, this.txt);
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      CircleAvatar(radius: 3, backgroundColor: col),
      const SizedBox(width: 4),
      Text(txt, style: const TextStyle(fontSize: 9, color: Colors.white70)),
    ],
  );
}

class _miniLegend extends StatelessWidget {
  final Color color;
  final String label;
  const _miniLegend(this.color, this.label);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 8, color: Colors.white60)),
      ],
    ),
  );
}
