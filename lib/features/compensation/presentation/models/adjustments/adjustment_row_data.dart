import 'package:grc/features/compensation/domain/models/adjustments/adjustment.dart';
import 'package:intl/intl.dart';

enum AdjustmentStatus { approved, rejected, pending }

extension AdjustmentStatusX on AdjustmentStatus {
  String get label {
    switch (this) {
      case AdjustmentStatus.approved:
        return 'Approved';
      case AdjustmentStatus.rejected:
        return 'Rejected';
      case AdjustmentStatus.pending:
        return 'Pending';
    }
  }
}

AdjustmentStatus _adjustmentStatusFromRaw(String? value) {
  final normalized = value?.trim().toUpperCase() ?? '';

  switch (normalized) {
    case 'APPROVED':
    case 'APPROVAL APPROVED':
      return AdjustmentStatus.approved;
    case 'REJECTED':
    case 'REJECT':
    case 'DECLINED':
    case 'FAILED':
    case 'ERROR':
      return AdjustmentStatus.rejected;
    case 'PENDING':
    case 'SUBMITTED':
    case 'PENDING APPROVAL':
    case 'APPROVAL REQUIRED':
    case 'HR REVIEW':
    case 'FINANCE REVIEW':
    case 'DRAFT':
    default:
      return AdjustmentStatus.pending;
  }
}

class AdjustmentRowData {
  final String adjustmentId;
  final String employeeGuid;
  final String employeeName;
  final String employeeId;
  final int employeeNumericId;
  final String department;
  final String region;
  final String adjustmentType;
  final String currentSalary;
  final String adjustmentMethod;
  final String adjustmentValue;
  final String newSalary;
  final String increaseAmount;
  final String increasePercent;
  final String effectiveDate;
  final String reasonCode;
  final AdjustmentStatus status;
  final String submittedBy;
  final String submittedDate;

  const AdjustmentRowData({
    required this.adjustmentId,
    this.employeeGuid = '',
    required this.employeeName,
    required this.employeeId,
    this.employeeNumericId = 0,
    required this.department,
    required this.region,
    required this.adjustmentType,
    required this.currentSalary,
    required this.adjustmentMethod,
    required this.adjustmentValue,
    required this.newSalary,
    required this.increaseAmount,
    required this.increasePercent,
    required this.effectiveDate,
    required this.reasonCode,
    required this.status,
    required this.submittedBy,
    required this.submittedDate,
  });

  factory AdjustmentRowData.fromAdjustment(Adjustment adj) {
    final currencyCode = adj.assignmentDetails.isNotEmpty ? adj.assignmentDetails.first.currencyCode : 'SAR';

    String formatCurrency(double value) {
      final formatted = NumberFormat.simpleCurrency(decimalDigits: 0, name: '').format(value).trim();
      return '$currencyCode $formatted';
    }

    String formatSignedCurrency(double value) {
      final sign = value < 0 ? '-' : '+';
      final absoluteValue = value.abs();
      final formatted = NumberFormat.simpleCurrency(decimalDigits: 0, name: '').format(absoluteValue).trim();
      return '$currencyCode $sign$formatted';
    }

    return AdjustmentRowData(
      adjustmentId: 'ADJ-${adj.adjustmentId}',
      employeeGuid: adj.employeeGuid,
      employeeName: adj.fullNameEn,
      employeeId: adj.employeeNumber,
      employeeNumericId: adj.employeeId,
      department: adj.departmentName,
      region: adj.regionName,
      adjustmentType: adj.adjustmentType.replaceAll('_', ' '),
      currentSalary: formatCurrency(adj.previousSalary),
      adjustmentMethod: adj.assignmentDetails.isNotEmpty ? adj.assignmentDetails.first.changeSource : '—',
      adjustmentValue: '${adj.salaryDifferencePercent}%',
      newSalary: formatCurrency(adj.totalSalary),
      increaseAmount: formatSignedCurrency(adj.totalSalary - adj.previousSalary),
      increasePercent: '(${adj.salaryDifferencePercent.toStringAsFixed(1)}%)',
      effectiveDate: DateFormat(
        'yyyy-MM-dd',
      ).format(adj.assignmentDetails.isNotEmpty ? adj.assignmentDetails.first.effectiveStartDate : adj.effectiveDate),
      reasonCode: adj.reasonCode,
      status: _adjustmentStatusFromRaw(adj.status),
      submittedBy: adj.createdBy,
      submittedDate: DateFormat('yyyy-MM-dd').format(adj.creationDate),
    );
  }

  String get statusLabel => status.label;

  bool get isPendingApproval => status == AdjustmentStatus.pending;

  bool get isNegativeIncrease {
    final normalizedAmount = increaseAmount.trim();
    final normalizedPercent = increasePercent.trim();

    return normalizedAmount.startsWith('-') ||
        normalizedPercent.startsWith('-') ||
        normalizedPercent.contains('(-') ||
        normalizedAmount.contains(' -');
  }
}
