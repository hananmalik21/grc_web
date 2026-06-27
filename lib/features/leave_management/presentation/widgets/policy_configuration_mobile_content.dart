import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/features/leave_management/domain/models/policy_list_item.dart';
import 'package:grc/features/leave_management/presentation/providers/abs_policies_provider.dart';
import 'package:grc/features/leave_management/presentation/providers/tab_lookups_providers.dart';
import 'package:grc/features/leave_management/presentation/widgets/policy_configuration/policy_configuration_mobile_details_sheet.dart';
import 'package:grc/features/leave_management/presentation/widgets/policy_configuration/leave_types_list_skeleton.dart';
import 'package:grc/features/leave_management/presentation/widgets/policy_configuration/policy_configuration_stat_cards.dart';
import 'package:grc/features/leave_management/presentation/widgets/policy_configuration/policy_list_content.dart';
import 'package:grc/features/leave_management/presentation/widgets/policy_configuration/policy_error_display.dart';
import 'package:grc/features/leave_management/presentation/widgets/policy_configuration/policy_configuration_mobile_logic_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class PolicyConfigurationMobileContent extends ConsumerStatefulWidget {
  const PolicyConfigurationMobileContent({
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

  @override
  ConsumerState<PolicyConfigurationMobileContent> createState() => _PolicyConfigurationMobileContentState();
}

class _PolicyConfigurationMobileContentState extends ConsumerState<PolicyConfigurationMobileContent>
    with PolicyConfigurationMobileLogicMixin {
  @override
  Future<void> openDetailsSheet(BuildContext context, PolicyListItem policy) async {
    await PolicyConfigurationMobileDetailsSheet.show(context, policy: policy);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final policiesAsync = ref.watch(policyConfigurationTabAbsPoliciesProvider);
    final notifierState = ref.watch(policyConfigurationTabAbsPoliciesNotifierProvider);
    final pagination = ref.watch(policyConfigurationTabAbsPoliciesPaginationProvider);
    ref.watch(policyConfigurationTabLookupsPreloadProvider);
    final selectedPolicy = ref.watch(policyConfigurationTabSelectedPolicyConfigurationProvider);

    handleSelectedPolicyCleanup(ref, context, selectedPolicy);

    return _PolicyListView(
      isDark: isDark,
      padding: widget.padding,
      sectionSpacing: widget.sectionSpacing,
      header: widget.header,
      enterpriseSelector: widget.enterpriseSelector,
      policiesAsync: policiesAsync,
      notifierState: notifierState,
      pagination: pagination,
      ref: ref,
      onPolicySelected: (policy) => openPolicyDetails(context, ref, policy),
    );
  }
}

class _PolicyListView extends StatelessWidget {
  const _PolicyListView({
    required this.isDark,
    required this.padding,
    required this.sectionSpacing,
    required this.header,
    required this.enterpriseSelector,
    required this.policiesAsync,
    required this.notifierState,
    required this.pagination,
    required this.ref,
    required this.onPolicySelected,
  });

  final bool isDark;
  final EdgeInsetsGeometry padding;
  final double sectionSpacing;
  final Widget header;
  final Widget enterpriseSelector;
  final AsyncValue<dynamic> policiesAsync;
  final AbsPoliciesState notifierState;
  final ({int page, int pageSize}) pagination;
  final WidgetRef ref;
  final Future<void> Function(PolicyListItem policy) onPolicySelected;

  @override
  Widget build(BuildContext context) {
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
            PolicyConfigurationStatCards(isDark: isDark),
            Gap(sectionSpacing),
            policiesAsync.when(
              loading: () => LeaveTypesListSkeleton(isDark: isDark, itemCount: 5),
              data: (paginated) => _buildList(context, paginated.policies),
              error: (e, _) => PolicyErrorDisplay(isDark: isDark, errorMessage: e.toString()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context, List<PolicyListItem> policies) {
    return PolicyListContent(
      isDark: isDark,
      policies: policies,
      onPolicySelected: onPolicySelected,
      paginationInfo: notifierState.data?.pagination,
      currentPage: pagination.page,
      pageSize: pagination.pageSize,
      onPrevious: pagination.page > 1 ? () => _goToPage(ref, pagination.page - 1) : null,
      onNext: _canGoNext() ? () => _goToPage(ref, pagination.page + 1) : null,
      isLoading: notifierState.isLoading,
    );
  }

  bool _canGoNext() {
    final meta = notifierState.data;
    if (meta == null || meta.policies.isEmpty) return false;
    return (pagination.page * pagination.pageSize) < meta.pagination.totalItems;
  }

  void _goToPage(WidgetRef ref, int page) {
    final currentPagination = ref.read(policyConfigurationTabAbsPoliciesPaginationProvider);
    ref.read(policyConfigurationTabAbsPoliciesPaginationProvider.notifier).state = (
      page: page,
      pageSize: currentPagination.pageSize,
    );
  }
}
