import 'package:flutter/material.dart';

class UserProfileScreen extends StatelessWidget {
  final Map<String, dynamic> userData;

  const UserProfileScreen({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(userData['name'])),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Name: ${userData['name']}"),
            Text("Email: ${userData['email']}"),
            Text("Role: ${userData['userType']}"),
            if(userData.containsKey('phone'))
              Text("Phone: ${userData['phone']}"),
            if(userData.containsKey('createdAt'))
              Text("Created At: ${userData['createdAt'].toDate()}"),
          ],
        ),
      ),
    );
  }
}
