import 'package:flutter/material.dart';
import '../../common/widgets/custom_button.dart';
import '../../common/widgets/custom_textfield.dart';
import '../../common/theme/app_colors.dart';
import '../../common/theme/app_text_styles.dart';
import '../../common/services/auth_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Icon(Icons.apartment, size: 80, color: AppColors.primary),
              const SizedBox(height: 16),
              Text(
                "Hamouda Developments",
                style: AppTextStyles.headingLarge.copyWith(color: AppColors.primary),
              ),
              const SizedBox(height: 40),

              CustomTextField(controller: _nameController, hintText: "Full Name", prefixIcon: Icon(Icons.person)),
              const SizedBox(height: 16),
              CustomTextField(controller: _emailController, hintText: "Email", prefixIcon: Icon(Icons.email)),
              const SizedBox(height: 16),
              CustomTextField(controller: _phoneController, hintText: "Phone", prefixIcon: Icon(Icons.phone)),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _passwordController,
                hintText: "Password",
                prefixIcon: Icon(Icons.lock),
                obscureText: !_isPasswordVisible,
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: AppColors.grey,
                  ),
                  onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                ),
              ),
              const SizedBox(height: 30),

              CustomButton(
                text: "Sign Up",
                onPressed: () async {
                  String name = _nameController.text.trim();
                  String email = _emailController.text.trim();
                  String phone = _phoneController.text.trim();
                  String password = _passwordController.text.trim();

                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => const Center(child: CircularProgressIndicator()),
                  );

                  String result = await AuthService.signUp(
                    name: name,
                    email: email,
                    phone: phone,
                    password: password,
                  );

                  Navigator.pop(context); // غلق الـ Loading

                  if (result == "success") {
                    Navigator.pushReplacementNamed(context, "/client-home");
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
                  }
                },
              ),

              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account? ", style: AppTextStyles.bodyMedium.copyWith(color: AppColors.greyDark)),
                  GestureDetector(
                    onTap: () => Navigator.pushReplacementNamed(context, "/login"),
                    child: Text("Login", style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
