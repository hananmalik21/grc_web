import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_checkbox.dart';
import 'package:grc/features/leave_management/domain/models/policy_configuration.dart';
import 'package:grc/features/leave_management/presentation/providers/policy_draft_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class SupportingDocumentationCard extends ConsumerWidget {
  final AdvancedRules advanced;
  final bool isDark;
  final bool isEditing;

  const SupportingDocumentationCard({super.key, required this.advanced, required this.isDark, required this.isEditing});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draftNotifier = ref.read(policyDraftProvider.notifier);

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.warningBgDark.withValues(alpha: 0.2) : AppColors.warningBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.warningBorderDark : AppColors.warningBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DigifyCheckbox(
            value: advanced.requiredSupportingDocumentation,
            onChanged: isEditing ? (v) => draftNotifier.updateRequiresDocument(v ?? false) : null,
          ),
          Gap(7.w),
          Expanded(
            child: Text(
              'Requires Supporting Documentation',
              style: context.textTheme.titleSmall?.copyWith(
                color: isDark ? AppColors.warningTextDark : AppColors.yellowText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
