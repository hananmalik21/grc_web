import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/features/employee_self_service/presentation/providers/pay_benefits/pay_benefits_state.dart';
import 'package:grc/features/employee_self_service/presentation/screens/tabs/pay_benefits/widgets/bank_detail_item.dart';
import 'package:grc/features/employee_self_service/presentation/widgets/ess_surface_card.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class BankDetailsCard extends StatelessWidget {
  final BankDetailsInfo bankDetails;

  const BankDetailsCard({super.key, required this.bankDetails});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return EssSurfaceCard(
      title: 'Bank Details',
      titleIconPath: Assets.icons.employeeManagement.banking.path,
      trailing: AppButton(
        label: 'Update Bank',
        onPressed: () {},
        type: AppButtonType.outline,
        svgPath: Assets.icons.editIcon.path,
        svgAssetColor: AppColors.primary,
        iconSize: 14,
        fontSize: 12.sp,
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(14.5.w),
        decoration: BoxDecoration(
          color: isDark ? AppColors.infoBgDark.withValues(alpha: 0.28) : AppColors.infoBg.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: isDark ? AppColors.infoBorderDark : AppColors.infoBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BankDetailItem(label: 'Bank Name', value: bankDetails.bankName),
            Gap(13.5.h),
            LayoutBuilder(
              builder: (context, constraints) {
                final isStacked = constraints.maxWidth < 280.w;

                if (isStacked) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BankDetailItem(label: 'Account Number', value: bankDetails.accountNumber),
                      Gap(13.5.h),
                      BankDetailItem(label: 'IBAN', value: bankDetails.iban, compactLabel: true),
                    ],
                  );
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: BankDetailItem(label: 'Account Number', value: bankDetails.accountNumber),
                    ),
                    Gap(13.5.w),
                    Expanded(
                      child: BankDetailItem(label: 'IBAN', value: bankDetails.iban, compactLabel: true),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
