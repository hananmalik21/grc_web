import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/theme/app_shadows.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../core/widgets/assets/digify_asset_button.dart';
import '../../../../../core/widgets/buttons/app_button.dart';
import '../../../../../core/widgets/common/digify_capsule.dart';
import '../../../../../core/widgets/common/scrollable_wrapper.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../domain/models/grade_structure_management/grade_record.dart';
import '../../dialogs/grade_structure_management/grade_level_dialog.dart';
import '../../providers/grade_structure_management/grade_structure_managment_provider.dart';

class ComponentGradeStructureTable extends ConsumerWidget {
  const ComponentGradeStructureTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gradeStructureManagementProvider);
    return LayoutBuilder(
      builder: (context, constraints) => Container(
        decoration: BoxDecoration(
          color: context.isDark
              ? AppColors.cardBackgroundDark
              : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: AppShadows.primaryShadow,
        ),
        child: ScrollableSingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTableHeaderRow(context),
              ConstrainedBox(
                constraints: BoxConstraints(minHeight: 200.h),
                child: Column(
                  children: [
                    if (state.isLoading)
                      Skeletonizer(
                        enabled: true,
                        child: Column(
                          children: List.generate(
                            3,
                            (index) => _buildTableDataRow(context),
                          ),
                        ),
                      )
                    else if (state.error != null)
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 40.h),
                        height: 250.h,
                        width: constraints.maxWidth,
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: AppColors.brandRed,
                              size: 40.r,
                            ),
                            Gap(16.h),
                            Text(
                              'Error loading records',
                              style: context.textTheme.titleMedium?.copyWith(
                                color: AppColors.brandRed,
                              ),
                            ),
                            Gap(8.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24.w),
                              child: Text(
                                state.error!,
                                textAlign: TextAlign.center,
                                style: context.textTheme.bodySmall?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                            Gap(16.h),
                            AppButton.outline(
                              label: 'Retry',
                              onPressed: () => ref
                                  .read(
                                    gradeStructureManagementProvider.notifier,
                                  )
                                  .refresh(),
                            ),
                          ],
                        ),
                      )
                    else if (state.records.isEmpty)
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 40.h),
                        height: 150.h,
                        width: constraints.maxWidth,
                        alignment: Alignment.center,
                        child: Text(
                          'No record found',
                          style: context.textTheme.titleMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      )
                    else
                      Column(
                        children: state.records
                            .map(
                              (record) => _buildTableDataRow(
                                context,
                                record: record,
                                onEdit: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) =>
                                        GradeLevelDialog(gradeRecord: record),
                                  );
                                },
                              ),
                            )
                            .toList(),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTableHeaderRow(BuildContext context) {
    return Container(
      color: context.isDark
          ? AppColors.backgroundDark
          : AppColors.tableHeaderBackground,
      child: Row(
        children: [
          _buildCell(
            context,
            Text(
              'GRADE LEVEL',
              style: context.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.isDark
                    ? AppColors.textMutedDark
                    : AppColors.textTertiary,
              ),
            ),
            200.w,
          ),
          _buildCell(
            context,
            Text(
              'DESCRIPTION',
              style: context.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.isDark
                    ? AppColors.textMutedDark
                    : AppColors.textTertiary,
              ),
            ),
            300.w,
          ),
          _buildCell(
            context,
            Text(
              'MIN CAP',
              style: context.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.isDark
                    ? AppColors.textMutedDark
                    : AppColors.textTertiary,
              ),
            ),
            200.w,
          ),
          _buildCell(
            context,
            Text(
              'MAX CAP',
              style: context.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.isDark
                    ? AppColors.textMutedDark
                    : AppColors.textTertiary,
              ),
            ),
            200.w,
          ),
          _buildCell(
            context,
            Text(
              'STEPS',
              style: context.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.isDark
                    ? AppColors.textMutedDark
                    : AppColors.textTertiary,
              ),
            ),
            200.w,
          ),
          _buildCell(
            context,
            Text(
              'INCREMENT',
              style: context.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.isDark
                    ? AppColors.textMutedDark
                    : AppColors.textTertiary,
              ),
            ),
            200.w,
          ),
          _buildCell(
            context,
            Text(
              'ACTIONS',
              style: context.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.isDark
                    ? AppColors.textMutedDark
                    : AppColors.textTertiary,
              ),
            ),
            200.w,
          ),
        ],
      ),
    );
  }

  Widget _buildTableDataRow(
    BuildContext context, {
    GradeRecord? record,
    VoidCallback? onEdit,
    VoidCallback? onDelete,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: context.isDark
                ? AppColors.cardBorderDark
                : AppColors.cardBorder,
            width: 1.h,
          ),
        ),
      ),
      child: Row(
        children: [
          _buildCell(
            context,
            Align(
              alignment: Alignment.centerLeft,
              child: DigifyCapsule(
                label: record?.gradeLevel ?? '-------',
                backgroundColor: AppColors.primary.withValues(alpha: .2),
                textColor: AppColors.primary,
              ),
            ),
            200.w,
          ),
          _buildCell(
            context,
            Text(
              record?.description ?? '--------',
              style: context.textTheme.bodyMedium,
            ),
            300.w,
          ),
          _buildCell(
            context,
            Text(
              record?.minSalary ?? '---',
              style: context.textTheme.bodyMedium,
            ),
            200.w,
          ),
          _buildCell(
            context,
            Text(
              record?.maxSalary ?? '---',
              style: context.textTheme.bodyMedium,
            ),
            200.w,
          ),
          _buildCell(
            context,
            Text(record?.steps ?? '--', style: context.textTheme.bodyMedium),
            200.w,
          ),
          _buildCell(
            context,
            Text(
              record?.increment?.toString() ?? '----',
              style: context.textTheme.bodyMedium,
            ),
            200.w,
          ),
          _buildCell(
            context,
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              spacing: 8.w,
              children: [
                DigifyAssetButton(
                  assetPath: Assets.icons.editIcon.path,
                  onTap: onEdit,
                ),
                DigifyAssetButton(
                  assetPath: Assets.icons.redDeleteIcon.path,
                  onTap: onDelete,
                ),
              ],
            ),
            200.w,
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
