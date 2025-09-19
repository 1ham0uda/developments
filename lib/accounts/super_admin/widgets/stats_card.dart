import 'package:flutter/material.dart';
import 'package:hamouda_developments/common/theme/app_colors.dart';
import 'package:hamouda_developments/common/theme/app_text_styles.dart';

class StatsCard extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;

  const StatsCard({super.key, required this.title, required this.count, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 40, color: AppColors.primary),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.bodyMedium),
                const SizedBox(height: 8),
                Text(count.toString(), style: AppTextStyles.headingMedium.copyWith(color: AppColors.primary)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
