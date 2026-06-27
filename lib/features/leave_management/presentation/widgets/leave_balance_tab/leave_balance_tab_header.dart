import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_tab_header.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LeaveBalanceTabHeader extends StatelessWidget {
  final AppLocalizations localizations;

  const LeaveBalanceTabHeader({super.key, required this.localizations});

  @override
  Widget build(BuildContext context) {
    return DigifyTabHeader(
      title: localizations.myLeaveBalance,
      description: localizations.myLeaveBalanceDescription,
      trailing: Wrap(
        spacing: 11.w,
        runSpacing: 11.h,
        children: [
          AppButton(
            label: localizations.applyLeave,
            svgPath: Assets.icons.leaveManagementIcon.path,
            type: AppButtonType.primary,
            backgroundColor: AppColors.primary,
            onPressed: () {},
          ),
          AppButton(
            label: localizations.requestEncashment,
            svgPath: Assets.icons.leaveManagement.dollar.path,
            type: AppButtonType.primary,
            backgroundColor: AppColors.greenButton,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
