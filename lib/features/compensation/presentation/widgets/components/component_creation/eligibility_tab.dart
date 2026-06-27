import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/theme_extensions.dart';
import '../../../../../../core/widgets/assets/digify_asset.dart';
import '../../../../../../core/widgets/common/section_header_card.dart';
import '../../../../../../core/widgets/common/info_guidelines_box.dart';
import '../../../../../../gen/assets.gen.dart';
import 'package:grc/features/compensation/domain/models/lookups/comp_lookup_value.dart';
import '../../../providers/create_new_component_provider.dart';
import 'package:grc/features/compensation/presentation/providers/lookups/comp_lookups_provider.dart';
import 'component_creation_shared.dart';

class EligibilityStep extends ConsumerWidget {
  const EligibilityStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final state = ref.watch(createNewComponentProvider);
    final notifier = ref.read(createNewComponentProvider.notifier);

    final locationsAsync = ref.watch(compLookupValuesProvider('COMPONENT_LOCATION'));
    final locations = locationsAsync.valueOrNull ?? const <CompLookupValue>[];

    return ComponentCreationPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeaderCard(
            icon: DigifyAsset(
              assetPath: Assets.icons.employeesSmallIcon.path,
              width: 17.sp,
              height: 17.sp,
              color: AppColors.primary,
            ),
            title: 'Eligibility Criteria',
            subtitle: 'Define which employees are eligible for this compensation component',
          ),
          Gap(24.h),

          _buildLookupEligibilitySection(
            context: context,
            iconAssetPath: Assets.icons.locationSmallIcon.path,
            title: 'Eligible Locations',
            subtitle: 'Select one or more locations (optional)',
            items: locations,
            selectedCodes: state.locations,
            onToggle: notifier.toggleLocation,
            isDark: isDark,
            isLoading: locationsAsync.isLoading,
          ),
          Gap(24.h),

          Gap(32.h),

          InfoGuidelinesBox(
            title: 'Eligibility Logic',
            iconAssetPath: Assets.icons.infoCircleBlue.path,
            backgroundColor: isDark ? AppColors.warningBgDark : AppColors.warningBg,
            borderColor: isDark ? AppColors.warningBorderDark : AppColors.warningBorder,
            iconBackgroundColor: AppColors.transparent,
            iconColor: isDark ? AppColors.warningTextDark : AppColors.warningText,
            titleColor: isDark ? AppColors.warningTextDark : AppColors.warningText,
            messageColor: isDark ? AppColors.warningTextDark : AppColors.warningText,
            messages: const ['If no locations are selected, the component will be available to all employees.'],
          ),
        ],
      ),
    );
  }

  Widget _buildLookupEligibilitySection({
    required BuildContext context,
    required String iconAssetPath,
    required String title,
    required String subtitle,
    required List<CompLookupValue> items,
    required Set<String> selectedCodes,
    required ValueChanged<String> onToggle,
    required bool isDark,
    required bool isLoading,
  }) {
    final effectiveItems = items.where((e) => e.isActive).toList()
      ..sort((a, b) => (a.displaySequence ?? 0).compareTo(b.displaySequence ?? 0));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            DigifyAsset(assetPath: iconAssetPath, width: 18.sp, height: 18.sp, color: AppColors.textSecondary),
            Gap(8.w),
            Text(
              title,
              style: context.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: isDark ? context.themeTextPrimary : AppColors.textPrimary,
              ),
            ),
          ],
        ),
        Gap(12.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 10.h,
          children: effectiveItems.map((item) {
            final isSelected = selectedCodes.contains(item.valueCode);
            return _SelectableChip(
              label: item.valueName,
              isSelected: isSelected,
              onTap: isLoading ? null : () => onToggle(item.valueCode),
              isDark: isDark,
            );
          }).toList(),
        ),
        Gap(12.h),
        Text(
          isLoading ? 'Please wait...' : subtitle,
          style: context.textTheme.bodySmall?.copyWith(
            color: isDark ? context.themeTextMuted : AppColors.textSecondary,
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }
}

class _SelectableChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final bool isDark;

  const _SelectableChip({required this.label, required this.isSelected, required this.onTap, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final textStyle = (context.textTheme.labelMedium ?? const TextStyle()).copyWith(
      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
      color: isSelected ? Colors.white : (isDark ? context.themeTextPrimary : AppColors.textPrimary),
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : (isDark ? AppColors.inputBgDark : Colors.white),
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: isSelected ? AppColors.primary : (isDark ? AppColors.inputBorderDark : AppColors.borderGrey),
            ),
          ),
          child: Text(label, style: textStyle),
        ),
      ),
    );
  }
}
