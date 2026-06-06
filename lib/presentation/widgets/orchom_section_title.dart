import 'package:flutter/material.dart';
import '../theme/app_text_styles.dart';

class OrchomSectionTitle extends StatelessWidget {
  final String title;

  const OrchomSectionTitle({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: AppTextStyles.headlineMd.copyWith(
          fontSize: 20,
          height: 28 / 20,
        ),
      ),
    );
  }
}
