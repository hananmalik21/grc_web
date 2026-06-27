import 'package:flutter/foundation.dart';

@immutable
class OrgUnitFormData {
  final String orgUnitCode;
  final String orgUnitNameEn;
  final String orgUnitNameAr;
  final String? parentOrgUnitId;
  final bool isActive;
  final String managerName;
  final String managerEmail;
  final String managerPhone;
  final String location;
  final String city;
  final String address;
  final String description;
  final String? levelCode;

  const OrgUnitFormData({
    required this.orgUnitCode,
    required this.orgUnitNameEn,
    this.orgUnitNameAr = '',
    this.parentOrgUnitId,
    required this.isActive,
    this.managerName = '',
    this.managerEmail = '',
    this.managerPhone = '',
    this.location = '',
    this.city = '',
    this.address = '',
    this.description = '',
    this.levelCode,
  });

  Map<String, dynamic> toJson({bool isEdit = false}) {
    final data = <String, dynamic>{
      'org_unit_code': orgUnitCode.trim(),
      'org_unit_name_en': orgUnitNameEn.trim(),
      'org_unit_name_ar': orgUnitNameAr.trim(),
      'parent_org_unit_id': parentOrgUnitId,
      'is_active': isActive ? 'Y' : 'N',
      'manager_name': managerName.trim(),
      'manager_email': managerEmail.trim(),
      'manager_phone': managerPhone.trim(),
      'location': location.trim(),
      'city': city.trim(),
      'address': address.trim(),
      'description': description.trim(),
    };

    if (!isEdit && levelCode != null) {
      data['level_code'] = levelCode;
    }

    if (isEdit) {
      data['last_update_login'] = 'SYSTEM';
    }

    return data;
  }
}
