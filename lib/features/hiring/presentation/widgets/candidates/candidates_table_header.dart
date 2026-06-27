import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/hiring/presentation/providers/candidates/candidates_table_width_provider.dart';
import 'package:grc/features/hiring/presentation/widgets/candidates/candidates_table_config.dart';
import 'package:grc/features/hiring/presentation/widgets/candidates/candidates_table_types.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CandidatesTableHeader extends ConsumerWidget {
  const CandidatesTableHeader({super.key, required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final state = ref.watch(candidatesTableWidthsProvider);
    final headerColor = isDark ? AppColors.cardBackgroundDark : AppColors.tableHeaderBackground;

    return Container(
      color: headerColor,
      child: Row(
        children: [
          ...state.columnOrder.map((column) {
            return _buildDraggableResizableHeaderCell(
              context,
              ref,
              column: column,
              label: _labelForColumn(column, loc),
              width: state.widthFor(column),
            );
          }),
          if (CandidatesTableConfig.showActions)
            _buildActionsHeaderCell(
              context,
              loc.hiringCandidatesTableColActions.toUpperCase(),
              CandidatesTableConfig.actionsWidth.w,
            ),
        ],
      ),
    );
  }

  String _labelForColumn(CandidatesTableColumn column, AppLocalizations loc) {
    return switch (column) {
      CandidatesTableColumn.candidate => loc.hiringCandidatesTableColCandidate.toUpperCase(),
      CandidatesTableColumn.currentRole => loc.hiringCandidatesTableColCurrentRole.toUpperCase(),
      CandidatesTableColumn.experience => loc.hiringCandidatesTableColExperience.toUpperCase(),
      CandidatesTableColumn.location => loc.hiringCandidatesTableColLocation.toUpperCase(),
      CandidatesTableColumn.rating => loc.hiringCandidatesTableColRating.toUpperCase(),
      CandidatesTableColumn.status => loc.hiringCandidatesTableColStatus.toUpperCase(),
    };
  }

  Widget _buildActionsHeaderCell(BuildContext context, String label, double width) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.cardBorder, width: 1.w),
        ),
      ),
      padding: EdgeInsetsDirectional.symmetric(horizontal: 20.w, vertical: 12.h),
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        style: context.textTheme.labelSmall?.copyWith(color: AppColors.tableHeaderText),
      ),
    );
  }

  Widget _buildDraggableResizableHeaderCell(
    BuildContext context,
    WidgetRef ref, {
    required CandidatesTableColumn column,
    required String label,
    required double width,
  }) {
    return DragTarget<CandidatesTableColumn>(
      onWillAcceptWithDetails: (details) => details.data != column,
      onAcceptWithDetails: (details) {
        ref.read(candidatesTableWidthsProvider.notifier).reorderColumn(details.data, column);
      },
      builder: (context, candidateData, rejectedData) {
        return LongPressDraggable<CandidatesTableColumn>(
          data: column,
          feedback: Material(
            color: Colors.transparent,
            child: Opacity(
              opacity: 0.9,
              child: ConstrainedBox(
                constraints: BoxConstraints.tightFor(width: width, height: 44.h),
                child: _buildResizableHeaderCell(context, ref, label: label, width: width, column: column),
              ),
            ),
          ),
          childWhenDragging: Opacity(
            opacity: 0.35,
            child: _buildResizableHeaderCell(context, ref, label: label, width: width, column: column),
          ),
          child: _buildResizableHeaderCell(context, ref, label: label, width: width, column: column),
        );
      },
    );
  }

  Widget _buildResizableHeaderCell(
    BuildContext context,
    WidgetRef ref, {
    required String label,
    required double width,
    required CandidatesTableColumn column,
  }) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: AppColors.cardBorder, width: 1.w),
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
              label,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: context.textTheme.labelSmall?.copyWith(color: AppColors.tableHeaderText),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            width: 15.w,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onHorizontalDragUpdate: (details) {
                ref.read(candidatesTableWidthsProvider.notifier).updateWidth(column, details.delta.dx);
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
