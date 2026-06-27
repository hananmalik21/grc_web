import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/section_header_card.dart';
import 'package:grc/features/employee_management/presentation/widgets/add_employee_steps/add_employee_basic_info_form.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddEmployeeBasicInfoStep extends StatelessWidget {
  const AddEmployeeBasicInfoStep({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final em = Assets.icons.employeeManagement;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 18.h,
      children: [
        SectionHeaderCard(
          iconAssetPath: em.basicInfo.path,
          title: localizations.basicInformation,
          subtitle: localizations.addEmployeeBasicInfoSubtitle,
        ),
        Container(
          padding: EdgeInsets.all(18.w),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: AppShadows.primaryShadow,
          ),
          child: const AddEmployeeBasicInfoForm(),
        ),
      ],
    );
  }
}
