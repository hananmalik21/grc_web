import 'package:grc/features/employee_self_service/presentation/widgets/ess_labeled_value.dart';
import 'package:grc/features/employee_self_service/presentation/widgets/ess_surface_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class PersonalIdentityCard extends StatelessWidget {
  final String fullNameEnglish;
  final String fullNameArabic;
  final String civilIdOrPassport;
  final String employeeNumber;
  final String maritalStatus;
  final String gender;

  const PersonalIdentityCard({
    super.key,
    required this.fullNameEnglish,
    required this.fullNameArabic,
    required this.civilIdOrPassport,
    required this.employeeNumber,
    required this.maritalStatus,
    required this.gender,
  });

  @override
  Widget build(BuildContext context) {
    return EssSurfaceCard(
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 560) {
            return Column(
              spacing: 20.h,
              children: [
                EssLabeledValue(label: 'Full Name (English)', value: fullNameEnglish),

                EssLabeledValue(
                  label: 'Full Name (Arabic)',
                  value: fullNameArabic,
                  valueAlign: TextAlign.right,
                  alignment: CrossAxisAlignment.end,
                ),

                EssLabeledValue(label: 'Civil ID / Passport', value: civilIdOrPassport),

                EssLabeledValue(label: 'Employee Number', value: employeeNumber),

                EssLabeledValue(label: 'Marital Status', value: maritalStatus),

                EssLabeledValue(label: 'Gender', value: gender),
              ],
            );
          }

          return Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        EssLabeledValue(label: 'Full Name (English)', value: fullNameEnglish),
                        Gap(20.h),
                        EssLabeledValue(
                          label: 'Full Name (Arabic)',
                          value: fullNameArabic,
                          alignment: CrossAxisAlignment.start,
                        ),
                      ],
                    ),
                  ),
                  Gap(24.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        EssLabeledValue(label: 'Civil ID / Passport', value: civilIdOrPassport),
                        Gap(20.h),
                        EssLabeledValue(label: 'Employee Number', value: employeeNumber),
                      ],
                    ),
                  ),
                ],
              ),
              Gap(20.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: EssLabeledValue(label: 'Marital Status', value: maritalStatus),
                  ),
                  Gap(24.w),
                  Expanded(
                    child: EssLabeledValue(label: 'Gender', value: gender),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
