import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/utils/number_format_utils.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/app_loading_indicator.dart';
import 'package:grc/core/widgets/common/digify_bottom_sheet.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart' show DigifyTextField, DigifyTextArea;
import 'package:grc/features/leave_management/domain/models/leave_balance_summary.dart';
import 'package:grc/features/leave_management/presentation/providers/leave_balances_provider.dart';
import 'package:grc/features/leave_management/presentation/providers/leave_types_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AdjustLeaveBalanceMobileSheet {
  AdjustLeaveBalanceMobileSheet._();

  static Future<void> show(BuildContext context, {required LeaveBalanceSummaryItem item}) {
    return DigifyBottomSheet.show<void>(
      context,
      type: DigifyBottomSheetType.form,
      title: 'Adjust Leave Balance',
      barrierDismissible: false,
      child: _AdjustSheetBody(item: item),
    );
  }
}

class _AdjustSheetBody extends ConsumerStatefulWidget {
  const _AdjustSheetBody({required this.item});

  final LeaveBalanceSummaryItem item;

  @override
  ConsumerState<_AdjustSheetBody> createState() => _AdjustSheetBodyState();
}

class _AdjustSheetBodyState extends ConsumerState<_AdjustSheetBody> {
  final Map<int, TextEditingController> _controllers = {};
  late final TextEditingController _reasonController;

