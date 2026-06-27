class LeaveTypeDto {
  final int leaveTypeId;
  final String leaveTypeGuid;
  final int tenantId;
  final String leaveCode;
  final String leaveNameEn;
  final String leaveNameAr;
  final String? descriptionEn;
  final String? descriptionAr;
  final String isPaid;
  final String requiresDocuments;
  final int? maxDaysPerYear;
  final String status;
  final DateTime creationDate;
  final String createdBy;
  final DateTime lastUpdateDate;
  final String lastUpdatedBy;

  LeaveTypeDto({
    required this.leaveTypeId,
    required this.leaveTypeGuid,
    required this.tenantId,
    required this.leaveCode,
    required this.leaveNameEn,
    required this.leaveNameAr,
    this.descriptionEn,
    this.descriptionAr,
    required this.isPaid,
    required this.requiresDocuments,
    this.maxDaysPerYear,
    required this.status,
    required this.creationDate,
    required this.createdBy,
    required this.lastUpdateDate,
    required this.lastUpdatedBy,
  });

  factory LeaveTypeDto.fromJson(Map<String, dynamic> json) {
    DateTime parseDateTime(dynamic value) {
      if (value == null) return DateTime.now();
      if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
      return DateTime.now();
    }

    return LeaveTypeDto(
      leaveTypeId: (json['leave_type_id'] as num?)?.toInt() ?? 0,
      leaveTypeGuid: json['leave_type_guid'] as String? ?? '',
      tenantId: (json['tenant_id'] as num?)?.toInt() ?? 0,
      leaveCode: json['leave_code'] as String? ?? '',
      leaveNameEn: json['leave_name_en'] as String? ?? '',
      leaveNameAr: json['leave_name_ar'] as String? ?? '',
      descriptionEn: json['description_en'] as String?,
      descriptionAr: json['description_ar'] as String?,
      isPaid: json['is_paid'] as String? ?? 'N',
      requiresDocuments: json['requires_documents'] as String? ?? 'N',
      maxDaysPerYear: (json['max_days_per_year'] as num?)?.toInt(),
      status: json['status'] as String? ?? 'INACTIVE',
      creationDate: parseDateTime(json['creation_date']),
      createdBy: json['created_by'] as String? ?? '',
      lastUpdateDate: parseDateTime(json['last_update_date']),
      lastUpdatedBy: json['last_updated_by'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'leave_type_id': leaveTypeId,
      'leave_type_guid': leaveTypeGuid,
      'tenant_id': tenantId,
      'leave_code': leaveCode,
      'leave_name_en': leaveNameEn,
      'leave_name_ar': leaveNameAr,
      'description_en': descriptionEn,
      'description_ar': descriptionAr,
      'is_paid': isPaid,
      'requires_documents': requiresDocuments,
      'max_days_per_year': maxDaysPerYear,
      'status': status,
      'creation_date': creationDate.toIso8601String(),
      'created_by': createdBy,
      'last_update_date': lastUpdateDate.toIso8601String(),
      'last_updated_by': lastUpdatedBy,
    };
  }
}
