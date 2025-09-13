import 'package:flutter/material.dart';
import '../super_admin_controller.dart';
import '../widgets/user_card.dart';
import 'user_profile_screen.dart';

class AdminsMonitorScreen extends StatefulWidget {
  const AdminsMonitorScreen({super.key});

  @override
  State<AdminsMonitorScreen> createState() => _AdminsMonitorScreenState();
}

class _AdminsMonitorScreenState extends State<AdminsMonitorScreen> {
  final SuperAdminController _controller = SuperAdminController();
  List<Map<String, dynamic>> admins = [];

  @override
  void initState() {
    super.initState();
    _loadAdmins();
  }

  void _loadAdmins() async {
    var allUsers = await _controller.fetchUsers();
    admins = allUsers.where((user) => user['userType'] == 'Admin').toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admins Monitor")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: admins.length,
        itemBuilder: (context, index) {
          var admin = admins[index];
          return UserCard(
            name: admin['name'],
            email: admin['email'],
            role: admin['userType'],
            onDelete: () {},
            onTap: () { 
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => UserProfileScreen(userData: admin),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
