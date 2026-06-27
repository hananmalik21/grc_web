import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/features/leave_management/data/mappers/color_mapper.dart';
import 'package:grc/features/leave_management/domain/models/leave_entitlement.dart';
import 'package:grc/features/leave_management/presentation/providers/leave_entitlements_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class KuwaitLawEntitlementsSection extends ConsumerWidget {
  final AppLocalizations localizations;

  const KuwaitLawEntitlementsSection({super.key, required this.localizations});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final entitlementsAsync = ref.watch(kuwaitLawEntitlementsProvider);

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations.kuwaitLaborLawLeaveEntitlements,
            style: context.textTheme.titleSmall?.copyWith(fontSize: 17.sp, color: AppColors.dialogTitle),
          ),
          Gap(16.h),
          entitlementsAsync.when(
            data: (entitlements) => _buildEntitlementsGrid(context, entitlements, isDark),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Text('Error: ${error.toString()}'),
          ),
        ],
      ),
    );
  }

  Widget _buildEntitlementsGrid(BuildContext context, List<LeaveEntitlement> entitlements, bool isDark) {
    final crossAxisCount = context.isMobile ? 1 : (context.isTablet ? 2 : 4);
    final spacing = 16.w;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: 16.h,
      crossAxisSpacing: spacing,
      childAspectRatio: context.isMobile ? 3.0 : (context.isTablet ? 2.5 : 2.6),
      children: entitlements
          .map((entitlement) => _buildEntitlementCard(context, entitlement: entitlement, isDark: isDark))
          .toList(),
    );
  }

  Widget _buildEntitlementCard(BuildContext context, {required dynamic entitlement, required bool isDark}) {
    final title = _getLocalizedTitle(entitlement.titleKey);
    final entitlementText = _getLocalizedEntitlement(entitlement.entitlementKey);
    final backgroundColor = ColorMapper.getColor(entitlement.backgroundColorKey);
    final titleColor = ColorMapper.getColor(entitlement.titleColorKey);
    final subtitleColor = ColorMapper.getColor(entitlement.subtitleColorKey);

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(10.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: context.textTheme.bodyLarge?.copyWith(color: titleColor)),
          Gap(3.h),
          Text(
            entitlementText,
            style: context.textTheme.bodyLarge?.copyWith(color: subtitleColor),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  String _getLocalizedTitle(String key) {
    switch (key) {
      case 'annualLeave':
        return localizations.annualLeave;
      case 'sickLeave':
        return localizations.sickLeave;
      case 'maternityLeave':
        return localizations.maternityLeave;
      case 'emergencyLeave':
        return localizations.emergencyLeave;
      default:
        return '';
    }
  }

  String _getLocalizedEntitlement(String key) {
    switch (key) {
      case 'annualLeaveEntitlement':
        return localizations.annualLeaveEntitlement;
      case 'sickLeaveEntitlement':
        return localizations.sickLeaveEntitlement;
      case 'maternityLeaveEntitlement':
        return localizations.maternityLeaveEntitlement;
      case 'emergencyLeaveEntitlement':
        return localizations.emergencyLeaveEntitlement;
      default:
        return '';
    }
  }
}
