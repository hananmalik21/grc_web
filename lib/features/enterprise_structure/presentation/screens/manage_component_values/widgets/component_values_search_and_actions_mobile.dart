import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/buttons/app_mobile_button.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/enterprise_structure/presentation/screens/manage_component_values/manage_component_values_permission_mixin.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

final _componentValuesShowActionsProvider = StateProvider.autoDispose<bool>((ref) => false);

class ComponentValuesSearchAndActionsMobile extends ConsumerStatefulWidget {
  const ComponentValuesSearchAndActionsMobile({
    super.key,
    required this.isDark,
    required this.searchHint,
    required this.searchValue,
    required this.onSearchChanged,
    required this.addNewLabel,
    required this.bulkUploadLabel,
    required this.exportLabel,
    required this.onAddNew,
    required this.onBulkUpload,
    required this.onExport,
    this.isExporting = false,
  });

  final bool isDark;
  final String searchHint;
  final String searchValue;
  final ValueChanged<String> onSearchChanged;
  final String addNewLabel;
  final String bulkUploadLabel;
  final String exportLabel;
  final VoidCallback onAddNew;
  final VoidCallback onBulkUpload;
  final VoidCallback onExport;
  final bool isExporting;

  @override
  ConsumerState<ComponentValuesSearchAndActionsMobile> createState() => _ComponentValuesSearchAndActionsMobileState();
}

class _ComponentValuesSearchAndActionsMobileState extends ConsumerState<ComponentValuesSearchAndActionsMobile>
    with ManageComponentValuesPermissionMixin {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.searchValue);
  }

  @override
  void didUpdateWidget(ComponentValuesSearchAndActionsMobile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchValue != widget.searchValue && _controller.text != widget.searchValue) {
      _controller.text = widget.searchValue;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final showActions = ref.watch(_componentValuesShowActionsProvider);

    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: widget.isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: DigifyTextField.search(
                  controller: _controller,
                  hintText: widget.searchHint,
                  filled: true,
                  fillColor: widget.isDark ? AppColors.cardBackgroundGreyDark : AppColors.tableHeaderBackground,
                  borderColor: widget.isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
                  onChanged: widget.onSearchChanged,
                ),
              ),
              if (canCreateComponentValue) ...[
                Gap(8.w),
                AppMobileButton(
                  onPressed: widget.onAddNew,
                  svgPath: Assets.icons.addNewIconFigma.path,
                  backgroundColor: AppColors.primary,
                ),
              ],
              Gap(8.w),
              _ActionsToggleButton(
                isDark: widget.isDark,
                isActive: showActions,
                onTap: () => ref.read(_componentValuesShowActionsProvider.notifier).state = !showActions,
              ),
            ],
          ),
          if (showActions) ...[
            Gap(12.h),
            _ActionsPanel(
              isDark: widget.isDark,
              onBulkUpload: widget.onBulkUpload,
              onExport: widget.onExport,
              isExporting: widget.isExporting,
              canCreate: canCreateComponentValue,
            ),
          ],
        ],
      ),
    );
  }
}

class _ActionsToggleButton extends StatelessWidget {
  const _ActionsToggleButton({required this.isDark, required this.isActive, required this.onTap});

  final bool isDark;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderColor = isActive ? AppColors.primary : (isDark ? AppColors.cardBorderDark : AppColors.cardBorder);
    final bgColor = isActive
        ? AppColors.primary.withValues(alpha: 0.1)
        : (isDark ? AppColors.cardBackgroundDark : Colors.white);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: borderColor),
        ),
        child: Center(
          child: DigifyAsset(
            assetPath: Assets.icons.employeeManagement.filterMain.path,
            width: 18,
            height: 18,
            color: isActive ? AppColors.primary : null,
          ),
        ),
      ),
    );
  }
}

class _ActionsPanel extends StatelessWidget {
  const _ActionsPanel({
    required this.isDark,
    required this.onBulkUpload,
    required this.onExport,
    required this.canCreate,
    this.isExporting = false,
  });

  final bool isDark;
  final VoidCallback onBulkUpload;
  final VoidCallback onExport;
  final bool canCreate;
  final bool isExporting;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDark : AppColors.cardBackgroundGrey,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
      ),
      child: Wrap(
        spacing: 8.w,
        runSpacing: 8.h,
        children: [
          AppMobileButton(
            onPressed: onBulkUpload,
            svgPath: Assets.icons.bulkUploadIconFigma.path,
            backgroundColor: const Color(0xFF00A63E),
          ),
          AppMobileButton(
            onPressed: isExporting ? null : onExport,
            isLoading: isExporting,
            svgPath: Assets.icons.downloadIcon.path,
            backgroundColor: isDark ? AppColors.cardBackgroundGreyDark : const Color(0xFF4A5565),
          ),
        ],
      ),
    );
  }
}
