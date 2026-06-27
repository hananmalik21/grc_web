import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/extensions/context_extensions.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/widgets/feedback/app_dialog.dart';
import 'package:grc/features/workforce_structure/domain/models/position.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/positions/common/dialog_components.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/positions/details/position_detail_cards.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/positions/details/position_detail_sections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class PositionDetailsDialog extends StatelessWidget {
  final Position position;

  const PositionDetailsDialog({super.key, required this.position});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return AppDialog(
      title: '${localizations.positionDetails} - ${position.titleEnglish}',
      width: 1000.w,
      onClose: () => context.pop(),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PositionDialogSection(
            title: localizations.basicInformation,
            children: [
              PositionFormRow(
                children: [
                  PositionDetailCard(label: localizations.positionCode, value: position.code),
                  PositionDetailCard(
                    label: localizations.status,
                    value: position.status.isNotEmpty ? position.status.toUpperCase() : 'ACTIVE',
                    highlight: true,
                    isActive: position.isActive,
                    inactiveBackgroundColor: AppColors.cardBackground,
                  ),
                ],
              ),
              Gap(16.h),
              PositionFormRow(
                children: [
                  PositionDetailCard(label: localizations.titleEnglish, value: position.titleEnglish),
                  PositionDetailCard(label: localizations.titleArabic, value: position.titleArabic, isRtl: true),
                ],
              ),
            ],
          ),
          Gap(24.h),
          PositionDialogSection(
            title: localizations.organizationalInformation,
            children: [
              PositionFormRow(
                children: [
                  PositionDetailCard(label: localizations.division, value: position.division),
                  PositionDetailCard(label: localizations.department, value: position.department),
                ],
              ),
              Gap(16.h),
              PositionFormRow(
                children: [
                  PositionDetailCard(label: localizations.costCenter, value: position.costCenter),
                  PositionDetailCard(label: localizations.location, value: position.location),
                ],
              ),
            ],
          ),
          Gap(24.h),
          PositionDialogSection(
            title: localizations.jobClassification,
            children: [
              PositionFormRow(
                children: [
                  PositionDetailCard(label: localizations.jobFamily, value: position.jobFamily),
                  PositionDetailCard(label: localizations.jobLevel, value: position.level),
                ],
              ),
              Gap(16.h),
              PositionFormRow(
                children: [
                  PositionDetailCard(label: localizations.gradeStep, value: position.grade),
                  PositionDetailCard(label: localizations.step, value: position.step),
                ],
              ),
            ],
          ),
          Gap(24.h),
          PositionHeadcountSection(position: position, localizations: localizations),
          Gap(24.h),
          PositionSalarySection(position: position, localizations: localizations),
          Gap(24.h),
          PositionReportingSection(position: position, localizations: localizations),
        ],
      ),
    );
  }
}
