import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/dialogs/overtime_rate_multiplier_mobile_sheet.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/screens/mixins/overtime_configuration_permission_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/theme/app_shadows.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../core/widgets/assets/digify_asset.dart';
import '../../../../../core/widgets/assets/digify_asset_button.dart';
import '../../../../../core/widgets/common/digify_square_capsule.dart';
import '../../../../../core/widgets/common/scrollable_wrapper.dart';
import '../../../../../core/widgets/forms/digify_text_field.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../domain/models/overtime_configuration/rate_multiplier.dart';
import '../../dialogs/overtime_rate_multiplier_dialog.dart';
import '../../providers/overtime_configuration/overtime_configuration_provider.dart';

class ComponentRateMultipliers extends ConsumerWidget with OvertimeConfigurationPermissionMixin {
  const ComponentRateMultipliers({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(overtimeConfigurationProvider.select((state) => state.isLoading));
    final rateMultipliers = ref.watch(overtimeConfigurationProvider.select((state) => state.rateMultipliers));
    final notifier = ref.read(overtimeConfigurationProvider.notifier);

    return Container(
      decoration: BoxDecoration(
        color: context.isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Row(
              children: [
                DigifyAsset(
                  assetPath: Assets.icons.attendanceMainIcon.path,
                  color: AppColors.primary,
                  height: 28.h,
                  width: 28.w,
                ),
                Gap(8.w),
                Text('Rate Multipliers', style: context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                Spacer(),
                if (canCreateOvertimeConfiguration) ...[
                  InkWell(
                    onTap: () => context.isMobileLayout
                        ? OvertimeRateMultiplierMobileSheet.show(context)
                        : OvertimeRateMultiplierDialog.show(context),
                    child: Row(
                      children: [
                        DigifyAsset(
                          assetPath: Assets.icons.addNewIconFigma.path,
                          color: AppColors.primary,
                          height: 24.h,
                          width: 24.w,
                        ),
                        Gap(8.w),
                        Text(
                          'Add Custom Rate',
                          style: context.textTheme.labelLarge?.copyWith(color: AppColors.primary),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          ScrollableSingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              children: [
                _buildTableHeaderRow(context),
                ConstrainedBox(
                  constraints: BoxConstraints(minHeight: 300.h),
                  child: Column(
                    children: [
                      if (isLoading)
                        Skeletonizer(
                          enabled: true,
                          child: Column(
                            children: List.generate(
                              3,
                              (index) => _buildTableDataRow(
                                context,
                                RateMultiplier(
                                  rateName: "----------------",
                                  rateDescription: "------------------------------",
                                  multiplier: "--",
                                  categoryCode: "-------",
                                ),
                              ),
                            ),
                          ),
                        )
                      else if (rateMultipliers.isEmpty)
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 40.h),
                          height: 250,
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'No rate multipliers found',
                                style: context.textTheme.titleMedium?.copyWith(color: AppColors.textSecondary),
                              ),
                              Gap(8.h),
                              Text(
                                'Click "Add Custom Rate" to create one.',
                                style: context.textTheme.labelMedium?.copyWith(color: AppColors.textTertiary),
                              ),
                            ],
                          ),
                        )
                      else
                        ...rateMultipliers.map(
                          (e) => _buildTableDataRow(
                            context,
                            e,
                            onEdit: () => context.isMobileLayout
                                ? OvertimeRateMultiplierMobileSheet.show(context, rateMultiplier: e)
                                : OvertimeRateMultiplierDialog.show(context, rateMultiplier: e),
                            onDelete: () => notifier.deleteRateMultiplier(e.otRateTypeId),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeaderRow(BuildContext context) {
    return Container(
      color: context.isDark ? AppColors.backgroundDark : AppColors.tableHeaderBackground,
      child: Row(
        children: [
          _buildCell(
            context,
            Text(
              'RATE TYPE',
              style: context.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.isDark ? AppColors.textMutedDark : AppColors.textTertiary,
              ),
            ),
            450.w,
          ),
          _buildCell(
            context,
            Text(
              'CATEGORY',
              style: context.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.isDark ? AppColors.textMutedDark : AppColors.textTertiary,
              ),
            ),
            150.w,
          ),
          _buildCell(
            context,
            Text(
              'MULTIPLIER',
              style: context.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.isDark ? AppColors.textMutedDark : AppColors.textTertiary,
              ),
            ),
            150.w,
          ),
          _buildCell(
            context,
            Text(
              'ACTIONS',
              style: context.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.isDark ? AppColors.textMutedDark : AppColors.textTertiary,
              ),
            ),
            150.w,
          ),
        ],
      ),
    );
  }

  Widget _buildTableDataRow(
    BuildContext context,
    RateMultiplier rateMultiplier, {

    VoidCallback? onEdit,
    VoidCallback? onDelete,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: context.isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1.h),
        ),
      ),
      child: Row(
        children: [
          _buildCell(
            context,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(rateMultiplier.rateName, style: context.textTheme.titleMedium?.copyWith()),
                Gap(4.h),
                Text(rateMultiplier.rateDescription, style: context.textTheme.labelSmall?.copyWith()),
              ],
            ),
            450.w,
          ),
          _buildCell(
            context,
            Align(
              alignment: Alignment.centerLeft,
              child: DigifySquareCapsule(
                label: rateMultiplier.categoryCode,
                textColor: AppColors.primary,
                backgroundColor: AppColors.primary.withValues(alpha: .1),
              ),
            ),
            150.w,
          ),
          _buildCell(
            context,
            Row(
              children: [
                Expanded(
                  child: Skeleton.unite(
                    child: DigifyTextField(
                      key: ValueKey(rateMultiplier.multiplier),
                      initialValue: rateMultiplier.multiplier,
                      enabled: false,
                      filled: true,
                      fillColor: context.isDark ? AppColors.backgroundDark : AppColors.tableHeaderBackground,
                    ),
                  ),
                ),
                Gap(8.w),
                Skeleton.keep(
                  child: Text(
                    'x',
                    style: context.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.isDark ? AppColors.textMutedDark : AppColors.textTertiary,
                    ),
                  ),
                ),
              ],
            ),
            150.w,
          ),

          _buildCell(
            context,
            Skeleton.unite(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                spacing: 8.w,
                children: [
                  DigifyAssetButton(assetPath: Assets.icons.editIcon.path, onTap: onEdit),
                  DigifyAssetButton(assetPath: Assets.icons.redDeleteIcon.path, onTap: onDelete),
                ],
              ),
            ),
            150.w,
          ),
        ],
      ),
    );
  }

  Widget _buildCell(BuildContext context, Widget child, double width) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      width: width,
      child: child,
    );
  }
}
