import 'package:cloud_firestore/cloud_firestore.dart';

class SuperAdminController {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // جلب كل المستخدمين
  Future<List<Map<String, dynamic>>> fetchUsers() async {
    QuerySnapshot snapshot = await _firestore.collection('users').get();
    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  // حذف مستخدم
  Future<void> deleteUser(String uid) async {
    await _firestore.collection('users').doc(uid).delete();
  }

  // إضافة مستخدم جديد (Admin/Sales)
  Future<void> addUser(Map<String, dynamic> data) async {
    await _firestore.collection('users').doc(data['uid']).set(data);
  }

  // تعديل بيانات مستخدم
  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _firestore.collection('users').doc(uid).update(data);
  }
}
