import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/org_units_tree_provider.dart';
import 'package:grc/features/enterprise_structure/presentation/widgets/manage_enterprise_structure/manage_enterprise_structure_widgets/org_tree/widgets/mobile_org_tree_header.dart';
import 'package:grc/features/enterprise_structure/presentation/widgets/manage_enterprise_structure/manage_enterprise_structure_widgets/org_tree/widgets/mobile_org_unit_tree_node_widget.dart';
import 'package:grc/features/enterprise_structure/presentation/widgets/manage_enterprise_structure/manage_enterprise_structure_widgets/org_tree/widgets/org_tree_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class MobileOrgUnitsTreeWidget extends ConsumerWidget {
  const MobileOrgUnitsTreeWidget({super.key});

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
            MobileOrgTreeHeader(onExpandAll: notifier.expandAll, onCollapseAll: notifier.collapseAll, isDark: isDark),
            Container(
              width: double.infinity,
              padding: const EdgeInsetsDirectional.all(12),
              margin: EdgeInsets.symmetric(horizontal: 12.w).copyWith(bottom: 16.h),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.categoryBadgeBorder),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: tree.tree.isEmpty
                  ? Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Center(
                        child: Text(
                          'No components found',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: tree.tree.map((node) {
                          return MobileOrgUnitTreeNodeWidget(
                            node: node,
                            expandedNodes: expandedNodes,
                            onToggle: notifier.toggleNode,
                            isDark: isDark,
                            level: 0,
                          );
                        }).toList(),
                      ),
                    ),
            ),
          ],
        ),
        loading: () => OrgTreeSkeleton(isDark: isDark),
        error: (error, stack) => _MobileTreeError(
          error: error,
          isDark: isDark,
          onRetry: () => ref.read(orgUnitsTreeProvider.notifier).refresh(),
        ),
      ),
    );
  }
}

class _MobileTreeError extends StatelessWidget {
  final Object error;
  final bool isDark;
  final VoidCallback onRetry;

  const _MobileTreeError({required this.error, required this.isDark, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 40.sp, color: AppColors.error),
            const Gap(12),
            Text(
              'Failed to load tree',
              style: context.textTheme.titleSmall?.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
              ),
            ),
            const Gap(6),
            Text(
              error.toString(),
              style: context.textTheme.bodySmall?.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const Gap(12),
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
