import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/widgets/common/digify_error_state.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/save_enterprise_structure_provider.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/structure_list_provider.dart';
import 'package:grc/features/enterprise_structure/presentation/widgets/manage_enterprise_structure/manage_enterprise_structure_widgets/mobile_structure_card_widget.dart';
import 'package:grc/features/enterprise_structure/presentation/widgets/manage_enterprise_structure/manage_enterprise_structure_widgets/structures_list_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class MobileStructuresListWidget extends ConsumerWidget {
  const MobileStructuresListWidget({
    super.key,
    required this.localizations,
    required this.isDark,
    required this.structureListProvider,
    required this.saveEnterpriseStructureProvider,
  });

  final AppLocalizations localizations;
  final bool isDark;
  final AutoDisposeStateNotifierProvider<StructureListNotifier, StructureListState> structureListProvider;
  final AutoDisposeStateNotifierProvider<SaveEnterpriseStructureNotifier, SaveEnterpriseStructureState>
  saveEnterpriseStructureProvider;

  StructureListViewState _viewStateFrom(StructureListState state) {
    if (state.isLoading && state.structures.isEmpty) {
      return StructureListViewState.initialLoading();
    }
    if (state.hasError && state.structures.isEmpty) {
      return StructureListViewState.error(state.errorMessage);
    }
    if (state.structures.isEmpty) {
      return StructureListViewState.empty();
    }
    return StructureListViewState.content(state);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listState = ref.watch(structureListProvider);
    final viewState = _viewStateFrom(listState);

    switch (viewState.type) {
      case StructureListViewStateType.initialLoading:
        return const StructuresListSkeleton(itemCount: 3);
      case StructureListViewStateType.error:
        return DigifyErrorState(
          message: localizations.somethingWentWrong,
          retryLabel: localizations.retry,
          onRetry: () => ref.read(structureListProvider.notifier).refresh(),
        );
      case StructureListViewStateType.empty:
        return Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardBackgroundDark : Colors.white,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Center(
            child: Text(
              localizations.noResultsFound,
              style: TextStyle(fontSize: 14.sp, color: isDark ? AppColors.textSecondaryDark : const Color(0xFF4A5565)),
            ),
          ),
        );
      case StructureListViewStateType.content:
        break;
    }

    if (listState.isLoadingMore || listState.isLoading) {
      return const StructuresListSkeleton(itemCount: 3);
    }

    final pagination = listState.pagination;
    final notifier = ref.read(structureListProvider.notifier);
    final dateFormat = DateFormat('yyyy-MM-dd');

    final cards = listState.structures.map((structure) {
      final activeLevels = structure.levels.where((l) => l.isActive).toList();
      final levelNames = activeLevels.map((l) => l.levelName).toList();
      final createdDate = dateFormat.format(structure.createdDate);
      final modifiedDate = structure.lastUpdatedDate != null
          ? dateFormat.format(structure.lastUpdatedDate!)
          : createdDate;

      return MobileStructureCardWidget(
        context: context,
        localizations: localizations,
        isDark: isDark,
        title: structure.structureName,
        description: structure.description,
        isActive: structure.isActive,
        levels: levelNames,
        levelCount: activeLevels.length,
        components: structure.orgUnitCount,
        employees: structure.employeeCount,
        created: createdDate,
        modified: modifiedDate,
        showInfoMessage: structure.isActive,
        structureLevels: structure.levels,
        enterpriseId: structure.enterpriseId,
        structureId: structure.structureId,
        structureListProvider: structureListProvider,
        saveEnterpriseStructureProvider: saveEnterpriseStructureProvider,
      );
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < cards.length; i++)
          Padding(
            padding: EdgeInsetsDirectional.only(bottom: i < cards.length - 1 ? 12.h : 0),
            child: cards[i],
          ),
        if (pagination != null) ...[
          Gap(16.h),
          PaginationControls(
            currentPage: listState.currentPage,
            totalPages: pagination.totalPages,
            totalItems: pagination.total,
            pageSize: pagination.pageSize,
            hasNext: pagination.hasNext,
            hasPrevious: pagination.hasPrevious,
            onPrevious: listState.hasPrevious ? () => notifier.goToPage(listState.currentPage - 1) : null,
            onNext: pagination.hasNext ? () => notifier.goToPage(listState.currentPage + 1) : null,
            style: PaginationStyle.simple,
          ),
        ],
      ],
    );
  }
}
