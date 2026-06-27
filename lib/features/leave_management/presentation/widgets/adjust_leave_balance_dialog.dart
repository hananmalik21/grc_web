import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/extensions/context_extensions.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/feedback/app_dialog.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart' show DigifyTextField, DigifyTextArea;
import 'package:grc/features/leave_management/domain/models/leave_balance.dart';
import 'package:grc/features/leave_management/domain/models/leave_balance_summary.dart';
import 'package:grc/features/leave_management/presentation/providers/leave_balances_provider.dart';
import 'package:grc/features/leave_management/domain/models/api_leave_type.dart';
import 'package:grc/features/leave_management/presentation/providers/leave_types_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/widgets/common/app_loading_indicator.dart';
import 'package:grc/core/utils/number_format_utils.dart';

class AdjustLeaveBalanceDialog extends ConsumerStatefulWidget {
  final LeaveBalanceSummaryItem item;
  final LeaveBalance? balance;

  const AdjustLeaveBalanceDialog({super.key, required this.item, this.balance});

  static Future<void> show(BuildContext context, {required LeaveBalanceSummaryItem item, LeaveBalance? balance}) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => AdjustLeaveBalanceDialog(item: item, balance: balance),
    );
  }

  @override
  ConsumerState<AdjustLeaveBalanceDialog> createState() => _AdjustLeaveBalanceDialogState();
}

class _AdjustLeaveBalanceDialogState extends ConsumerState<AdjustLeaveBalanceDialog> {
  final Map<int, TextEditingController> _controllers = {};
  late TextEditingController _reasonController;

  @override
  void initState() {
    super.initState();
    _reasonController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(employeeLeaveBalancesProvider(widget.item.employeeGuid));
      ref.read(leaveTypesNotifierProvider.notifier).loadLeaveTypes();
    });
  }

  void _initializeControllers(List<LeaveBalance> balances, List<ApiLeaveType> leaveTypes) {
    for (final type in leaveTypes) {
      if (!_controllers.containsKey(type.id)) {
        final balance = balances.where((b) => b.leaveTypeId == type.id).firstOrNull;

        final available = balance?.availableDays ?? 0.0;
        _controllers[type.id] = TextEditingController(text: NumberFormatUtils.formatDays(available));
      }
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    _reasonController.dispose();
    super.dispose();
  }

  void _submit() async {
    final values = _controllers.map((id, controller) => MapEntry(id, controller.text));
    final error = await ref
        .read(leaveBalancesNotifierProvider.notifier)
        .validateAndSubmit(
          employeeId: widget.item.employeeId,
          reason: _reasonController.text,
          controllerValues: values,
        );

    if (!mounted) return;

    if (error != null) {
      ToastService.warning(context, error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.theme.brightness == Brightness.dark;
    final leaveTypesState = ref.watch(leaveTypesNotifierProvider);
    final balancesState = ref.watch(leaveBalancesNotifierProvider);
    final isUpdating = balancesState.isUpdating;
    final asyncBalances = ref.watch(employeeLeaveBalancesProvider(widget.item.employeeGuid));
    final isLoading = asyncBalances.isLoading || leaveTypesState.isLoading;

    ref.listen<LeaveBalancesState>(leaveBalancesNotifierProvider, (previous, next) {
      if (previous?.isUpdating == true && next.isUpdating == false) {
        if (!mounted) return;
        if (next.updateError != null) {
          ToastService.error(context, next.updateError!);
        } else {
          context.pop();
          ToastService.success(context, 'Leave balances adjusted successfully');
        }
      }
    });

    return AppDialog(
      title: 'Adjust Leave Balance',
      subtitle: '${widget.item.employeeName} • ${widget.item.employeeNumber}',
      width: 700.w,
      content: isLoading
          ? Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 48.h),
                child: const AppLoadingIndicator(type: LoadingType.circle),
              ),
            )
          : asyncBalances.when(
              loading: () => const SizedBox.shrink(),
              error: (err, _) => Center(child: Text('Failed to load employee balances')),
              data: (balances) {
                _initializeControllers(balances, leaveTypesState.leaveTypes);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildLeaveBalanceFieldsRow(context),
                    Gap(14.h),
                    _buildComparisonSection(context, isDark, balances),
                    Gap(14.h),
                    _buildReasonField(context),
                  ],
                );
              },
            ),

      actions: [
        AppButton(
          label: localizations.cancel,
          type: AppButtonType.outline,
          onPressed: isUpdating ? null : () => context.pop(),
        ),
        Gap(12.w),
        AppButton(
          label: 'Update Balance',
          type: AppButtonType.primary,
          onPressed: isUpdating ? null : _submit,
          isLoading: isUpdating,
        ),
      ],
    );
  }

  Widget _buildLeaveBalanceFieldsRow(BuildContext context) {
    final leaveTypes = ref.watch(leaveTypesNotifierProvider).leaveTypes;

    return Wrap(
      spacing: 14.w,
      runSpacing: 14.h,
      children: leaveTypes.map((type) {
        final controller = _controllers[type.id];
        if (controller == null) return const SizedBox.shrink();

        return SizedBox(
          width: 319.w,
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

  Widget _buildComparisonSection(BuildContext context, bool isDark, List<LeaveBalance> balances) {
    final leaveTypes = ref.watch(leaveTypesNotifierProvider).leaveTypes;

    final labelStyle = context.textTheme.labelSmall?.copyWith(
      fontSize: 12.sp,
      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
    );
    final valueStyle = context.textTheme.labelSmall?.copyWith(
      fontSize: 12.sp,
      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
    );
    final newValueStyle = context.textTheme.labelSmall?.copyWith(fontSize: 12.sp, color: AppColors.primary);

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(color: AppColors.infoBg, borderRadius: BorderRadius.circular(7.r)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: leaveTypes.map((type) {
          final balance = balances.where((b) => b.leaveTypeId == type.id).firstOrNull;

          final previousValue = NumberFormatUtils.formatDays(balance?.availableDays ?? 0.0);

          final controller = _controllers[type.id];
          final newValue = controller?.text ?? '0';

          return Padding(
            padding: EdgeInsets.only(bottom: 6.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Previous ${type.nameEn}:', style: labelStyle),
                      Gap(7.w),
                      Text('$previousValue days', style: valueStyle),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('New ${type.nameEn}:', style: labelStyle),
                      Gap(7.w),
                      Text('${newValue.isEmpty ? '0' : newValue} days', style: newValueStyle),
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

  Widget _buildReasonField(BuildContext context) {
    return DigifyTextArea(
      controller: _reasonController,
      labelText: 'Adjustment Reason',
      hintText: 'E.g., Annual leave accrual, Manual correction, Carried forward from previous year...',
      isRequired: true,
      minLines: 3,
    );
  }
}
