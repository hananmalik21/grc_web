import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_capsule.dart';
import 'package:grc/core/widgets/forms/digify_select_field.dart';
import 'package:grc/features/hiring/domain/configs/hiring_config.dart';
import 'package:grc/features/hiring/presentation/providers/offers/offers_filter_provider.dart';
import 'package:grc/features/hiring/presentation/utils/offer_status_labels.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class OffersFilterBar extends ConsumerWidget {
  const OffersFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final filterState = ref.watch(offersFilterProvider);
    final filterNotifier = ref.read(offersFilterProvider.notifier);
    final fillColor = isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '${loc.status}:',
            style: context.textTheme.bodyMedium?.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          Gap(16.w),
          SizedBox(
            width: 220.w,
            child: DigifySelectField<String?>(
              hint: loc.allOffers,
              value: filterState.status,
              items: HiringConfig.offerStatusDropdownValues,
              itemLabelBuilder: (value) => offerStatusDropdownLabel(loc, value),
              onChanged: filterNotifier.setStatus,
              fillColor: fillColor,
            ),
          ),
          const Spacer(),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              for (final value in HiringConfig.offerStatusCapsuleValues)
                _OffersFilterStatusCapsule(
                  label: offerStatusCapsuleLabel(loc, value),
                  iconPath: offerStatusCapsuleIcon(value),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OffersFilterStatusCapsule extends StatelessWidget {
  const _OffersFilterStatusCapsule({required this.label, required this.iconPath});

  final String label;
  final String iconPath;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return DigifyCapsule(
      label: label,
      iconPath: iconPath,
      backgroundColor: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
      borderColor: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
      textColor: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
      borderRadius: 8.r,
      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 3.h),
    );
  }
}
