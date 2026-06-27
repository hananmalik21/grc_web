import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';

enum OrganizationLevel {
  company,
  division,
  businessUnit,
  department,
  section,
  unknown;

  factory OrganizationLevel.fromCode(String code) {
    switch (code.toUpperCase()) {
      case 'COMPANY':
      case 'COMP':
        return OrganizationLevel.company;
      case 'DIVISION':
      case 'DIV':
        return OrganizationLevel.division;
      case 'BUSINESS_UNIT':
      case 'BUSINESSUNIT':
      case 'BU':
        return OrganizationLevel.businessUnit;
      case 'DEPARTMENT':
      case 'DEPT':
        return OrganizationLevel.department;
      case 'SECTION':
      case 'SECT':
        return OrganizationLevel.section;
      default:
        return OrganizationLevel.unknown;
    }
  }

  String get code {
    switch (this) {
      case OrganizationLevel.company:
        return 'COMPANY';
      case OrganizationLevel.division:
        return 'DIVISION';
      case OrganizationLevel.businessUnit:
        return 'BUSINESS_UNIT';
      case OrganizationLevel.department:
        return 'DEPARTMENT';
      case OrganizationLevel.section:
        return 'SECTION';
      case OrganizationLevel.unknown:
        return '';
    }
  }

  String get iconPath {
    switch (this) {
      case OrganizationLevel.company:
        return Assets.icons.companyTreeIcon.path;
      case OrganizationLevel.division:
        return Assets.icons.divisionTreeIcon.path;
      case OrganizationLevel.businessUnit:
        return Assets.icons.businessUnitTreeIcon.path;
      case OrganizationLevel.department:
        return Assets.icons.departmentTreeIcon.path;
      case OrganizationLevel.section:
        return Assets.icons.sectionTreeIcon.path;
      case OrganizationLevel.unknown:
        return Assets.icons.companyTreeIcon.path;
    }
  }

  Color getBgColor(bool isDark) {
    switch (this) {
      case OrganizationLevel.company:
        return isDark ? AppColors.purpleBgDark : AppColors.purpleBg;
      case OrganizationLevel.division:
        return isDark ? AppColors.infoBgDark : AppColors.infoBg;
      case OrganizationLevel.businessUnit:
        return isDark ? AppColors.successBgDark : AppColors.successBg;
      case OrganizationLevel.department:
        return isDark ? AppColors.warningBgDark : AppColors.orangeBg;
      case OrganizationLevel.section:
      case OrganizationLevel.unknown:
        return isDark ? AppColors.grayBgDark : AppColors.grayBg;
    }
  }
}
