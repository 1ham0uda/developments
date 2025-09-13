import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// استدعاء الشاشات
import 'admins_monitor_screen.dart';
import 'users_management_screen.dart';
import 'users_list_screen.dart';

// نسخة بسيطة للألوان والخطوط لو الملفات مش موجودة
class AppColors {
  static const primary = Color(0xFF1976D2);
  static const grey = Colors.grey;
  static const background = Colors.white;
}

class AppTextStyles {
  static const headingMedium =
      TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  static const headingSmall =
      TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
  static const bodyMedium = TextStyle(fontSize: 14);
}

// كارد إحصائيات مع تأثير Hover
class StatsCard extends StatefulWidget {
  final String title;
  final int count;
  final IconData icon;

  const StatsCard(
      {super.key, required this.title, required this.count, required this.icon});

  @override
  State<StatsCard> createState() => _StatsCardState();
}

class _StatsCardState extends State<StatsCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          boxShadow: isHovered
              ? [BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 12)]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(widget.icon, size: 36, color: AppColors.primary),
            const SizedBox(height: 8),
            Text(widget.title, style: AppTextStyles.headingSmall),
            const SizedBox(height: 4),
            Text(widget.count.toString(),
                style: AppTextStyles.headingMedium
                    .copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

// الكنترولر للسوبر أدمن
class SuperAdminController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<int> fetchAdminsCount() async {
    final snapshot = await _firestore
        .collection('users')
        .where('role', isEqualTo: 'Admin')
        .get();
    return snapshot.docs.length;
  }

  Future<int> fetchUsersCount() async {
    final snapshot = await _firestore
        .collection('users')
        .where('role', isEqualTo: 'Client')
        .get();
    return snapshot.docs.length;
  }

  Future<int> fetchRequestsCount() async {
    final snapshot = await _firestore.collection('requests').get();
    return snapshot.docs.length;
  }
}

// Sidebar Button مع Hover Animation
class SidebarButton extends StatefulWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const SidebarButton(
      {super.key, required this.title, required this.icon, required this.onTap});

  @override
  State<SidebarButton> createState() => _SidebarButtonState();
}

class _SidebarButtonState extends State<SidebarButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: isHovered ? AppColors.primary.withOpacity(0.1) : Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            boxShadow: isHovered
                ? [BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 8)]
                : [],
          ),
          child: Row(
            children: [
              Icon(widget.icon, size: 28, color: AppColors.primary),
              const SizedBox(width: 12),
              Expanded(
                  child: Text(widget.title,
                      style: AppTextStyles.headingSmall.copyWith(
                          fontWeight: FontWeight.bold))),
            ],
          ),
        ),
      ),
    );
  }
}

// الشاشة الرئيسية للداشبورد
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final SuperAdminController controller = SuperAdminController();
  int adminsCount = 0;
  int usersCount = 0;
  int requestsCount = 0;
  bool isLoading = true;
  Widget currentScreen = const SizedBox();

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    try {
      final admins = await controller.fetchAdminsCount();
      final users = await controller.fetchUsersCount();
      final requests = await controller.fetchRequestsCount();

      setState(() {
        adminsCount = admins;
        usersCount = users;
        requestsCount = requests;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        adminsCount = 0;
        usersCount = 0;
        requestsCount = 0;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          // ================= Sidebar =================
          Container(
            width: 220,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 6)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo + Site Name
                Row(
                  children: [
                    Icon(Icons.home_work, size: 32, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text("Hamouda Devs",
                        style: AppTextStyles.headingMedium.copyWith(
                            fontWeight: FontWeight.bold, color: AppColors.primary)),
                  ],
                ),
                const SizedBox(height: 32),

                // Sidebar Buttons
                SidebarButton(
                    title: "Admins Monitor",
                    icon: Icons.group,
                    onTap: () {
                      _changeScreen(const AdminsMonitorScreen());
                    }),
                const SizedBox(height: 16),
                SidebarButton(
                    title: "Users Management",
                    icon: Icons.manage_accounts,
                    onTap: () {
                      _changeScreen(const UsersManagementScreen());
                    }),
                const SizedBox(height: 16),
                SidebarButton(
                    title: "User List",
                    icon: Icons.list,
                    onTap: () {
                      _changeScreen(const UserListScreen());
                    }),
                const SizedBox(height: 16),
                SidebarButton(
                    title: "Reports",
                    icon: Icons.analytics,
                    onTap: () {
                      _changeScreen(Container(
                        alignment: Alignment.center,
                        child: Text("Reports Screen Coming Soon",
                            style: AppTextStyles.headingMedium),
                      ));
                    }),
                const SizedBox(height: 16),
                SidebarButton(
                    title: "Settings",
                    icon: Icons.settings,
                    onTap: () {
                      _changeScreen(Container(
                        alignment: Alignment.center,
                        child: Text("Settings Screen Coming Soon",
                            style: AppTextStyles.headingMedium),
                      ));
                    }),
                const SizedBox(height: 16),
                SidebarButton(
                    title: "Notifications",
                    icon: Icons.notifications,
                    onTap: () {
                      _changeScreen(Container(
                        alignment: Alignment.center,
                        child: Text("Notifications Screen Coming Soon",
                            style: AppTextStyles.headingMedium),
                      ));
                    }),
              ],
            ),
          ),

          // ================= Content Area =================
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      transitionBuilder: (child, animation) {
                        final offsetAnimation = Tween<Offset>(
                                begin: const Offset(0.1, 0), end: Offset.zero)
                            .animate(animation);
                        return SlideTransition(
                          position: offsetAnimation,
                          child: FadeTransition(opacity: animation, child: child),
                        );
                      },
                      child: currentScreen is SizedBox
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Stats Row
                                SizedBox(
                                  height: 120,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      StatsCard(
                                          title: "Admins",
                                          count: adminsCount,
                                          icon: Icons.admin_panel_settings),
                                      const SizedBox(width: 16),
                                      StatsCard(
                                          title: "Users",
                                          count: usersCount,
                                          icon: Icons.person),
                                      const SizedBox(width: 16),
                                      StatsCard(
                                          title: "Requests",
                                          count: requestsCount,
                                          icon: Icons.request_page),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      "Select an option from the sidebar",
                                      style: AppTextStyles.headingMedium
                                          .copyWith(color: Colors.grey[600]),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : currentScreen,
                    ),
            ),
          )
        ],
      ),
    );
  }

  void _changeScreen(Widget screen) {
    setState(() {
      currentScreen = screen;
    });
  }
}
