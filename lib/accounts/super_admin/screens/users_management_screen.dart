import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_user_screen.dart'; // شاشة إنشاء مستخدم جديد
import 'user_profile_screen.dart';

class UsersManagementScreen extends StatefulWidget {
  const UsersManagementScreen({super.key});

  @override
  State<UsersManagementScreen> createState() => _UsersManagementScreenState();
}

class _UsersManagementScreenState extends State<UsersManagementScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, int> userCounts = {};
  bool isLoading = true;

  final List<Map<String, dynamic>> userTypes = [
    {'type': 'Admin', 'icon': Icons.admin_panel_settings},
    {'type': 'Sales', 'icon': Icons.group},
    {'type': 'Client', 'icon': Icons.person},
  ];

  @override
  void initState() {
    super.initState();
    _loadUserCounts();
  }

  Future<void> _loadUserCounts() async {
    Map<String, int> counts = {};
    for (var userType in userTypes) {
      final snapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: userType['type'])
          .get();
      counts[userType['type']] = snapshot.docs.length;
    }
    setState(() {
      userCounts = counts;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Users Management",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue[800],
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddUserScreen()),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text("Add User"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[800],
                foregroundColor: Colors.white,
                textStyle:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          )
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                itemCount: userTypes.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.1),
                itemBuilder: (context, index) {
                  final type = userTypes[index]['type']!;
                  final icon = userTypes[index]['icon'] as IconData;
                  final count = userCounts[type] ?? 0;

                  return Stack(
                    children: [
                      HoverCard(
                        title: type,
                        count: count,
                        icon: icon,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  UserListByTypeScreen(userType: type),
                            ),
                          );
                        },
                      ),
                      if (count > 0)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4,
                                    offset: const Offset(0, 2))
                              ],
                            ),
                            child: Text(
                              count.toString(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                            ),
                          ),
                        )
                    ],
                  );
                },
              ),
            ),
    );
  }
}

// كارت مع أنيميشن Hover
class HoverCard extends StatefulWidget {
  final String title;
  final int count;
  final IconData icon;
  final VoidCallback onTap;

  const HoverCard(
      {super.key,
      required this.title,
      required this.count,
      required this.icon,
      required this.onTap});

  @override
  State<HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard>
    with SingleTickerProviderStateMixin {
  bool isHovered = false;
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => isHovered = true);
        _controller.forward();
      },
      onExit: (_) {
        setState(() => isHovered = false);
        _controller.reverse();
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isHovered ? Colors.blue[50] : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: isHovered
                ? [
                    BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6))
                  ]
                : [],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedRotation(
                turns: isHovered ? 0.1 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Icon(widget.icon, size: 48, color: Colors.blue[800]),
              ),
              const SizedBox(height: 12),
              Text(widget.title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
              const SizedBox(height: 6),
              Text("${widget.count} Users",
                  style: const TextStyle(fontSize: 14, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}

// شاشة عرض المستخدمين حسب النوع
class UserListByTypeScreen extends StatelessWidget {
  final String userType;
  const UserListByTypeScreen({super.key, required this.userType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$userType Users",
            style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue[800],
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('role', isEqualTo: userType)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final users = snapshot.data!.docs;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final data = users[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue[100],
                  child: Icon(Icons.person, color: Colors.blue[800]),
                ),
                title: Text(data['name']),
                subtitle: Text(data['email']),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => UserProfileScreen(
                          userData: data.data() as Map<String, dynamic>),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
