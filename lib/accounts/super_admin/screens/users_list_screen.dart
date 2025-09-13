import 'package:flutter/material.dart';
import '../widgets/user_card.dart';
import '../super_admin_controller.dart';
import 'user_profile_screen.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final SuperAdminController _controller = SuperAdminController();
  List<Map<String, dynamic>> users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  void _loadUsers() async {
    users = await _controller.fetchUsers();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All Users")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: users.length,
        itemBuilder: (context, index) {
          var user = users[index];
          return UserCard(
            name: user['name'],
            email: user['email'],
            role: user['userType'],
            onDelete: () {},
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => UserProfileScreen(userData: user),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
