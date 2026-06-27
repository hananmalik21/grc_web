import 'dart:ui' as ui;
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/enums/time_management_enums.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_bottom_sheet.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/feedback/app_dialog.dart';
import 'package:grc/features/time_management/data/config/public_holidays_config.dart';
import 'package:grc/features/time_management/domain/models/public_holiday.dart';
import 'package:grc/features/time_management/presentation/providers/public_holidays_tab_enterprise_provider.dart';
import 'package:grc/features/time_management/presentation/widgets/public_holidays/components/holiday_type_badge.dart';
import 'package:grc/features/time_management/presentation/widgets/public_holidays/dialogs/create_holiday_dialog.dart';
import 'package:grc/features/time_management/presentation/widgets/public_holidays/public_holidays_permission_mixin.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class ViewHolidayDialog {
  static Future<void> show(BuildContext context, {required PublicHoliday holiday}) {
    if (context.isMobileLayout) {
      return DigifyBottomSheet.show<void>(
        context,
        type: DigifyBottomSheetType.custom,
        title: 'Holiday Details',
        child: Consumer(
          builder: (context, ref, _) => _ViewHolidaySheet(holiday: holiday, ref: ref),
        ),
      );
    }

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _ViewHolidayDialog(holiday: holiday),
    );
  }
}

// ── Mobile sheet ─────────────────────────────────────────────────────────────

class _ViewHolidaySheet extends StatelessWidget with PublicHolidaysPermissionMixin {
  const _ViewHolidaySheet({required this.holiday, required this.ref});

  final PublicHoliday holiday;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsetsDirectional.fromSTEB(16.w, 8.h, 16.w, 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SheetHeader(holiday: holiday, isDark: isDark),
                DigifyDivider(margin: EdgeInsets.symmetric(vertical: 16.h)),
                _InfoGrid(holiday: holiday, isDark: isDark),
                Gap(12.h),
                _DescriptionSection(holiday: holiday, isDark: isDark),
              ],
            ),
          ),
        ),
        if (canUpdatePublicHoliday)
          _EditFooter(
            onEdit: () {
              Navigator.of(context).pop();
              final enterpriseId = ref.read(publicHolidaysTabEnterpriseIdProvider);
              if (enterpriseId != null) {
                CreateHolidayDialog.show(context, enterpriseId: enterpriseId, holiday: holiday);
              }
            },
          )
        else
          const _CloseFooter(),
      ],
    );
  }
}

class _SheetHeader extends StatelessWidget {
  const _SheetHeader({required this.holiday, required this.isDark});

