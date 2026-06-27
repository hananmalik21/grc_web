import 'package:grc/core/enums/hiring_enums.dart';

class RequisitionDisplayLabels {
  RequisitionDisplayLabels._();

  static String employmentType(String? code) {
    return _fromCode(code, const {
      'FULL_TIME': 'Full-time',
      'PART_TIME': 'Part-time',
      'CONTRACT': 'Contract',
      'INTERNSHIP': 'Internship',
    });
  }

  static String workMode(String? code) {
    return _fromCode(code, const {'ONSITE': 'On-site', 'ON_SITE': 'On-site', 'REMOTE': 'Remote', 'HYBRID': 'Hybrid'});
  }

  static String priority(String? code) {
    return _fromCode(code, const {'HIGH': 'High', 'MEDIUM': 'Medium', 'LOW': 'Low'});
  }

  static String approvalStatus(String? code) {
    final status = RequisitionStatus.fromApiValue(code);
    if (status != null) return status.label;

    return _fromCode(code, const {
      'PENDING_APPROVAL': 'Pending Approval',
      'OPEN': 'Open',
      'CLOSED': 'Closed',
      'CANCELLED': 'Cancelled',
    });
  }

  static String compensationType(String? code) {
    return _fromCode(code, const {'ANNUAL': 'Annual', 'MONTHLY': 'Monthly', 'HOURLY': 'Hourly', 'SALARY': 'Salary'});
  }

  static String travelRequirement(String? code) {
    return _fromCode(code, const {'NONE': 'None', 'LOW': 'Low', 'MEDIUM': 'Medium', 'HIGH': 'High'});
  }

  static String filterKey(String? code) {
    if (code == null || code.trim().isEmpty) return '';
    return code.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '_');
  }

  static String _fromCode(String? code, Map<String, String> labels) {
    if (code == null || code.trim().isEmpty) return '';
    final normalized = code.trim().toUpperCase();
    final label = labels[normalized];
    if (label != null) return label;
    return _titleCase(normalized.replaceAll('_', ' '));
  }

  static String _titleCase(String value) {
    if (value.isEmpty) return value;
    return value
        .split(' ')
        .where((part) => part.isNotEmpty)
        .map((part) => '${part[0].toUpperCase()}${part.substring(1).toLowerCase()}')
        .join(' ');
  }
}