  @override
  void initState() {
    super.initState();
    _reasonController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(employeeLeaveBalancesProvider(widget.item.employeeGuid));
      ref.read(leaveTypesNotifierProvider.notifier).loadLeaveTypes();
    });
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    _reasonController.dispose();
    super.dispose();
  }

  void _initControllers(List balances, List leaveTypes) {
    for (final type in leaveTypes) {
      if (!_controllers.containsKey(type.id)) {
        final balance = balances.where((b) => b.leaveTypeId == type.id).firstOrNull;
        final available = balance?.availableDays ?? 0.0;
        _controllers[type.id] = TextEditingController(text: NumberFormatUtils.formatDays(available));
      }
    }
  }

  Future<void> _submit() async {
    final values = _controllers.map((id, c) => MapEntry(id, c.text));
    final error = await ref
        .read(leaveBalancesNotifierProvider.notifier)
        .validateAndSubmit(
          employeeId: widget.item.employeeId,
          reason: _reasonController.text,
          controllerValues: values,
        );
    if (!mounted) return;
    if (error != null) ToastService.warning(context, error);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final leaveTypesState = ref.watch(leaveTypesNotifierProvider);
    final balancesState = ref.watch(leaveBalancesNotifierProvider);
    final asyncBalances = ref.watch(employeeLeaveBalancesProvider(widget.item.employeeGuid));
    final isLoading = asyncBalances.isLoading || leaveTypesState.isLoading;
    final isUpdating = balancesState.isUpdating;

    ref.listen<LeaveBalancesState>(leaveBalancesNotifierProvider, (previous, next) {
      if (previous?.isUpdating == true && next.isUpdating == false) {
        if (!mounted) return;
        if (next.updateError != null) {
          ToastService.error(context, next.updateError!);
        } else {
          Navigator.of(context).pop();
          ToastService.success(context, 'Leave balances adjusted successfully');
        }
      }
    });

    return Column(
      children: [
        _EmployeeStrip(item: widget.item, isDark: isDark),
        const DigifyDivider.horizontal(),
        Expanded(
          child: isLoading
              ? const Center(child: AppLoadingIndicator(type: LoadingType.circle))
              : asyncBalances.when(
                  loading: () => const Center(child: AppLoadingIndicator(type: LoadingType.circle)),
                  error: (_, _) => Center(
                    child: Text(
                      'Failed to load balances',
                      style: TextStyle(color: AppColors.error, fontSize: 13.sp),
                    ),
                  ),
                  data: (balances) {
                    _initControllers(balances, leaveTypesState.leaveTypes);
                    return SingleChildScrollView(
                      padding: EdgeInsetsDirectional.fromSTEB(16.w, 16.h, 16.w, 16.h),
                      child: Skeletonizer(
                        enabled: isLoading,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLeaveTypeFields(leaveTypesState),
                            Gap(16.h),
                            _buildComparisonSection(context, isDark, balances, leaveTypesState),
                            Gap(16.h),
                            DigifyTextArea(
                              controller: _reasonController,
                              labelText: 'Adjustment Reason',
                              hintText:
                                  'E.g., Annual leave accrual, Manual correction, Carried forward from previous year...',
                              isRequired: true,
                              minLines: 3,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
        const DigifyDivider.horizontal(),
        _Footer(isUpdating: isUpdating, onCancel: () => Navigator.of(context).pop(), onSubmit: _submit),
      ],
    );
  }

  Widget _buildLeaveTypeFields(LeaveTypesState leaveTypesState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: leaveTypesState.leaveTypes.map((type) {
        final controller = _controllers[type.id];
        if (controller == null) return const SizedBox.shrink();
        return Padding(
          padding: EdgeInsets.only(bottom: 14.h),
          child: DigifyTextField.number(
            controller: controller,
            labelText: '${type.nameEn} (days)',
            isRequired: true,
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
            onChanged: (_) => setState(() {}),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildComparisonSection(BuildContext context, bool isDark, List balances, LeaveTypesState leaveTypesState) {
    final labelStyle = context.textTheme.labelSmall?.copyWith(
      fontSize: 11.sp,
      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
    );
    final valueStyle = context.textTheme.labelSmall?.copyWith(
      fontSize: 11.sp,
      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
    );
    final newValueStyle = context.textTheme.labelSmall?.copyWith(fontSize: 11.sp, color: AppColors.primary);

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(color: AppColors.infoBg, borderRadius: BorderRadius.circular(8.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: leaveTypesState.leaveTypes.map((type) {
          final balance = balances.where((b) => b.leaveTypeId == type.id).firstOrNull;
          final previous = NumberFormatUtils.formatDays(balance?.availableDays ?? 0.0);
          final newVal = _controllers[type.id]?.text ?? '0';

          return Padding(
            padding: EdgeInsets.only(bottom: 6.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Prev ${type.nameEn}:', style: labelStyle),
                      Gap(4.w),
                      Text('$previous days', style: valueStyle),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('New:', style: labelStyle),
                      Gap(4.w),
                      Text('${newVal.isEmpty ? '0' : newVal} days', style: newValueStyle),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _EmployeeStrip extends StatelessWidget {
  const _EmployeeStrip({required this.item, required this.isDark});

  final LeaveBalanceSummaryItem item;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '${item.employeeName.isEmpty ? '-' : item.employeeName}  ·  ${item.employeeNumber.isEmpty ? '-' : item.employeeNumber}',
              style: context.textTheme.bodySmall?.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                fontSize: 12.sp,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (item.department.isNotEmpty)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardBackgroundGreyDark : AppColors.cardBackgroundGrey,
                borderRadius: BorderRadius.circular(100.r),
              ),
              child: Text(
                item.department,
                style: context.textTheme.labelSmall?.copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.isUpdating, required this.onCancel, required this.onSubmit});

  final bool isUpdating;
  final VoidCallback onCancel;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.w, 12.h, 16.w, 14.h),
      child: Row(
        children: [
          Expanded(
            child: AppButton.outline(label: 'Cancel', onPressed: isUpdating ? null : onCancel, height: 46),
          ),
          Gap(8.w),
          Expanded(
            child: AppButton(
              label: 'Update Balance',
              type: AppButtonType.primary,
              onPressed: isUpdating ? null : onSubmit,
              isLoading: isUpdating,
              height: 46,
            ),
          ),
        ],
      ),
    );
  }
}
