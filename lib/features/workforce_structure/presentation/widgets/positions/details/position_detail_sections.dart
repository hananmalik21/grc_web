import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/features/workforce_structure/domain/models/position.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/positions/common/dialog_components.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/positions/details/position_detail_cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class PositionHeadcountSection extends StatelessWidget {
  final Position position;
  final AppLocalizations localizations;

  const PositionHeadcountSection({super.key, required this.position, required this.localizations});

  @override
  Widget build(BuildContext context) {
    return PositionDialogSection(
      title: localizations.headcountInformation,
      children: [
        PositionFormRow(
          children: [
            PositionHighlightCard(
              label: localizations.totalPositions,
              value: '${position.headcount}',
              backgroundColor: AppColors.infoBg,
              labelColor: AppColors.primary,
              valueColor: AppColors.infoText,
            ),
            PositionHighlightCard(
              label: localizations.filled,
              value: '${position.filled}',
              backgroundColor: AppColors.successBg,
              labelColor: AppColors.successText,
              valueColor: AppColors.successText,
            ),
            PositionHighlightCard(
              label: localizations.vacant,
              value: '${position.vacant}',
              backgroundColor: AppColors.vacancyBg,
              labelColor: AppColors.vacancyText,
              valueColor: AppColors.vacancyText,
            ),
          ],
        ),
      ],
    );
  }
}

class PositionSalarySection extends StatelessWidget {
  final Position position;
  final AppLocalizations localizations;

  const PositionSalarySection({super.key, required this.position, required this.localizations});

  @override
  Widget build(BuildContext context) {
    return PositionDialogSection(
      title: localizations.salaryInformation,
      children: [
        PositionFormRow(
          children: [
            PositionDetailCard(
              label: localizations.budgetedMin,
              value: position.budgetedMin.isNotEmpty ? '${position.budgetedMin} KD' : '-',
              width: double.infinity,
            ),
            PositionDetailCard(
              label: localizations.budgetedMax,
              value: position.budgetedMax.isNotEmpty ? '${position.budgetedMax} KD' : '-',
              width: double.infinity,
            ),
            PositionDetailCard(
              label: localizations.actualAverage,
              value: position.actualAverage.isNotEmpty ? '${position.actualAverage} KD' : '-',
              width: double.infinity,
            ),
          ],
        ),
      ],
    );
  }
}

class PositionReportingSection extends StatelessWidget {
  final Position position;
  final AppLocalizations localizations;

  const PositionReportingSection({super.key, required this.position, required this.localizations});

  @override
  Widget build(BuildContext context) {
    return PositionDialogSection(
      title: localizations.reportingRelationship,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColors.inputBg,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizations.reportsTo,
                style: TextStyle(
                  fontSize: 13.6.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                  height: 20 / 13.6,
                ),
              ),
              Gap(6.h),
              Text(
                position.reportsTo ?? '-',
                style: TextStyle(
                  fontSize: 15.6.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  height: 24 / 15.6,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
