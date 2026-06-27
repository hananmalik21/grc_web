import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/extensions/context_extensions.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/feedback/delete_confirmation_dialog.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/payroll/application/element_entries/providers/element_entries_ui_provider.dart';
import 'package:grc/features/payroll/presentation/screens/element_entries/mixins/element_entries_permission_mixin.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ElementEntriesFilterBar extends ConsumerWidget with ElementEntriesPermissionMixin {
  const ElementEntriesFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final theme = context.theme;
    final uiState = ref.watch(elementEntriesUiProvider);
    final uiNotifier = ref.read(elementEntriesUiProvider.notifier);
    final hasSelection = uiState.hasSelection;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder.withValues(alpha: 0.1)),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(color: AppColors.infoBg, borderRadius: BorderRadius.circular(10.r)),
                      alignment: Alignment.center,
                      child: DigifyAsset(
                        assetPath: Assets.icons.payroll.filter.path,
                        color: AppColors.primary,
                        width: 20.w,
                        height: 20.w,
                      ),
                    ),
                    Gap(12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            loc.payrollManageElementEntries,
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontSize: 18.sp,
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                            ),
                          ),
                          Gap(2.h),
                          Text(
                            'Manage payroll earnings, deductions, and employee payroll elements.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: 13.sp,
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (canUpdateElementEntries) ...[
                  Gap(16.h),
                  AppButton.dangerOutline(
                    label: loc.delete,
                    svgPath: Assets.icons.deleteIconRed.path,
                    onPressed: hasSelection ? () => _onDeleteSelected(context, ref) : null,
                  ),
                ],
              ],
            ),
          ),
          Gap(16.w),
          SizedBox(
            width: 220.w,
            child: DigifyDateField(
              label: 'Effective Date',
              isRequired: false,
              initialDate: uiState.effectiveDate,
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
              onDateSelected: uiNotifier.setEffectiveDate,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onDeleteSelected(BuildContext context, WidgetRef ref) async {
    final loc = AppLocalizations.of(context)!;
    final uiState = ref.read(elementEntriesUiProvider);
    final selectedCount = uiState.selectedCount;

    if (selectedCount == 0) return;

    final itemName = selectedCount == 1 ? uiState.entries[uiState.selectedIndices.first].elementName : null;

    final confirmed = await DeleteConfirmationDialog.show(
      context,
      title: loc.payrollElementEntriesDeleteConfirmTitle,
      message: loc.payrollElementEntriesDeleteConfirmMessage(selectedCount),
      itemName: itemName,
    );

    if (confirmed != true || !context.mounted) return;

    ref.read(elementEntriesUiProvider.notifier).deleteSelected();
    ToastService.success(context, loc.payrollElementEntriesDeletedSuccess(selectedCount));
  }
}
