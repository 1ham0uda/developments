import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'auth/screens/login_screen.dart';
import 'auth/screens/signup_screen.dart';
import 'accounts/super_admin/screens/dashboard_screen.dart'; // استدعاء شاشة الداشبورد
import 'firebase_options.dart'; // إعدادات Firebase للويب

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة Firebase للويب والأندرويد/آي أو إس
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hamouda Developments',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginScreen(),
        '/signup': (_) => const SignUpScreen(),
        '/client-home': (_) => const Scaffold(
              body: Center(child: Text("Client Home")),
            ),
        '/sales-home': (_) => const Scaffold(
              body: Center(child: Text("Sales Home")),
            ),
        '/admin-home': (_) => const Scaffold(
              body: Center(child: Text("Admin Home")),
            ),
        '/super-admin-home': (_) => const DashboardScreen(), // هنا استدعاء الداشبورد
      },
    );
  }
}
