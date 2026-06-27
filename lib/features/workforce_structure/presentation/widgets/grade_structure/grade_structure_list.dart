import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/widgets/common/digify_error_state.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/features/time_management/domain/models/pagination_info.dart';
import 'package:grc/features/workforce_structure/presentation/providers/grade_providers.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/grade_structure/grade_structure_card.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/grade_structure/grade_structure_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class GradeStructureList extends ConsumerWidget {
  const GradeStructureList({super.key, required this.localizations, required this.isDark});

  final AppLocalizations localizations;
  final bool isDark;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gradeState = ref.watch(gradeNotifierProvider);
    final grades = gradeState.items;

    if (gradeState.isLoading) {
      return const GradeStructureSkeleton();
    }

    if (gradeState.errorMessage != null && grades.isEmpty) {
      return DigifyErrorState(
        message: gradeState.errorMessage!,
        onRetry: () => ref.read(gradeNotifierProvider.notifier).refresh(),
      );
    }

    if (grades.isEmpty) {
      return _GradeStructureEmptyState(localizations: localizations);
    }

    return Column(
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(minHeight: 500.h),
          child: Column(
            children: grades.map((grade) {
              return Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: GradeStructureCard(grade: grade),
              );
            }).toList(),
          ),
        ),
        if (gradeState.totalPages > 0) ...[
          Gap(20.h),
          PaginationControls.fromPaginationInfo(
            paginationInfo: PaginationInfo(
              currentPage: gradeState.currentPage,
              totalPages: gradeState.totalPages,
              totalItems: gradeState.totalItems,
              pageSize: gradeState.pageSize,
              hasNext: gradeState.hasNextPage,
              hasPrevious: gradeState.hasPreviousPage,
            ),
            currentPage: gradeState.currentPage,
            pageSize: gradeState.pageSize,
            onPrevious: gradeState.hasPreviousPage
                ? () => ref.read(gradeNotifierProvider.notifier).goToPage(gradeState.currentPage - 1)
                : null,
            onNext: gradeState.hasNextPage
                ? () => ref.read(gradeNotifierProvider.notifier).goToPage(gradeState.currentPage + 1)
                : null,
            isLoading: gradeState.isLoading,
            style: PaginationStyle.simple,
          ),
        ],
      ],
    );
  }
}

class _GradeStructureEmptyState extends StatelessWidget {
  const _GradeStructureEmptyState({required this.localizations});

  final AppLocalizations localizations;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 500.h),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 64.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.workspace_premium_outlined, size: 64.sp, color: AppColors.textSecondary),
              SizedBox(height: 16.h),
              Text(
                localizations.noResultsFound,
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
              ),
              SizedBox(height: 8.h),
              Text(
                localizations.tryAdjustingFilters,
                style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
