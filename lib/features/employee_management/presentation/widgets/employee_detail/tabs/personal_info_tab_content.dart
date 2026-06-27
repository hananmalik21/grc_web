import 'package:grc/features/employee_management/domain/models/employee_full_details.dart';
import 'package:grc/features/employee_management/presentation/utils/employee_detail_formatters.dart';
import 'package:grc/features/employee_management/presentation/widgets/employee_detail/employee_detail_bordered_section_card.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class PersonalInfoTabContent extends StatelessWidget {
  const PersonalInfoTabContent({super.key, required this.isDark, this.fullDetails, this.wrapInScrollView = true});

  final bool isDark;
  final EmployeeFullDetails? fullDetails;
  final bool wrapInScrollView;

  List<EmployeeDetailBorderedField> _personalInfoLeft() {
    final e = fullDetails?.employee;
    if (e == null) {
      return [
        const EmployeeDetailBorderedField(label: 'First Name (English)', value: '—'),
        const EmployeeDetailBorderedField(label: 'Middle Name (English)', value: '—'),
        const EmployeeDetailBorderedField(label: 'Last Name (English)', value: '—'),
        const EmployeeDetailBorderedField(label: 'Fourth Name (English)', value: '—'),
        const EmployeeDetailBorderedField(label: 'Full Name (English)', value: '—'),
        const EmployeeDetailBorderedField(label: 'First Name (Arabic)', value: '—', isValueRtl: true),
        const EmployeeDetailBorderedField(label: 'Middle Name (Arabic)', value: '—', isValueRtl: true),
        const EmployeeDetailBorderedField(label: 'Last Name (Arabic)', value: '—', isValueRtl: true),
        const EmployeeDetailBorderedField(label: 'Fourth Name (Arabic)', value: '—', isValueRtl: true),
      ];
    }
    return [
      EmployeeDetailBorderedField(label: 'First Name (English)', value: displayValue(e.firstNameEn)),
      EmployeeDetailBorderedField(label: 'Middle Name (English)', value: displayValue(e.middleNameEn)),
      EmployeeDetailBorderedField(label: 'Last Name (English)', value: displayValue(e.lastNameEn)),
      EmployeeDetailBorderedField(label: 'Fourth Name (English)', value: displayValue(e.fourthNameEn)),
      EmployeeDetailBorderedField(
        label: 'Full Name (English)',
        value: displayValue(e.fullNameEn.isEmpty ? null : e.fullNameEn),
      ),
      EmployeeDetailBorderedField(label: 'First Name (Arabic)', value: displayValue(e.firstNameAr), isValueRtl: true),
      EmployeeDetailBorderedField(label: 'Middle Name (Arabic)', value: displayValue(e.middleNameAr), isValueRtl: true),
      EmployeeDetailBorderedField(label: 'Last Name (Arabic)', value: displayValue(e.lastNameAr), isValueRtl: true),
      EmployeeDetailBorderedField(label: 'Fourth Name (Arabic)', value: displayValue(e.fourthNameAr), isValueRtl: true),
      EmployeeDetailBorderedField(
        label: 'Full Name (Arabic)',
        value: displayValue(e.fullNameAr.isEmpty ? null : e.fullNameAr),
        isValueRtl: true,
      ),
    ];
  }

  List<EmployeeDetailBorderedField> _personalInfoRight() {
    final e = fullDetails?.employee;
    final d = fullDetails?.demographics;
    if (e == null) {
      return List.generate(8, (_) => const EmployeeDetailBorderedField(label: '—', value: '—'));
    }
    return [
      EmployeeDetailBorderedField(label: 'Email Address', value: displayValue(e.email)),
      EmployeeDetailBorderedField(label: 'Phone Number', value: displayValue(e.phoneNumber)),
      EmployeeDetailBorderedField(label: 'Mobile Number', value: displayValue(e.mobileNumber)),
      EmployeeDetailBorderedField(label: 'Date of Birth', value: formatIsoDateToDisplay(e.dateOfBirth)),
      EmployeeDetailBorderedField(label: 'Gender', value: displayValue(d?.genderCode)),
      EmployeeDetailBorderedField(label: 'Marital Status', value: displayValue(d?.maritalStatusCode)),
      EmployeeDetailBorderedField(label: 'Nationality', value: displayValue(d?.nationalityCode)),
      EmployeeDetailBorderedField(label: 'Religion', value: displayValue(d?.religionCode)),
    ];
  }

  List<EmployeeDetailBorderedField> _identificationLeft() {
    final d = fullDetails?.demographics;
    final addr = fullDetails?.addresses;
    final primaryList = addr?.where((a) => a.isPrimary == 'Y').toList();
    final primary = (primaryList?.isNotEmpty == true)
        ? primaryList!.first
        : (addr?.isNotEmpty == true ? addr!.first : null);
    final addressLine = primary != null
        ? [
            primary.addressLine1,
            primary.addressLine2,
            primary.city,
            primary.area,
          ].whereType<String>().where((s) => s.trim().isNotEmpty).join(', ')
        : null;
    return [
      EmployeeDetailBorderedField(label: 'Civil ID Number', value: displayValue(d?.civilIdNumber)),
      EmployeeDetailBorderedField(label: 'Address in Kuwait', value: displayValue(addressLine)),
    ];
  }

  List<EmployeeDetailBorderedField> _identificationRight() {
    final d = fullDetails?.demographics;
    return [EmployeeDetailBorderedField(label: 'Passport Number', value: displayValue(d?.passportNumber))];
  }

  List<EmployeeDetailBorderedField> _emergencyContactLeft() {
    final ec = fullDetails?.emergencyContacts;
    final first = ec?.isNotEmpty == true ? ec!.first : null;
    return [
      EmployeeDetailBorderedField(label: 'Contact Name', value: displayValue(first?.contactName)),
      EmployeeDetailBorderedField(label: 'Relationship', value: displayValue(first?.relationshipCode)),
    ];
  }

  List<EmployeeDetailBorderedField> _emergencyContactRight() {
    final ec = fullDetails?.emergencyContacts;
    final first = ec?.isNotEmpty == true ? ec!.first : null;
    return [
      EmployeeDetailBorderedField(label: 'Emergency Phone', value: displayValue(first?.phoneNumber)),
      EmployeeDetailBorderedField(label: 'Emergency Email', value: displayValue(first?.email)),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EmployeeDetailBorderedSectionCard(
            title: 'Personal Information',
            leftColumnFields: _personalInfoLeft(),
            rightColumnFields: _personalInfoRight(),
            isDark: isDark,
          ),
          Gap(24.h),
          EmployeeDetailBorderedSectionCard(
            title: 'Identification & Address',
            leftColumnFields: _identificationLeft(),
            rightColumnFields: _identificationRight(),
            isDark: isDark,
          ),
          Gap(24.h),
          EmployeeDetailBorderedSectionCard(
            title: 'Emergency Contact',
            titleIconAssetPath: Assets.icons.warningIcon.path,
            leftColumnFields: _emergencyContactLeft(),
            rightColumnFields: _emergencyContactRight(),
            isDark: isDark,
          ),
        ],
      ),
    );
    if (wrapInScrollView) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: content,
      );
    }
    return content;
  }
}
