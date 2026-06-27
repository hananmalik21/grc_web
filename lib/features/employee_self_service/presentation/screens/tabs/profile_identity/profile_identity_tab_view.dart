import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_tab_header.dart';
import 'package:grc/features/employee_self_service/presentation/providers/profile_identity/profile_identity_provider.dart';
import 'package:grc/features/employee_self_service/presentation/screens/tabs/profile_identity/widgets/contact_details_card.dart';
import 'package:grc/features/employee_self_service/presentation/screens/tabs/profile_identity/widgets/educational_background_card.dart';
import 'package:grc/features/employee_self_service/presentation/screens/tabs/profile_identity/widgets/emergency_contacts_card.dart';
import 'package:grc/features/employee_self_service/presentation/screens/tabs/profile_identity/widgets/family_dependents_card.dart';
import 'package:grc/features/employee_self_service/presentation/screens/tabs/profile_identity/widgets/personal_identity_card.dart';
import 'package:grc/features/employee_self_service/presentation/screens/tabs/profile_identity/widgets/profile_summary_card.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ProfileIdentityTabView extends ConsumerWidget {
  const ProfileIdentityTabView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileIdentityProvider);

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w).copyWith(bottom: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DigifyTabHeader(
            title: 'Personal Profile & Identity',
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppButton.outline(
                  label: 'Update Identity',
                  svgPath: Assets.icons.leaveManagement.shield.path,
                  onPressed: () {},
                ),
                Gap(8.w),
                AppButton.primary(label: 'Edit Profile', svgPath: Assets.icons.editIcon.path, onPressed: () {}),
              ],
            ),
          ),
          Gap(24.h),
          LayoutBuilder(
            builder: (context, constraints) {
              final isStacked = constraints.maxWidth < 980;
              final gap = 24.w;
              final leftWidth = isStacked ? constraints.maxWidth : 320.w;

              final summaryCard = ProfileSummaryCard(
                fullName: state.fullNameEnglish,
                jobTitle: state.jobTitle,
                nationalityLabel: state.nationalityLabel,
                fillHeight: !isStacked,
              );
              final identityCard = PersonalIdentityCard(
                fullNameEnglish: state.fullNameEnglish,
                fullNameArabic: state.fullNameArabic,
                civilIdOrPassport: state.civilIdOrPassport,
                employeeNumber: state.employeeNumber,
                maritalStatus: state.maritalStatus,
                gender: state.gender,
              );

              if (isStacked) {
                return Column(children: [summaryCard, Gap(24.h), identityCard]);
              }

              return SizedBox(
                height: 270.h,
                child: Row(
                  children: [
                    SizedBox(width: leftWidth, child: summaryCard),
                    Gap(gap),
                    Expanded(child: identityCard),
                  ],
                ),
              );
            },
          ),
          Gap(24.h),
          LayoutBuilder(
            builder: (context, constraints) {
              final isStacked = constraints.maxWidth < 980;
              final gap = 24.w;
              final contactCard = ContactDetailsCard(
                emailAddress: state.emailAddress,
                mobileNumber: state.mobileNumber,
                residentialAddress: state.residentialAddress,
              );
              final emergencyCard = EmergencyContactsCard(
                primaryContact: state.emergencyContacts.isEmpty ? null : state.emergencyContacts.first,
                onAddEmergencyContact: () {},
              );

              if (isStacked) {
                return Column(children: [contactCard, Gap(24.h), emergencyCard]);
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: contactCard),
                  Gap(gap),
                  Expanded(child: emergencyCard),
                ],
              );
            },
          ),
          Gap(24.h),
          FamilyDependentsCard(onAddOrUpdate: () {}, onRegisterDependents: () {}),
          Gap(24.h),
          EducationalBackgroundCard(onUpdateRecords: () {}),
        ],
      ),
    );
  }
}
