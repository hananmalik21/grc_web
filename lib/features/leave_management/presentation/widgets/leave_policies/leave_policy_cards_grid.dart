import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/leave_management/domain/models/leave_policy.dart';
import 'package:grc/features/leave_management/presentation/providers/abs_policies_provider.dart';
import 'package:grc/features/leave_management/presentation/widgets/leave_policies/components/leave_policy_card.dart';
import 'package:grc/features/leave_management/presentation/widgets/leave_policies/leave_policy_cards_grid_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LeavePolicyCardsGrid extends ConsumerWidget {
  final AppLocalizations localizations;
  final bool isDark;

  const LeavePolicyCardsGrid({super.key, required this.localizations, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final policiesAsync = ref.watch(leavePoliciesTabLeavePoliciesFromAbsProvider);

    return policiesAsync.when(
      data: (policies) {
        if (policies.isEmpty) {
          return Center(
            child: Text(
              localizations.noResultsFound,
              style: context.textTheme.bodyMedium?.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
              ),
            ),
          );
        }
        return _buildGrid(context, policies);
      },
      loading: () => LeavePolicyCardsGridSkeleton(isDark: isDark),
      error: (error, stackTrace) => Center(
        child: Text(
          'Error loading policies: ${error.toString()}',
          style: context.textTheme.bodyMedium?.copyWith(color: isDark ? AppColors.errorTextDark : AppColors.errorText),
        ),
      ),
    );
  }

  Widget _buildGrid(BuildContext context, List<LeavePolicy> policies) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final spacing = 20.w;
        final cardHeight = 263.h;
        final crossAxisCount = constraints.maxWidth < 600 ? 1 : 2;
        final availableWidth = constraints.maxWidth - (spacing * (crossAxisCount - 1));
        final cardWidth = availableWidth / crossAxisCount;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: spacing,
            mainAxisSpacing: 20.h,
            childAspectRatio: cardWidth / cardHeight,
          ),
          itemCount: policies.length,
          itemBuilder: (context, index) {
            final policy = policies[index];
            return LeavePolicyCard(policy: policy, isDark: isDark);
          },
        );
      },
    );
  }
}
