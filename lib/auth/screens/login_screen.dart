import 'package:flutter/material.dart';
import '../../common/widgets/custom_button.dart';
import '../../common/widgets/custom_textfield.dart';
import '../../common/theme/app_colors.dart';
import '../../common/theme/app_text_styles.dart';
import '../../common/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo or App Title
              Icon(Icons.apartment, size: 80, color: AppColors.primary),
              const SizedBox(height: 16),
              Text(
                "Hamouda Developments",
                style: AppTextStyles.headingLarge.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),

              // Email field
              CustomTextField(
                controller: _emailController,
                hintText: "Email Address",
                prefixIcon: Icon(Icons.email),
              ),
              const SizedBox(height: 20),

              // Password field
              CustomTextField(
                controller: _passwordController,
                hintText: "Password",
                prefixIcon: Icon(Icons.lock),
                obscureText: !_isPasswordVisible,
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: AppColors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
              const SizedBox(height: 10),

              // Forgot password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/forgot-password");
                  },
                  child: Text(
                    "Forgot Password?",
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Login button
              CustomButton(
                text: "Login",
                onPressed: () async {
                  String email = _emailController.text.trim();
                  String password = _passwordController.text.trim();

                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) =>
                        const Center(child: CircularProgressIndicator()),
                  );

                  String result =
                      await AuthService.login(email: email, password: password);
                  Navigator.pop(context); // غلق Loading

                  if (result == "Client") {
                    Navigator.pushReplacementNamed(context, "/client-home");
                  } else if (result == "Sales") {
                    Navigator.pushReplacementNamed(context, "/sales-home");
                  } else if (result == "Admin") {
                    Navigator.pushReplacementNamed(context, "/admin-home");
                  } else if (result == "SuperAdmin") {
                    Navigator.pushReplacementNamed(context, "/super-admin-home");
                  } else {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(result)));
                  }
                },
              ),
              const SizedBox(height: 20),

              // Signup link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: AppColors.greyDark),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/signup");
                    },
                    child: Text(
                      "Sign Up",
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
