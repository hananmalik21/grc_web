import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/app_loading_indicator.dart';
import 'package:grc/core/widgets/common/digify_tab_header.dart';
import 'package:grc/core/widgets/common/enterprise_selector_widget.dart';
import 'package:grc/features/leave_management/domain/models/forfeit_policy.dart';
import 'package:grc/features/leave_management/presentation/providers/forfeit_policy_provider.dart';
import 'package:grc/features/leave_management/presentation/providers/forfeit_policy_tab_enterprise_provider.dart';
import 'package:grc/features/leave_management/presentation/widgets/forfeit_policy/forfeit_policies_list.dart';
import 'package:grc/features/leave_management/presentation/widgets/forfeit_policy/forfeit_policy_details_content.dart';
import 'package:grc/features/leave_management/presentation/widgets/forfeit_policy/forfeit_policy_stat_cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ForfeitPolicyTab extends ConsumerStatefulWidget {
  const ForfeitPolicyTab({super.key});

  @override
  ConsumerState<ForfeitPolicyTab> createState() => _ForfeitPolicyTabState();
}

class _ForfeitPolicyTabState extends ConsumerState<ForfeitPolicyTab> {
  ForfeitPolicy? _selectedForfeitPolicy;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final enterpriseId = ref.read(forfeitPolicyTabEnterpriseIdProvider);
      if (enterpriseId != null) {
        ref.read(forfeitPolicyNotifierProvider.notifier).refresh();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final isMobile = context.isMobile;
    final effectiveEnterpriseId = ref.watch(forfeitPolicyTabEnterpriseIdProvider);
    final forfeitPoliciesAsync = ref.watch(forfeitPoliciesProvider);

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 24.w).copyWith(bottom: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 21.h,
        children: [
          DigifyTabHeader(
            title: 'Forfeit Policy',
            description: 'Manage and configure forfeit policies for leave management.',
          ),
          EnterpriseSelectorWidget(
            selectedEnterpriseId: effectiveEnterpriseId,
            onEnterpriseChanged: (enterpriseId) {
              ref.read(forfeitPolicyTabSelectedEnterpriseProvider.notifier).setEnterpriseId(enterpriseId);
            },
          ),
          ForfeitPolicyStatCards(isDark: isDark),
          forfeitPoliciesAsync.when(
            data: (forfeitPolicies) {
              if (_selectedForfeitPolicy == null && forfeitPolicies.isNotEmpty) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  final selected = forfeitPolicies.firstWhere(
                    (fp) => fp.isSelected,
                    orElse: () => forfeitPolicies.first,
                  );
                  setState(() => _selectedForfeitPolicy = selected);
                });
              }
              if (forfeitPolicies.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(40.w),
                    child: Text(
                      'No forfeit policies found',
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                      ),
                    ),
                  ),
                );
              }
              if (isMobile) {
                return _buildMobileLayout(isDark, forfeitPolicies);
              } else {
                return _buildDesktopLayout(isDark, forfeitPolicies);
              }
            },
            loading: () => const Center(child: AppLoadingIndicator()),
            error: (error, stackTrace) => Center(
              child: Text(
                'Error loading forfeit policies: ${error.toString()}',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: isDark ? AppColors.errorTextDark : AppColors.errorText,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(bool isDark, List<ForfeitPolicy> forfeitPolicies) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16.h,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 300.h),
          child: ForfeitPoliciesList(
            forfeitPolicies: forfeitPolicies,
            isDark: isDark,
            selectedForfeitPolicy: _selectedForfeitPolicy,
            onForfeitPolicySelected: (forfeitPolicy) {
              setState(() {
                _selectedForfeitPolicy = forfeitPolicy;
              });
            },
          ),
        ),
        _buildForfeitPolicyDetailsContent(isDark),
      ],
    );
  }

  Widget _buildDesktopLayout(bool isDark, List<ForfeitPolicy> forfeitPolicies) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 350.w, maxHeight: 800.h),
          child: ForfeitPoliciesList(
            forfeitPolicies: forfeitPolicies,
            isDark: isDark,
            selectedForfeitPolicy: _selectedForfeitPolicy,
            onForfeitPolicySelected: (forfeitPolicy) {
              setState(() {
                _selectedForfeitPolicy = forfeitPolicy;
              });
            },
          ),
        ),
        Gap(21.w),
        Expanded(child: _buildForfeitPolicyDetailsContent(isDark)),
      ],
    );
  }

  Widget _buildForfeitPolicyDetailsContent(bool isDark) {
    return ForfeitPolicyDetailsContent(selectedForfeitPolicy: _selectedForfeitPolicy, isDark: isDark);
  }
}
