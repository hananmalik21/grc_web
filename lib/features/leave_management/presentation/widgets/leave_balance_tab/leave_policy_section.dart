import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/features/leave_management/presentation/widgets/leave_balance_tab/policy_card.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class LeavePolicySection extends StatelessWidget {
  final AppLocalizations localizations;
  final bool isDark;

  const LeavePolicySection({super.key, required this.localizations, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(22.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.topRight,
          colors: [Color(0xFFEFF6FF), Color(0xFFEEF2FF)],
        ),
        border: Border.all(color: const Color(0xFFBEDBFF)),
        borderRadius: BorderRadius.circular(11.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              DigifyAsset(
                assetPath: Assets.icons.calendarIcon.path,
                width: 17.5,
                height: 17.5,
                color: const Color(0xFF1C398E),
              ),
              Gap(7.w),
              Text(
                localizations.kuwaitLaborLawLeavePolicy,
                style: TextStyle(
                  fontSize: 15.4.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1C398E),
                  height: 24.5 / 15.4,
                ),
              ),
            ],
          ),
          Gap(13.75.h),
          Row(
            children: [
              Expanded(
                child: PolicyCard(
                  title: localizations.carryForwardPolicy,
                  description: localizations.carryForwardPolicyDescription,
                  isDark: isDark,
                ),
              ),
              Gap(14.w),
              Expanded(
                child: PolicyCard(
                  title: localizations.forfeitRules,
                  description: localizations.forfeitRulesDescription,
                  isDark: isDark,
                ),
              ),
              Gap(14.w),
              Expanded(
                child: PolicyCard(
                  title: localizations.encashmentPolicy,
                  description: localizations.encashmentPolicyDescription,
                  isDark: isDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
