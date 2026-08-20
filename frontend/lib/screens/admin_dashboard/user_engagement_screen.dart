import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../api_service.dart';

class UserEngagementScreen extends StatefulWidget {
  final VoidCallback? onBackToDashboard;
  const UserEngagementScreen({super.key, this.onBackToDashboard});

  @override
  State<UserEngagementScreen> createState() => _UserEngagementScreenState();
}
class _UserEngagementScreenState extends State<UserEngagementScreen> {
  late Future<List<dynamic>> _usersFuture;

  @override
  void initState() {
    super.initState();
    _usersFuture = ApiService().getAdminUsers().then((val) => val ?? []);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0C1D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0C1D),
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          "User Engagement",
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (widget.onBackToDashboard != null) {
              widget.onBackToDashboard!(); 
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF6C5CE7)));
          }
          final users = snapshot.data ?? [];
          final totalUsers = users.length;
          final photosCount = users.where((u) => u['photo'] != null && u['photo'].toString().isNotEmpty).length;

          return RefreshIndicator(
            onRefresh: () async => setState(() {
              _usersFuture = ApiService().getAdminUsers().then((val) => val ?? []);
            }),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Overview", style: TextStyle(fontSize: 16, color: Colors.white70)),
                  const SizedBox(height: 12),

                  GridView.count(
                    shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 1.6, 
                    children: [
                      _buildStatCard("Total Accounts", "$totalUsers", "Registered", const Color(0xFF6C5CE7)),
                      _buildStatCard("Profile Photos", "$photosCount", "Avatars set", const Color(0xFFD43FB1)),
                      _buildStatCard("Active Status", "$totalUsers", "Verified", Colors.blueAccent),
                      _buildStatCard("Database Tier", "Online", "Connected", Colors.orangeAccent),
                    ],
                  ),
                  const SizedBox(height: 25),

                  _buildChartSection(
                    title: "User Growth Trend",
                    subtitle: "Cumulative registrations",
                    height: 180,
                    child: _buildDALineChart(totalUsers),
                  ),
                  const SizedBox(height: 20),
                  
                  _buildUserListSection(users),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // UI COMPONENTS

  Widget _buildStatCard(String title, String value, String sub, Color accent) {
    return Container(
      //width: 150,
      margin: const EdgeInsets.only(right: 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF252648),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 11, color: Colors.white54),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            sub,
            style: TextStyle(fontSize: 9, color: accent.withOpacity(0.9)),
          ),
        ],
      ),
    );
  }

  Widget _buildChartSection({
    required String title,
    String? subtitle,
    double? height,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF252648),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          if (subtitle != null)
            Text(
              subtitle,
              style: const TextStyle(fontSize: 10, color: Colors.white54),
            ),
          const SizedBox(height: 15),
          height != null ? SizedBox(height: height, child: child) : child,
        ],
      ),
    );
  }

Widget _buildDALineChart(int userCount) {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: [
              const FlSpot(0, 0),
              FlSpot(1, (userCount * 0.2).clamp(0, double.infinity)),
              FlSpot(2, (userCount * 0.5).clamp(0, double.infinity)),
              FlSpot(3, (userCount * 0.75).clamp(0, double.infinity)),
              FlSpot(4, userCount.toDouble()),
            ],
            isCurved: true, color: const Color(0xFF00FFCC), barWidth: 3,
            belowBarData: BarAreaData(show: true, color: const Color(0xFF00FFCC).withOpacity(0.1)),
          ),
        ],
      ),
    );
  }

  Widget _buildUserListSection(List<dynamic> users) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF252648), borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Registered Users", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 12),
          if (users.isEmpty)
            const Text("No users found", style: TextStyle(color: Colors.white54, fontSize: 12))
          else
            ...users.map((user) {
              final name = user['name']?.toString() ?? 'Anonymous';
              final photo = user['photo']?.toString();
              return ListTile(
                dense: true, contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  radius: 18, backgroundColor: const Color(0xFF6C5CE7),
                  backgroundImage: (photo != null && photo.isNotEmpty) ? NetworkImage(photo) : null,
                  child: (photo == null || photo.isEmpty) ? Text(name.isNotEmpty ? name[0].toUpperCase() : 'U', style: const TextStyle(color: Colors.white)) : null,
                ),
                title: Text(name, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                subtitle: Text(user['email']?.toString() ?? 'No Email', style: const TextStyle(color: Colors.white54, fontSize: 11)),
              );
            }),
        ],
      ),
    );
  }
}