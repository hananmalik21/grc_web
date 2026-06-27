import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/workforce_structure/data/config/job_levels_table_config.dart';
import 'package:grc/features/workforce_structure/presentation/providers/job_levels_table_width_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class JobLevelTableHeader extends ConsumerWidget {
  final bool isDark;

  const JobLevelTableHeader({super.key, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final headerColor = isDark ? AppColors.cardBackgroundDark : AppColors.tableHeaderBackground;
    final l10n = AppLocalizations.of(context)!;
    final widths = ref.watch(jobLevelsTableWidthsProvider);
    final headerCells = <Widget>[];

    if (JobLevelsTableConfig.showLevelName) {
      headerCells.add(
        _buildResizableHeaderCell(context, 'Level Name', widths.levelName, JobLevelColumn.levelName, ref),
      );
    }
    if (JobLevelsTableConfig.showCode) {
      headerCells.add(_buildResizableHeaderCell(context, 'Code', widths.code, JobLevelColumn.code, ref));
    }
    if (JobLevelsTableConfig.showDescription) {
      headerCells.add(
        _buildResizableHeaderCell(context, 'Description', widths.description, JobLevelColumn.description, ref),
      );
    }
    if (JobLevelsTableConfig.showMinGrade) {
      headerCells.add(
        _buildResizableHeaderCell(context, l10n.minimumGrade, widths.minGrade, JobLevelColumn.minGrade, ref),
      );
    }
    if (JobLevelsTableConfig.showMaxGrade) {
      headerCells.add(
        _buildResizableHeaderCell(context, l10n.maximumGrade, widths.maxGrade, JobLevelColumn.maxGrade, ref),
      );
    }
    if (JobLevelsTableConfig.showTotalPositions) {
      headerCells.add(
        _buildResizableHeaderCell(context, 'Position Count', widths.totalPositions, JobLevelColumn.totalPositions, ref),
      );
    }
    if (JobLevelsTableConfig.showActions) {
      headerCells.add(
        _buildResizableHeaderCell(context, 'Actions', widths.actions, JobLevelColumn.actions, ref, isLast: true),
      );
    }

    return Container(
      color: headerColor,
      child: Row(children: headerCells),
    );
  }

  Widget _buildResizableHeaderCell(
    BuildContext context,
    String text,
    double width,
    JobLevelColumn columnKey,
    WidgetRef ref, {
    bool isLast = false,
  }) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: isLast ? Colors.transparent : AppColors.cardBorder, width: 1.w),
          bottom: BorderSide(color: AppColors.cardBorder, width: 1.w),
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: EdgeInsetsDirectional.symmetric(horizontal: 20.w, vertical: 12.h),
            alignment: Alignment.centerLeft,
            child: Text(
              text.toUpperCase(),
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.labelSmall?.copyWith(color: AppColors.tableHeaderText),
            ),
          ),
          if (!isLast)
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              width: 15.w,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onHorizontalDragUpdate: (details) {
                  ref.read(jobLevelsTableWidthsProvider.notifier).updateWidth(columnKey, details.delta.dx);
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.resizeColumn,
                  child: Container(color: Colors.transparent),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
