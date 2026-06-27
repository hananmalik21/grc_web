import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/digify_bottom_sheet.dart';
import 'package:grc/features/security_manager/presentation/providers/function_roles/function_roles_state.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

/// Bottom sheet that lists [FunctionRoleItem.includedFunctions] for quick review on mobile.
class FunctionRoleDetailMobileSheet extends StatelessWidget {
  const FunctionRoleDetailMobileSheet({super.key, required this.role});

  final FunctionRoleItem role;

  static Future<void> show(BuildContext context, FunctionRoleItem role) {
    return DigifyBottomSheet.show<void>(
      context,
      type: DigifyBottomSheetType.custom,
      title: role.name,
      child: FunctionRoleDetailMobileSheet(role: role),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final secondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final primary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;

    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(20.w, 0, 20.w, 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (role.description.isNotEmpty) ...[
            Text(role.description, style: context.textTheme.bodyMedium?.copyWith(color: secondary, height: 1.45)),
            Gap(16.h),
          ],
          Text(
            l10n.functionRoleIncludedFunctionsHeading(role.includedFunctions.length),
            style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600, color: primary),
          ),
          Gap(12.h),
          Expanded(
            child: role.includedFunctions.isEmpty
                ? Center(
                    child: Text(
                      l10n.functionRoleDetailNoFunctions,
                      textAlign: TextAlign.center,
                      style: context.textTheme.bodyMedium?.copyWith(color: secondary),
                    ),
                  )
                : ListView.separated(
                    padding: EdgeInsets.only(bottom: 8.h),
                    itemCount: role.includedFunctions.length,
                    separatorBuilder: (_, _) => Gap(10.h),
                    itemBuilder: (context, index) {
                      return _IncludedFunctionTile(label: role.includedFunctions[index], isDark: isDark);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _IncludedFunctionTile extends StatelessWidget {
  const _IncludedFunctionTile({required this.label, required this.isDark});

  final String label;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundGreyDark.withValues(alpha: 0.45) : AppColors.sidebarSearchBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DigifyAsset(assetPath: Assets.icons.checkIconGreen.path, width: 16, height: 16, color: AppColors.primary),
          Gap(10.w),
          Expanded(
            child: Text(label, style: context.textTheme.bodyMedium?.copyWith(color: textPrimary)),
          ),
        ],
      ),
    );
  }
}
