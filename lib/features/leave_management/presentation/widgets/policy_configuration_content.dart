import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/leave_management/domain/models/policy_list_item.dart';
import 'package:grc/features/leave_management/presentation/providers/abs_policies_provider.dart';
import 'package:grc/features/leave_management/presentation/providers/policy_draft_provider.dart';
import 'package:grc/features/leave_management/presentation/providers/policy_edit_mode_provider.dart';
import 'package:grc/features/leave_management/presentation/providers/tab_lookups_providers.dart';
import 'package:grc/features/leave_management/presentation/widgets/policy_configuration/policy_configuration_skeleton.dart';
import 'package:grc/features/leave_management/presentation/widgets/policy_configuration/policy_configuration_stat_cards.dart';
import 'package:grc/features/leave_management/presentation/widgets/policy_configuration/policy_details_content.dart';
import 'package:grc/features/leave_management/presentation/widgets/policy_configuration/policy_list_with_pagination.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class PolicyConfigurationContent extends ConsumerWidget {
  const PolicyConfigurationContent({
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

  static void _goToPage(WidgetRef ref, int page) {
    final pagination = ref.read(policyConfigurationTabAbsPoliciesPaginationProvider);
    ref.read(policyConfigurationTabAbsPoliciesPaginationProvider.notifier).state = (
      page: page,
      pageSize: pagination.pageSize,
    );
  }

  static void _onPolicyChange(WidgetRef ref, String? guid) {
    ref.read(policyDraftProvider.notifier).clear();
    ref.read(policyEditModeProvider.notifier).cancelEditing();
    ref.read(policyConfigurationTabSelectedPolicyGuidProvider.notifier).setSelectedPolicyGuid(guid);
  }

  static Widget _buildListWithPagination({
    required BuildContext context,
    required WidgetRef ref,
    required bool isDark,
    required List<PolicyListItem> policies,
    required ({int page, int pageSize}) pagination,
    required AbsPoliciesState notifierState,
    required BoxConstraints listConstraints,
    required PolicyListItem? selectedPolicy,
    required void Function(String?) onPolicySelected,
    double? width,
  }) {
    final meta = notifierState.data;
    final paginationInfo = meta != null && meta.policies.isNotEmpty ? meta.pagination : null;

    return PolicyListWithPagination(
      policies: policies,
      selectedPolicy: selectedPolicy,
      onPolicySelected: (p) => onPolicySelected(p.policyGuid),
      isDark: isDark,
      listConstraints: listConstraints,
      paginationInfo: paginationInfo,
      currentPage: pagination.page,
      pageSize: pagination.pageSize,
      onPrevious: () => _goToPage(ref, pagination.page - 1),
      onNext: () => _goToPage(ref, pagination.page + 1),
      isLoading: notifierState.isLoading,
      width: width,
    );
  }

  static Widget _buildMobileLayout(
    WidgetRef ref,
    BuildContext context,
    bool isDark,
    List<PolicyListItem> policies,
    ({int page, int pageSize}) pagination,
    AbsPoliciesState notifierState,
    PolicyListItem? selectedPolicy,
    void Function(String?) setSelectedGuid,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16.h,
      children: [
        _buildListWithPagination(
          context: context,
          ref: ref,
          isDark: isDark,
          policies: policies,
          pagination: pagination,
          notifierState: notifierState,
          listConstraints: BoxConstraints(maxHeight: 300.h),
          selectedPolicy: selectedPolicy,
          onPolicySelected: setSelectedGuid,
        ),
        PolicyDetailsContent(selectedPolicy: selectedPolicy, isDark: isDark),
      ],
    );
  }

  static Widget _buildDesktopLayout(
    WidgetRef ref,
    BuildContext context,
    bool isDark,
    List<PolicyListItem> policies,
    ({int page, int pageSize}) pagination,
    AbsPoliciesState notifierState,
    PolicyListItem? selectedPolicy,
    void Function(String?) setSelectedGuid,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildListWithPagination(
          context: context,
          ref: ref,
          isDark: isDark,
          policies: policies,
          pagination: pagination,
          notifierState: notifierState,
          listConstraints: BoxConstraints(maxHeight: 800.h),
          selectedPolicy: selectedPolicy,
          onPolicySelected: setSelectedGuid,
          width: 350.w,
        ),
        Gap(21.w),
        Expanded(
          child: PolicyDetailsContent(selectedPolicy: selectedPolicy, isDark: isDark),
        ),
      ],
    );
  }

  static Widget _buildError(BuildContext context, bool isDark, String message) {
    return Center(
      child: Text(
        'Error loading leave policies: $message',
        style: context.textTheme.bodyMedium?.copyWith(color: isDark ? AppColors.errorTextDark : AppColors.errorText),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final isMobile = context.isMobile;

    final policiesAsync = ref.watch(policyConfigurationTabAbsPoliciesProvider);
    final notifierState = ref.watch(policyConfigurationTabAbsPoliciesNotifierProvider);
    final pagination = ref.watch(policyConfigurationTabAbsPoliciesPaginationProvider);
    ref.watch(policyConfigurationTabLookupsPreloadProvider);
    final selectedPolicy = ref.watch(policyConfigurationTabSelectedPolicyConfigurationProvider);

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
              loading: () => PolicyConfigurationSkeleton(isDark: isDark, isMobile: isMobile),
              data: (paginated) => isMobile
                  ? _buildMobileLayout(
                      ref,
                      context,
                      isDark,
                      paginated.policies,
                      pagination,
                      notifierState,
                      selectedPolicy,
                      (guid) => _onPolicyChange(ref, guid),
                    )
                  : _buildDesktopLayout(
                      ref,
                      context,
                      isDark,
                      paginated.policies,
                      pagination,
                      notifierState,
                      selectedPolicy,
                      (guid) => _onPolicyChange(ref, guid),
                    ),
              error: (e, _) => _buildError(context, isDark, e.toString()),
            ),
          ],
        ),
      ),
    );
  }
}
