import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/widgets/common/digify_square_capsule.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class AddElementMetadataFooter extends StatelessWidget {
  const AddElementMetadataFooter({required this.referenceDate, super.key});

  final DateTime referenceDate;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Wrap(
      spacing: 10.w,
      runSpacing: 10.h,
      children: [
        DigifySquareCapsule(
          label: loc.payrollAddElementCreatedBy(loc.payrollAddElementSystemAdministrator),
          backgroundColor: AppColors.cardBackground,
          borderColor: AppColors.cardBorder,
          borderRadius: BorderRadius.circular(10.r),
        ),
        DigifySquareCapsule(
          label: loc.payrollAddElementCreatedOn(DateFormat('dd MMM yyyy').format(referenceDate)),
          backgroundColor: AppColors.cardBackground,
          borderColor: AppColors.cardBorder,
          borderRadius: BorderRadius.circular(10.r),
        ),
        DigifySquareCapsule(
          label: loc.payrollAddElementLastModified(DateFormat('dd MMM yyyy, hh:mm a').format(referenceDate)),
          backgroundColor: AppColors.cardBackground,
          borderColor: AppColors.cardBorder,
          borderRadius: BorderRadius.circular(10.r),
        ),
        DigifySquareCapsule(
          label: loc.payrollAddElementPayrollStatus(loc.payrollAddElementStatusOpen),
          backgroundColor: AppColors.cardBackground,
          borderColor: AppColors.cardBorder,
          borderRadius: BorderRadius.circular(10.r),
        ),
      ],
    );
  }
}
