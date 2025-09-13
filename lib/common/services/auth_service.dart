import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // تسجيل دخول
  static Future<String> login({required String email, required String password}) async {
    try {
      UserCredential userCred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userCred.user!.uid).get();

      if (!userDoc.exists) return "User data not found!";
      return userDoc['userType']; // Client, Sales, Admin, SuperAdmin
    } catch (e) {
      return e.toString();
    }
  }

  // تسجيل عميل جديد (Client فقط)
  static Future<String> signUp({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      UserCredential userCred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore.collection('users').doc(userCred.user!.uid).set({
        'name': name,
        'email': email,
        'phone': phone,
        'userType': 'Client',
        'createdAt': FieldValue.serverTimestamp(),
      });

      return "success";
    } catch (e) {
      return e.toString();
    }
  }
}
