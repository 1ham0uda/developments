import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final String name;
  final String email;
  final String role;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const UserCard({
    super.key,
    required this.name,
    required this.email,
    required this.role,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(name),
        subtitle: Text('$email • $role'),
        onTap: onTap,
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
