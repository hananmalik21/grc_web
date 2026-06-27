import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/features/hiring/application/applications/mappers/application_table_row_mapper.dart';
import 'package:grc/features/hiring/domain/models/applications/application.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class CreateOfferApplicationDetailsPanel extends StatelessWidget {
  const CreateOfferApplicationDetailsPanel({super.key, required this.application});

  final Application application;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final primaryText = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final secondaryText = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final row = toApplicationTableRowData(application);
    final appliedDateLabel = application.appliedDate == null
        ? '—'
        : DateFormat.yMMMd().format(application.appliedDate!);
    final requisitionLabel = application.requisitionNumber.isNotEmpty
        ? '${application.requisitionNumber} • ${application.requisitionTitle}'
        : application.requisitionTitle;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundGreyDark : AppColors.cardBackgroundGrey,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Application Summary',
            style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600, color: primaryText),
          ),
          Gap(16.h),
          _buildResponsiveRow(
            context: context,
            children: [
              _DetailItem(
                label: 'Application Number',
                value: application.applicationNumber,
                primaryText: primaryText,
                secondaryText: secondaryText,
              ),
              _DetailItem(
                label: 'Applied Date',
                value: appliedDateLabel,
                primaryText: primaryText,
                secondaryText: secondaryText,
              ),
            ],
          ),
          Gap(16.h),
          _buildResponsiveRow(
            context: context,
            children: [
              _DetailItem(
                label: 'Job Posting',
                value: application.postingTitle,
                primaryText: primaryText,
                secondaryText: secondaryText,
              ),
              _DetailItem(
                label: 'Requisition',
                value: requisitionLabel,
                primaryText: primaryText,
                secondaryText: secondaryText,
              ),
            ],
          ),
          Gap(16.h),
          _buildResponsiveRow(
            context: context,
            children: [
              _StatusDetailItem(
                label: 'Current Stage',
                status: row.currentStage,
                primaryText: primaryText,
                secondaryText: secondaryText,
              ),
              _StatusDetailItem(
                label: 'Status',
                status: row.status,
                primaryText: primaryText,
                secondaryText: secondaryText,
              ),
            ],
          ),
          Gap(16.h),
          _DetailItem(label: 'Source', value: row.source, primaryText: primaryText, secondaryText: secondaryText),
        ],
      ),
    );
  }

  Widget _buildResponsiveRow({required BuildContext context, required List<Widget> children}) {
    if (context.isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children.asMap().entries.map((entry) {
          final index = entry.key;
          final widget = entry.value;
          final isLast = index == children.length - 1;

          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [widget, if (!isLast) Gap(16.h)]);
        }).toList(),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children.asMap().entries.map((entry) {
        final index = entry.key;
        final widget = entry.value;
        final isLast = index == children.length - 1;

        return Expanded(
          child: Row(
            children: [
              Expanded(child: widget),
              if (!isLast) Gap(16.w),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _DetailItem extends StatelessWidget {
  const _DetailItem({required this.label, required this.value, required this.primaryText, required this.secondaryText});

  final String label;
  final String value;
  final Color primaryText;
  final Color secondaryText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: context.textTheme.bodyMedium?.copyWith(color: secondaryText)),
        Gap(4.h),
        Text(
          value,
          style: context.textTheme.bodyLarge?.copyWith(fontSize: 15.sp, color: primaryText),
        ),
      ],
    );
  }
}

class _StatusDetailItem extends StatelessWidget {
  const _StatusDetailItem({
    required this.label,
    required this.status,
    required this.primaryText,
    required this.secondaryText,
  });

  final String label;
  final String status;
  final Color primaryText;
  final Color secondaryText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: context.textTheme.bodyMedium?.copyWith(color: secondaryText)),
        Gap(8.h),
        DigifyStatusCapsule(status: status, variant: DigifyStatusCapsuleVariant.rounded),
      ],
    );
  }
}
