class SalaryStructureOrgScopeUnit {
  final String orgUnitId;
  final String levelCode;
  final String? parentOrgUnitId;
  final String? orgUnitNameEn;

  const SalaryStructureOrgScopeUnit({
    required this.orgUnitId,
    required this.levelCode,
    this.parentOrgUnitId,
    this.orgUnitNameEn,
  });
}

class SalaryStructureOrgScopeParseResult {
  final String? countryCode;
  final List<String> allOrgUnitIds;
  final List<String> employmentTypeCodes;
  final Map<String, List<String>> companyToBusinessUnitIds;
  final Map<String, String> companyNamesById;

  const SalaryStructureOrgScopeParseResult({
    this.countryCode,
    this.allOrgUnitIds = const [],
    this.employmentTypeCodes = const [],
    this.companyToBusinessUnitIds = const {},
    this.companyNamesById = const {},
  });
}

class SalaryStructureOrgScopeParser {
  static const String _companyLevel = 'COMPANY';
  static const String _businessUnitLevel = 'BUSINESS_UNIT';

  SalaryStructureOrgScopeParser._();

  static SalaryStructureOrgScopeParseResult parse({
    required List<Map<String, dynamic>> orgScopes,
    List<Map<String, dynamic>> employmentTypes = const [],
  }) {
    final units = _buildUnitMap(orgScopes);
    if (units.isEmpty) {
      return SalaryStructureOrgScopeParseResult(
        countryCode: _firstCountryCode(orgScopes),
        employmentTypeCodes: _parseEmploymentTypeCodes(employmentTypes),
      );
    }

    final companyToBusinessUnits = <String, Set<String>>{};
    final companyNames = <String, String>{};

    for (final unit in units.values) {
      final companyId = _resolveCompanyId(unit.orgUnitId, units);
      if (companyId == null || companyId.isEmpty) continue;

      companyToBusinessUnits.putIfAbsent(companyId, () => {});

      if (unit.levelCode.toUpperCase() == _companyLevel) {
        _storeName(companyNames, companyId, unit.orgUnitNameEn);
        continue;
      }

      final businessUnitId = _resolveBusinessUnitId(unit.orgUnitId, units);
      if (businessUnitId != null && businessUnitId.isNotEmpty) {
        companyToBusinessUnits[companyId]!.add(businessUnitId);
      }

      final companyUnit = units[companyId];
      if (companyUnit != null) {
        _storeName(companyNames, companyId, companyUnit.orgUnitNameEn);
      }
    }

    final sortedCompanyMap = {
      for (final entry in companyToBusinessUnits.entries) entry.key: entry.value.toList()..sort(),
    };

    return SalaryStructureOrgScopeParseResult(
      countryCode: _firstCountryCode(orgScopes),
      allOrgUnitIds: units.keys.toList()..sort(),
      employmentTypeCodes: _parseEmploymentTypeCodes(employmentTypes, orgScopes),
      companyToBusinessUnitIds: sortedCompanyMap,
      companyNamesById: companyNames,
    );
  }

  static Map<String, SalaryStructureOrgScopeUnit> _buildUnitMap(List<Map<String, dynamic>> orgScopes) {
    final units = <String, SalaryStructureOrgScopeUnit>{};

    for (final scope in orgScopes) {
      final orgUnitId = (scope['business_unit_id'] as String?)?.trim() ?? '';
      if (orgUnitId.isEmpty) continue;

      final businessUnit = scope['business_unit'] as Map<String, dynamic>?;
      units[orgUnitId] = SalaryStructureOrgScopeUnit(
        orgUnitId: orgUnitId,
        levelCode: (businessUnit?['level_code'] as String?)?.trim() ?? '',
        parentOrgUnitId: (businessUnit?['parent_org_unit_id'] as String?)?.trim(),
        orgUnitNameEn: (businessUnit?['org_unit_name_en'] as String?)?.trim(),
      );
    }

    return units;
  }

  static String? _firstCountryCode(List<Map<String, dynamic>> orgScopes) {
    for (final scope in orgScopes) {
      final code = (scope['country_code'] as String?)?.trim();
      if (code != null && code.isNotEmpty) return code;
    }
    return null;
  }

  static List<String> _parseEmploymentTypeCodes(
    List<Map<String, dynamic>> employmentTypes, [
    List<Map<String, dynamic>> orgScopes = const [],
  ]) {
    final codes = employmentTypes
        .map((entry) => (entry['employment_type_code'] as String?)?.trim() ?? '')
        .where((code) => code.isNotEmpty)
        .toSet();

    if (codes.isNotEmpty) return codes.toList()..sort();

    // Legacy fallback when employment types were embedded on org scopes.
    final legacyCodes = orgScopes
        .map((scope) => (scope['employee_category_code'] as String?)?.trim() ?? '')
        .where((code) => code.isNotEmpty)
        .toSet();

    return legacyCodes.toList()..sort();
  }

  static String? _resolveCompanyId(String startId, Map<String, SalaryStructureOrgScopeUnit> units) {
    var currentId = startId.trim();
    final visited = <String>{};

    while (currentId.isNotEmpty && visited.add(currentId)) {
      final unit = units[currentId];
      if (unit == null) return currentId;

      if (unit.levelCode.toUpperCase() == _companyLevel) return currentId;

      final parentId = unit.parentOrgUnitId?.trim() ?? '';
      if (parentId.isEmpty) return currentId;
      currentId = parentId;
    }

    return null;
  }

  static String? _resolveBusinessUnitId(String startId, Map<String, SalaryStructureOrgScopeUnit> units) {
    var currentId = startId.trim();
    final visited = <String>{};

    while (currentId.isNotEmpty && visited.add(currentId)) {
      final unit = units[currentId];
      if (unit == null) return null;

      if (unit.levelCode.toUpperCase() == _businessUnitLevel) return currentId;

      final parentId = unit.parentOrgUnitId?.trim() ?? '';
      if (parentId.isEmpty) return null;
      currentId = parentId;
    }

    return null;
  }

  static void _storeName(Map<String, String> names, String orgUnitId, String? name) {
    if (name == null || name.isEmpty) return;
    names.putIfAbsent(orgUnitId, () => name);
  }
}
