import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/features/leave_management/presentation/providers/abs_policies_provider.dart';
import 'package:grc/features/leave_management/presentation/widgets/leave_policies/leave_policies_filters_section.dart';
import 'package:grc/features/leave_management/presentation/widgets/leave_policies/leave_policies_mobile_filters_section.dart';
import 'package:grc/features/leave_management/presentation/widgets/leave_policies/leave_policies_stat_cards.dart';
import 'package:grc/features/leave_management/presentation/widgets/leave_policies/leave_policy_cards_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class LeavePoliciesContent extends ConsumerWidget {
  const LeavePoliciesContent({
    required this.padding,
    required this.sectionSpacing,
    required this.header,
    required this.enterpriseSelector,
    super.key,
  });

  final EdgeInsetsGeometry padding;
  final double sectionSpacing;
  final Widget header;
  final Widget enterpriseSelector;

  void _goToPage(WidgetRef ref, int page, int pageSize) {
    ref.read(leavePoliciesTabAbsPoliciesPaginationProvider.notifier).state = (page: page, pageSize: pageSize);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;

    final paginatedAsync = ref.watch(leavePoliciesTabAbsPoliciesProvider);
    final paginationState = ref.watch(leavePoliciesTabAbsPoliciesPaginationProvider);
    final notifierState = ref.watch(leavePoliciesTabAbsPoliciesNotifierProvider);
    final paginationInfo = paginatedAsync.valueOrNull?.pagination;

    return Container(
      color: isDark ? AppColors.backgroundDark : AppColors.background,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header,
            Gap(sectionSpacing),
            enterpriseSelector,
            Gap(sectionSpacing),
            LeavePoliciesStatCards(isDark: isDark),
            Gap(sectionSpacing),
            if (context.isMobile)
              LeavePoliciesMobileFiltersSection(localizations: localizations, isDark: isDark)
            else
              LeavePoliciesFiltersSection(localizations: localizations, isDark: isDark),
            Gap(sectionSpacing),
            LeavePolicyCardsGrid(localizations: localizations, isDark: isDark),
            if (paginationInfo != null) ...[
              Gap(sectionSpacing),
              PaginationControls.fromPaginationInfo(
                paginationInfo: paginationInfo,
                currentPage: paginationState.page,
                pageSize: paginationState.pageSize,
                isLoading: false,
                onPrevious: paginationInfo.hasPrevious && !notifierState.isLoading
                    ? () => _goToPage(ref, paginationState.page - 1, paginationState.pageSize)
                    : null,
                onNext: paginationInfo.hasNext && !notifierState.isLoading
                    ? () => _goToPage(ref, paginationState.page + 1, paginationState.pageSize)
                    : null,
                style: PaginationStyle.simple,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
