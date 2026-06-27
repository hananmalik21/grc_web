import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/org_units_tree_provider.dart';
import 'package:grc/features/enterprise_structure/presentation/widgets/manage_enterprise_structure/manage_enterprise_structure_widgets/org_tree/widgets/org_tree_header.dart';
import 'package:grc/features/enterprise_structure/presentation/widgets/manage_enterprise_structure/manage_enterprise_structure_widgets/org_tree/widgets/org_tree_skeleton.dart';
import 'package:grc/features/enterprise_structure/presentation/widgets/manage_enterprise_structure/manage_enterprise_structure_widgets/org_tree/widgets/org_unit_tree_node_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class OrgUnitsTreeWidget extends ConsumerWidget {
  const OrgUnitsTreeWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final treeState = ref.watch(orgUnitsTreeProvider);
    final treeAsync = treeState.tree;
    final expandedNodes = treeState.expandedNodes;
    final notifier = ref.read(orgUnitsTreeProvider.notifier);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.cardShadow,
      ),
      child: treeAsync.when(
        data: (tree) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OrgTreeHeader(onExpandAll: notifier.expandAll, onCollapseAll: notifier.collapseAll, isDark: isDark),
            Container(
              padding: const EdgeInsetsDirectional.all(16),
              margin: EdgeInsets.symmetric(horizontal: 24.w).copyWith(bottom: 24.h),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.categoryBadgeBorder),
                borderRadius: BorderRadius.circular(10.r),
              ),
              constraints: const BoxConstraints(minHeight: 500),
              child: tree.tree.isEmpty
                  ? Center(
                      child: Padding(
                        padding: EdgeInsets.all(24.w),
                        child: Text(
                          'No components found',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...tree.tree.map((node) {
                          return OrgUnitTreeNodeWidget(
                            node: node,
                            expandedNodes: expandedNodes,
                            onToggle: notifier.toggleNode,
                            isDark: isDark,
                            level: 0,
                          );
                        }),
                      ],
                    ),
            ),
          ],
        ),
        loading: () => OrgTreeSkeleton(isDark: isDark),
        error: (error, stack) =>
            _buildErrorState(context, error, isDark, () => ref.read(orgUnitsTreeProvider.notifier).refresh()),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, Object error, bool isDark, VoidCallback onRetry) {
    return Padding(
      padding: EdgeInsets.all(24.w),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48.sp, color: AppColors.error),
            const Gap(16),
            Text(
              'Failed to load tree',
              style: context.textTheme.titleMedium?.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
              ),
            ),
            const Gap(8),
            Text(
              error.toString(),
              style: context.textTheme.bodySmall?.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const Gap(16),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
