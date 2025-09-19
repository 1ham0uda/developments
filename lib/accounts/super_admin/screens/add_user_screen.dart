import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({super.key});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController jobTitleController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  DateTime? dob;

  String accountType = 'Admin';
  String? assignedAdmin;
  List<String> adminsList = [];

  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _loadAdmins();
  }

  Future<void> _loadAdmins() async {
    final snapshot = await _firestore.collection('users').where('role', isEqualTo: 'Admin').get();
    setState(() {
      adminsList = snapshot.docs.map((doc) => doc['username'] as String).toList();
    });
  }

  Future<void> _createUser() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isSubmitting = true);

    try {
      await _firestore.collection('users').add({
        'fullName': nameController.text.trim(),
        'email': emailController.text.trim(),
        'username': usernameController.text.trim(),
        'phone': phoneController.text.trim(),
        'jobTitle': jobTitleController.text.trim(),
        'address': addressController.text.trim(),
        'dob': dob != null ? Timestamp.fromDate(dob!) : null,
        'role': accountType,
        'assignedAdmin': accountType == 'Sales' ? assignedAdmin : null,
        'createdAt': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User created successfully!')),
      );
      _formKey.currentState!.reset();
      setState(() {
        accountType = 'Admin';
        assignedAdmin = null;
        dob = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating user: $e')),
      );
    } finally {
      setState(() => isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add User'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField('Full Name', nameController),
              _buildTextField('Email', emailController, type: TextInputType.emailAddress),
              _buildTextField('Username', usernameController),
              _buildTextField('Phone Number', phoneController, type: TextInputType.phone),
              _buildTextField('Job Title', jobTitleController),
              _buildTextField('Address', addressController),
              _buildDatePicker(),
              const SizedBox(height: 16),
              _buildAccountTypeDropdown(),
              if (accountType == 'Sales') _buildAssignedAdminDropdown(),
              const SizedBox(height: 24),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextButton(
                    onPressed: isSubmitting ? null : _createUser,
                    child: isSubmitting
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Create User',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType type = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        validator: (value) => value == null || value.isEmpty ? 'Required' : null,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          filled: true,
          fillColor: Colors.grey[100],
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: GestureDetector(
        onTap: () async {
          final date = await showDatePicker(
            context: context,
            initialDate: DateTime(2000),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );
          if (date != null) setState(() => dob = date);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Text(
            dob != null ? DateFormat('yyyy-MM-dd').format(dob!) : 'Date of Birth',
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildAccountTypeDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        value: accountType,
        items: const [
          DropdownMenuItem(value: 'Admin', child: Text('Admin')),
          DropdownMenuItem(value: 'Sales', child: Text('Sales')),
        ],
        onChanged: (value) => setState(() {
          accountType = value!;
          if (accountType == 'Admin') assignedAdmin = null;
        }),
        decoration: InputDecoration(
          labelText: 'Account Type',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          filled: true,
          fillColor: Colors.grey[100],
        ),
      ),
    );
  }

  Widget _buildAssignedAdminDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        value: assignedAdmin,
        items: adminsList.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: (value) => setState(() => assignedAdmin = value),
        decoration: InputDecoration(
          labelText: 'Assigned Admin',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          filled: true,
          fillColor: Colors.grey[100],
        ),
      ),
    );
  }
}
