import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/buttons/app_mobile_button.dart';
import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/security_manager/domain/models/security_module.dart';
import 'package:grc/features/security_manager/presentation/providers/function_roles/function_roles_provider.dart';
import 'package:grc/features/security_manager/presentation/providers/security_modules/security_modules_provider.dart';
import 'package:grc/features/security_manager/presentation/widgets/roles_management/roles_management_surface_card.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

final _showFiltersProvider = StateProvider.autoDispose<bool>((ref) => false);

class FunctionRolesSearchCardMobile extends ConsumerStatefulWidget {
  const FunctionRolesSearchCardMobile({super.key});

  @override
  ConsumerState<FunctionRolesSearchCardMobile> createState() => _FunctionRolesSearchCardMobileState();
}

class _FunctionRolesSearchCardMobileState extends ConsumerState<FunctionRolesSearchCardMobile> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: ref.read(functionRolesProvider).searchQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(functionRolesProvider);
    final notifier = ref.read(functionRolesProvider.notifier);
    final modules = ref.watch(securityModulesProvider).modules;
    final moduleItems = [null, ...modules.map((m) => m.moduleId)];
    final showFilters = ref.watch(_showFiltersProvider);
    final isDark = context.isDark;

    String moduleLabel(int? id) {
      if (id == null) return 'All Modules';
      final module = modules.cast<SecurityModule?>().firstWhere((m) => m?.moduleId == id, orElse: () => null);
      return module?.moduleName ?? 'Unknown Module';
    }

    return Container(
      decoration: BoxDecoration(boxShadow: AppShadows.primaryShadow),
      child: RolesManagementSurfaceCard(
        padding: EdgeInsets.all(12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: DigifyTextField.search(
                    controller: _searchController,
                    hintText: 'Search roles...',
                    filled: true,
                    fillColor: Colors.transparent,
                    onChanged: notifier.updateSearch,
                  ),
                ),
                Gap(8.w),
                AppMobileButton(
                  svgPath: Assets.icons.employeeManagement.filterMain.path,
                  type: AppButtonType.outline,
                  onPressed: () => ref.read(_showFiltersProvider.notifier).state = !showFilters,
                  backgroundColor: showFilters ? AppColors.primary.withValues(alpha: 0.1) : null,
                  borderColor: showFilters ? AppColors.primary : null,
                  foregroundColor: showFilters
                      ? AppColors.primary
                      : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary),
                ),
              ],
            ),
            if (showFilters) ...[
              Gap(16.h),
              Container(
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.backgroundDark : AppColors.cardBackgroundGrey,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 12.h,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Advanced Filters',
                          style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600, fontSize: 14.sp),
                        ),
                        GestureDetector(
                          onTap: () {
                            _searchController.clear();
                            notifier.updateSearch('');
                            notifier.updateModule(null);
                          },
                          child: Text(
                            'Reset',
                            style: context.textTheme.labelMedium?.copyWith(
                              color: AppColors.brandRed,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    DigifySelectFieldWithLabel<int?>(
                      label: 'Filter by Module',
                      value: state.selectedModuleId,
                      items: moduleItems,
                      itemLabelBuilder: moduleLabel,
                      onChanged: notifier.updateModule,
                      fillColor: Colors.transparent,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
