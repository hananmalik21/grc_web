import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/enterprise_selector_widget.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/core/widgets/feedback/table_empty_state.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/developer_tools/domain/models/security_function.dart';
import 'package:grc/features/developer_tools/presentation/models/function_item.dart';
import 'package:grc/features/developer_tools/presentation/providers/function_management_enterprise_provider.dart';
import 'package:grc/features/developer_tools/presentation/providers/function_management_provider.dart';
import 'package:grc/features/developer_tools/presentation/widgets/function_management/create_function_dialog.dart';
import 'package:grc/features/developer_tools/presentation/widgets/function_management/function_management_header.dart';
import 'package:grc/features/developer_tools/presentation/widgets/function_management/function_tile.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class FunctionManagementScreen extends ConsumerStatefulWidget {
  const FunctionManagementScreen({super.key});

  static final _skeletonItems = List.generate(6, (_) => FunctionItem.fromSecurityFunction(skeletonSecurityFunction));

  @override
  ConsumerState<FunctionManagementScreen> createState() => _FunctionManagementScreenState();
}

class _FunctionManagementScreenState extends ConsumerState<FunctionManagementScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(functionManagementProvider.notifier).refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenPadding = ResponsiveHelper.getScreenPadding(context);
    final topPadding = ResponsiveHelper.getResponsiveHeight(context, mobile: 16, tablet: 20, web: 20);
    final sectionSpacing = ResponsiveHelper.getTabSectionSpacing(context);
    final searchToListSpacing = ResponsiveHelper.getResponsiveHeight(context, mobile: 12, tablet: 14, web: 16);
    final listItemSpacing = ResponsiveHelper.getResponsiveHeight(context, mobile: 8, tablet: 9, web: 10);

    final effectiveEnterpriseId = ref.watch(functionManagementEnterpriseIdProvider);
    final state = ref.watch(functionManagementProvider);
    final notifier = ref.read(functionManagementProvider.notifier);

    final displayItems = state.isLoading && state.functions.isEmpty
        ? FunctionManagementScreen._skeletonItems
        : state.functions.map(FunctionItem.fromSecurityFunction).toList();

    return Padding(
      padding: screenPadding.copyWith(top: topPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FunctionManagementHeader(onCreatePressed: () async => CreateFunctionDialog.show(context)),
            Gap(sectionSpacing),
            EnterpriseSelectorWidget(
              selectedEnterpriseId: effectiveEnterpriseId,
              onEnterpriseChanged: (id) {
                ref.read(functionManagementSelectedEnterpriseProvider.notifier).setEnterpriseId(id);
                ref.read(functionManagementProvider.notifier).refresh();
              },
            ),
            Gap(sectionSpacing),
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: context.isDark ? AppColors.cardBackgroundDark : Colors.white,
                borderRadius: BorderRadius.circular(10.r),
                boxShadow: AppShadows.primaryShadow,
              ),
              child: DigifyTextField.search(hintText: 'Search functions...', onChanged: notifier.updateSearch),
            ),
            Gap(searchToListSpacing),
            if (state.error != null && !state.isLoading) _ErrorBanner(message: state.error!, onRetry: notifier.refresh),
            ConstrainedBox(
              constraints: BoxConstraints(minHeight: 500.h),
              child: state.isLoading
                  ? Skeletonizer(
                      enabled: true,
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: displayItems.length,
                        separatorBuilder: (_, _) => Gap(listItemSpacing),
                        itemBuilder: (context, index) => FunctionTile(function: displayItems[index]),
                      ),
                    )
                  : displayItems.isEmpty
                  ? TableEmptyState(
                      iconPath: Assets.icons.developerTools.moduleManagement.path,
                      title: 'No Functions Found',
                      message: 'There are no functions matching your current criteria.',
                      height: 500.h,
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: displayItems.length,
                      separatorBuilder: (_, _) => Gap(listItemSpacing),
                      itemBuilder: (context, index) => FunctionTile(function: displayItems[index]),
                    ),
            ),
            Gap(sectionSpacing),
            PaginationControls(
              currentPage: state.safeCurrentPage,
              totalPages: state.totalPages,
              totalItems: state.totalItems,
              pageSize: state.effectivePageSize,
              hasNext: state.hasNext,
              hasPrevious: state.hasPrevious,
              isLoading: false,
              onPrevious: state.hasPrevious && !state.isLoading ? notifier.previousPage : null,
              onNext: state.hasNext && !state.isLoading ? notifier.nextPage : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(message, style: const TextStyle(color: Colors.red, fontSize: 13)),
          ),
          TextButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
