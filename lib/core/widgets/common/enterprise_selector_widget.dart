import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/forms/digify_select_field.dart';
import 'package:grc/core/widgets/feedback/shimmer_widget.dart';
import 'package:grc/core/services/initialization/providers/initialization_providers.dart';
import 'package:grc/features/enterprise_structure/domain/models/enterprise.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class EnterpriseSelectorWidget extends ConsumerWidget {
  final int? selectedEnterpriseId;
  final ValueChanged<int?> onEnterpriseChanged;

  const EnterpriseSelectorWidget({super.key, required this.selectedEnterpriseId, required this.onEnterpriseChanged});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(showEnterpriseSelectorProvider)) {
      return const SizedBox.shrink();
    }

    final enterprisesState = ref.watch(enterprisesCacheStateProvider);
    final isDark = context.isDark;
    final selectedEnterprise = enterprisesState.findEnterpriseById(selectedEnterpriseId);
    final hasSelection = selectedEnterprise != null;

    final effectiveSubtitle = (hasSelection
        ? 'Viewing data for selected enterprise'
        : 'Select an enterprise to view data');

    final bool isCompact = MediaQuery.of(context).size.width < 700;

    final header = Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: isDark ? 0.2 : 0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(Icons.business, size: 20.sp, color: AppColors.primary),
        ),
        Gap(12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Enterprise',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                ),
              ),
              if (effectiveSubtitle.isNotEmpty) ...[
                Gap(2.h),
                Text(
                  effectiveSubtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isDark ? AppColors.textPlaceholderDark : AppColors.textPlaceholder,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );

    final dropdown = enterprisesState.isLoading
        ? ShimmerWidget(
            child: Container(
              height: 40.h,
              decoration: BoxDecoration(
                color: isDark ? AppColors.inputBgDark : const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          )
        : DigifySelectField<Enterprise>(
            label: isCompact ? 'Select Enterprise' : '',
            isRequired: true,
            hint: 'Select Enterprise',
            items: enterprisesState.enterprises,
            itemLabelBuilder: (e) => e.name,
            value: selectedEnterprise,
            onChanged: (e) => onEnterpriseChanged(e?.id),
          );

    final selectedBadge = !hasSelection
        ? const SizedBox.shrink()
        : Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: isDark ? 0.12 : 0.08),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, size: 16.sp, color: AppColors.primary),
                Gap(6.w),
                Text(
                  selectedEnterprise.name,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          );

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : const Color(0xFFE5E7EB), width: 1),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: isCompact
          // 📱 Mobile / Small: Column layout
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                header,
                Gap(12.h),
                dropdown,
                if (hasSelection) ...[Gap(12.h), selectedBadge],
              ],
            )
          // 🖥 Web / Large: Row layout
          : Row(
              children: [
                // left header
                SizedBox(width: 260.w, child: header),
                Gap(16.w),

                // middle dropdown
                Expanded(child: dropdown),

                // right badge
                if (hasSelection) ...[Gap(12.w), selectedBadge],
              ],
            ),
    );
  }
}
