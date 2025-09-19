import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;
  final bool isDisabled;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isPrimary = true,
    this.isDisabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isDisabled
            ? AppColors.textSecondary.withOpacity(0.3)
            : (isPrimary ? AppColors.primary : AppColors.secondary),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: isDisabled ? 0 : 4,
      ),
      onPressed: isDisabled ? null : onPressed,
      child: Text(
        text,
        style: AppTextStyles.button,
      ),
    );
  }
}
