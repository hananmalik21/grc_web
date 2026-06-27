import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/badges/code_badge.dart';
import 'package:grc/core/widgets/buttons/action_button_widget.dart';
import 'package:grc/core/widgets/feedback/delete_confirmation_dialog.dart';
import 'package:grc/features/workforce_structure/data/config/job_levels_table_config.dart';
import 'package:grc/features/workforce_structure/domain/models/job_level.dart';
import 'package:grc/features/workforce_structure/presentation/providers/job_level_providers.dart';
import 'package:grc/features/workforce_structure/presentation/providers/job_levels_table_width_provider.dart';
import 'package:grc/features/workforce_structure/presentation/screens/job_levels/job_levels_permission_mixin.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/job_levels/job_level_detail_dialog.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/job_levels/job_level_form_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class JobLevelRow extends ConsumerWidget with JobLevelsPermissionMixin {
  final JobLevel level;

  const JobLevelRow({super.key, required this.level});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deletingId = ref.watch(
      jobLevelNotifierProvider.select((_) => ref.read(jobLevelNotifierProvider.notifier).deletingJobLevelId),
    );
    final isDeleting = deletingId == level.id;
    final widths = ref.watch(jobLevelsTableWidthsProvider);
    final textStyle = context.textTheme.labelMedium?.copyWith(fontSize: 14.sp, color: AppColors.dialogTitle);

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.cardBorder, width: 1.w),
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Row(
              children: [
                if (JobLevelsTableConfig.showLevelName) _buildDivider(widths.levelName),
                if (JobLevelsTableConfig.showCode) _buildDivider(widths.code),
                if (JobLevelsTableConfig.showDescription) _buildDivider(widths.description),
                if (JobLevelsTableConfig.showMinGrade) _buildDivider(widths.minGrade),
                if (JobLevelsTableConfig.showMaxGrade) _buildDivider(widths.maxGrade),
                if (JobLevelsTableConfig.showTotalPositions) _buildDivider(widths.totalPositions),
                if (JobLevelsTableConfig.showActions) _buildDivider(widths.actions, isLast: true),
              ],
            ),
          ),
          Row(
            children: [
              if (JobLevelsTableConfig.showLevelName)
                _buildDataCell(Text(level.nameEn, style: textStyle, overflow: TextOverflow.ellipsis), widths.levelName),
              if (JobLevelsTableConfig.showCode) _buildDataCell(CodeBadge(code: level.code.toUpperCase()), widths.code),
              if (JobLevelsTableConfig.showDescription)
                _buildDataCell(
                  Text(
                    level.description,
                    style: context.textTheme.bodySmall?.copyWith(fontSize: 14.sp, color: AppColors.tableHeaderText),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  widths.description,
                ),
              if (JobLevelsTableConfig.showMinGrade)
                _buildDataCell(
                  Text(level.minGrade?.gradeLabel ?? '-', style: textStyle, overflow: TextOverflow.ellipsis),
                  widths.minGrade,
                ),
              if (JobLevelsTableConfig.showMaxGrade)
                _buildDataCell(
                  Text(level.maxGrade?.gradeLabel ?? '-', style: textStyle, overflow: TextOverflow.ellipsis),
                  widths.maxGrade,
                ),
              if (JobLevelsTableConfig.showTotalPositions)
                _buildDataCell(
                  Text('${level.totalPositions}', style: textStyle, overflow: TextOverflow.ellipsis),
                  widths.totalPositions,
                ),
              if (JobLevelsTableConfig.showActions)
                _buildDataCell(
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    spacing: 8.w,
                    children: [
                      if (canViewJobLevel)
                        ActionButtonWidget(
                          type: ActionButtonType.view,
                          onTap: () => JobLevelDetailDialog.show(context, level),
                          width: 18.w,
                          height: 18.w,
                          padding: 6.w,
                          borderRadius: BorderRadius.circular(6.r),
                          customBorder: null,
                        ),
                      if (canUpdateJobLevel)
                        ActionButtonWidget(
                          type: ActionButtonType.edit,
                          onTap: () =>
                              JobLevelFormDialog.show(context, jobLevel: level, isEdit: true, onSave: (updated) {}),
                          width: 18.w,
                          height: 18.w,
                          padding: 6.w,
                          borderRadius: BorderRadius.circular(6.r),
                          customBorder: null,
                        ),
                      if (canDeleteJobLevel)
                        ActionButtonWidget(
                          type: ActionButtonType.delete,
                          onTap: isDeleting
                              ? null
                              : () async {
                                  final localizations = AppLocalizations.of(context)!;
                                  final confirmed = await DeleteConfirmationDialog.show(
                                    context,
                                    title: localizations.deleteJobLevel,
                                    message: localizations.deleteJobLevelConfirmationMessage,
                                    itemName: level.nameEn,
                                  );

                                  if (confirmed == true) {
                                    try {
                                      await ref.read(jobLevelNotifierProvider.notifier).deleteJobLevel(level.id);
                                      if (context.mounted) {
                                        ToastService.success(context, localizations.jobLevelDeletedSuccessfully);
                                      }
                                    } catch (e) {
                                      if (context.mounted) {
                                        ToastService.error(context, localizations.errorDeletingJobLevel);
                                      }
                                    }
                                  }
                                },
                          width: 18.w,
                          height: 18.w,
                          padding: 6.w,
                          borderRadius: BorderRadius.circular(6.r),
                          customBorder: null,
                        ),
                    ],
                  ),
                  widths.actions,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(double width, {bool isLast = false}) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                right: BorderSide(color: AppColors.cardBorder, width: 1.w),
              ),
      ),
    );
  }

  Widget _buildDataCell(Widget child, double width) {
    return Container(
      width: width,
      padding: EdgeInsetsDirectional.symmetric(horizontal: 20.w, vertical: 16.h),
      alignment: Alignment.centerLeft,
      child: child,
    );
  }
}
