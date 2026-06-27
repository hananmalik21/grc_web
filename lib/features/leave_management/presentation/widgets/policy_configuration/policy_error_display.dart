import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/leave_management/presentation/widgets/policy_configuration/policy_surface_card.dart';
import 'package:flutter/material.dart';

class PolicyErrorDisplay extends StatelessWidget {
  const PolicyErrorDisplay({required this.isDark, required this.errorMessage, super.key});

  final bool isDark;
  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return PolicySurfaceCard(
      isDark: isDark,
      child: Center(
        child: Text(
          'Error loading policies: $errorMessage',
          style: context.textTheme.bodyMedium?.copyWith(color: isDark ? AppColors.errorTextDark : AppColors.errorText),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
