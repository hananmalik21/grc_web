import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/enterprise_structure/presentation/screens/manage_component_values/manage_component_values_permission_mixin.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ComponentValuesSearchAndActions extends ConsumerStatefulWidget {
  const ComponentValuesSearchAndActions({
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
  ConsumerState<ComponentValuesSearchAndActions> createState() => _ComponentValuesSearchAndActionsState();
}

class _ComponentValuesSearchAndActionsState extends ConsumerState<ComponentValuesSearchAndActions>
    with ManageComponentValuesPermissionMixin {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.searchValue);
  }

  @override
  void didUpdateWidget(ComponentValuesSearchAndActions oldWidget) {
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
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: widget.isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: DigifyTextField.search(
              controller: _controller,
              hintText: widget.searchHint,
              onChanged: widget.onSearchChanged,
            ),
          ),
          Gap(16.w),
          if (canCreateComponentValue) ...[
            AppButton(
              label: widget.addNewLabel,
              onPressed: widget.onAddNew,
              svgPath: Assets.icons.addNewIconFigma.path,
              backgroundColor: AppColors.primary,
            ),
            Gap(12.w),
          ],
          AppButton(
            label: widget.bulkUploadLabel,
            onPressed: widget.onBulkUpload,
            svgPath: Assets.icons.bulkUploadIconFigma.path,
            backgroundColor: AppColors.shiftUploadButton,
          ),
          Gap(12.w),
          AppButton(
            label: widget.exportLabel,
            onPressed: widget.isExporting ? null : widget.onExport,
            isLoading: widget.isExporting,
            svgPath: Assets.icons.downloadIcon.path,
            backgroundColor: widget.isDark ? AppColors.cardBackgroundGreyDark : AppColors.shiftExportButton,
          ),
        ],
      ),
    );
  }
}
