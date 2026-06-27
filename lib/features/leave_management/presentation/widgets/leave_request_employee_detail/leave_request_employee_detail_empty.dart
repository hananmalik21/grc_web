import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LeaveRequestEmployeeDetailEmpty extends StatelessWidget {
  const LeaveRequestEmployeeDetailEmpty({super.key, required this.localizations});

  final AppLocalizations localizations;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 48.h),
        child: Center(
          child: Text(
            localizations.noResultsFound,
            style: TextStyle(fontSize: 16.sp, color: AppColors.textMuted),
          ),
        ),
      ),
    );
  }
}