  final PublicHoliday holiday;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final day = holiday.date.day.toString().padLeft(2, '0');
    final month = DateFormat('MMM').format(holiday.date);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 52.w,
          height: 52.w,
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardBorderDark.withValues(alpha: 0.4) : AppColors.infoBg,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                day,
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.primary,
                ),
              ),
              Text(
                month,
                style: context.textTheme.labelSmall?.copyWith(
                  fontSize: 10.sp,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.primary,
                ),
              ),
            ],
          ),
        ),
        Gap(12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                holiday.nameEn,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.titleSmall?.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (holiday.nameAr.isNotEmpty) ...[
                Gap(3.h),
                Directionality(
                  textDirection: ui.TextDirection.rtl,
                  child: Text(
                    holiday.nameAr,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
              Gap(6.h),
              HolidayTypeBadge(type: holiday.type, paymentStatus: holiday.paymentStatus),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoGrid extends StatelessWidget {
  const _InfoGrid({required this.holiday, required this.isDark});

  final PublicHoliday holiday;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('d MMM yyyy').format(holiday.date);
    final typeLabel = PublicHolidaysConfig.getHolidayTypeDisplayName(holiday.type).toUpperCase();
    final paidLabel = holiday.paymentStatus == HolidayPaymentStatus.paid ? 'Yes' : 'No';
    final appliesToLabel = PublicHolidaysConfig.getAppliesToDisplayName(holiday.appliesTo) ?? holiday.appliesTo;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _InfoTile(label: 'Type', value: typeLabel, isDark: isDark),
            ),
            Gap(10.w),
            Expanded(
              child: _InfoTile(label: 'Paid Holiday', value: paidLabel, isDark: isDark),
            ),
          ],
        ),
        Gap(10.h),
        Row(
          children: [
            Expanded(
              child: _InfoTile(label: 'Date', value: formattedDate, isDark: isDark),
            ),
            Gap(10.w),
            Expanded(
              child: _InfoTile(label: 'Applies To', value: appliesToLabel, isDark: isDark),
            ),
          ],
        ),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.label, required this.value, required this.isDark});

  final String label;
  final String value;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final isEmpty = value.isEmpty || value == 'N/A' || value == '---';
    final textColor = isEmpty
        ? (isDark ? AppColors.textPlaceholderDark : AppColors.textPlaceholder)
        : (isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle);

    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundGreyDark : AppColors.tableHeaderBackground,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: context.textTheme.labelSmall?.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
            ),
          ),
          Gap(3.h),
          Text(
            isEmpty ? '---' : value,
            style: context.textTheme.labelMedium?.copyWith(color: textColor, fontWeight: FontWeight.w500),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _DescriptionSection extends StatelessWidget {
  const _DescriptionSection({required this.holiday, required this.isDark});

  final PublicHoliday holiday;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final hasEnDesc = holiday.descriptionEn.isNotEmpty;
    final hasArDesc = holiday.descriptionAr.isNotEmpty;
    if (!hasEnDesc && !hasArDesc) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundGreyDark : AppColors.tableHeaderBackground,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: context.textTheme.labelSmall?.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
            ),
          ),
          if (hasEnDesc) ...[
            Gap(6.h),
            Text(
              holiday.descriptionEn,
              style: context.textTheme.bodySmall?.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle,
                height: 1.5,
              ),
            ),
          ],
          if (hasArDesc) ...[
            Gap(6.h),
            Directionality(
              textDirection: ui.TextDirection.rtl,
              child: Text(
                holiday.descriptionAr,
                style: context.textTheme.bodySmall?.copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _EditFooter extends StatelessWidget {
  const _EditFooter({required this.onEdit});

  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const DigifyDivider.horizontal(),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(16.w, 12.h, 16.w, 14.h),
          child: Row(
            children: [
              AppButton.outline(label: 'Close', onPressed: () => Navigator.of(context).pop(), height: 46),
              Gap(10.w),
              Expanded(
                child: AppButton(
                  label: 'Edit Holiday',
                  svgPath: Assets.icons.editIcon.path,
                  onPressed: onEdit,
                  backgroundColor: AppColors.greenButton,
                  height: 46,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CloseFooter extends StatelessWidget {
  const _CloseFooter();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const DigifyDivider.horizontal(),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(16.w, 12.h, 16.w, 14.h),
          child: SizedBox(
            width: double.infinity,
            child: AppButton.outline(label: 'Close', onPressed: () => Navigator.of(context).pop(), height: 46),
          ),
        ),
      ],
    );
  }
}

// ── Desktop / tablet dialog ───────────────────────────────────────────────────

class _ViewHolidayDialog extends StatelessWidget {
  const _ViewHolidayDialog({required this.holiday});

  final PublicHoliday holiday;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final formattedDate = DateFormat('EEEE, d MMMM yyyy').format(holiday.date);

    return AppDialog(
      title: 'Holiday Details',
      width: 672.w,
      onClose: () => Navigator.of(context).pop(),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: _DialogInfoCard(label: 'Holiday Name', value: holiday.nameEn, isDark: isDark),
              ),
              Gap(16.w),
              Expanded(
                child: _DialogInfoCard(label: 'اسم العطلة', value: holiday.nameAr, isDark: isDark, isRtl: true),
              ),
            ],
          ),
          Gap(16.h),
          SizedBox(
            width: double.infinity,
            child: _DialogInfoCard(label: 'Date', value: formattedDate, isDark: isDark),
          ),
          Gap(16.h),
          Row(
            children: [
              Expanded(
                child: _DialogInfoCard(
                  label: 'Type',
                  value: PublicHolidaysConfig.getHolidayTypeDisplayName(holiday.type).toUpperCase(),
                  isDark: isDark,
                ),
              ),
              Gap(16.w),
              Expanded(
                child: _DialogInfoCard(
                  label: 'Paid Holiday',
                  value: holiday.paymentStatus == HolidayPaymentStatus.paid ? 'Yes' : 'No',
                  isDark: isDark,
                ),
              ),
            ],
          ),
          Gap(16.h),
          SizedBox(
            width: double.infinity,
            child: _DialogDescriptionCard(
              label: 'Description',
              valueEn: holiday.descriptionEn,
              valueAr: holiday.descriptionAr,
              isDark: isDark,
            ),
          ),
          Gap(16.h),
          SizedBox(
            width: double.infinity,
            child: _DialogInfoCard(
              label: 'Applies To',
              value: PublicHolidaysConfig.getAppliesToDisplayName(holiday.appliesTo) ?? holiday.appliesTo.toLowerCase(),
              isDark: isDark,
            ),
          ),
        ],
      ),
    );
  }
}

class _DialogInfoCard extends StatelessWidget {
  const _DialogInfoCard({required this.label, required this.value, required this.isDark, this.isRtl = false});

  final String label;
  final String value;
  final bool isDark;
  final bool isRtl;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.inputBgDark : AppColors.inputBg,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: context.textTheme.bodySmall?.copyWith(
              fontSize: 13.6.sp,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
            ),
          ),
          Gap(8.h),
          Directionality(
            textDirection: isRtl ? ui.TextDirection.rtl : ui.TextDirection.ltr,
            child: Text(
              value,
              style: context.textTheme.titleSmall?.copyWith(
                fontSize: 15.6.sp,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DialogDescriptionCard extends StatelessWidget {
  const _DialogDescriptionCard({
    required this.label,
    required this.valueEn,
    required this.valueAr,
    required this.isDark,
  });

  final String label;
  final String valueEn;
  final String valueAr;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.inputBgDark : AppColors.inputBg,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: context.textTheme.bodySmall?.copyWith(
              fontSize: 13.6.sp,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
            ),
          ),
          Gap(8.h),
          Text(
            valueEn,
            style: context.textTheme.titleSmall?.copyWith(
              fontSize: 15.6.sp,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            ),
          ),
          Gap(8.h),
          Directionality(
            textDirection: ui.TextDirection.rtl,
            child: Text(
              valueAr,
              style: context.textTheme.titleSmall?.copyWith(
                fontSize: 15.6.sp,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
