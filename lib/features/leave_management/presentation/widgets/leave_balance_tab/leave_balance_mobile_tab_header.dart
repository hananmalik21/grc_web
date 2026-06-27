import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/widgets/buttons/app_mobile_button.dart';
import 'package:grc/core/widgets/common/digify_mobile_tab_header.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class LeaveBalanceMobileTabHeader extends StatelessWidget {
  const LeaveBalanceMobileTabHeader({required this.localizations, super.key});

  final AppLocalizations localizations;

  @override
  Widget build(BuildContext context) {
    return DigifyMobileTabHeader(
      title: localizations.myLeaveBalance,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppMobileButton.primary(svgPath: Assets.icons.leaveManagementIcon.path, onPressed: () {}),
          Gap(8.w),
          AppMobileButton(
            svgPath: Assets.icons.leaveManagement.dollar.path,
            onPressed: () {},
            backgroundColor: AppColors.greenButton,
          ),
        ],
      ),
    );
  }
}
