/// Attendance status enum matching Figma design
enum AttendanceStatus { present, late, absent, early, onLeave, halfDay, officialWork, businessTrip }

/// Location information for check-in/check-out
class AttendanceLocation {
  final double? latitude;
  final double? longitude;
  final String? address;
  final String? city;
  final String? country;

  const AttendanceLocation({this.latitude, this.longitude, this.address, this.city, this.country});

  factory AttendanceLocation.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const AttendanceLocation();
    return AttendanceLocation(
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      address: json['address'],
      city: json['city'],
      country: json['country'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'latitude': latitude, 'longitude': longitude, 'address': address, 'city': city, 'country': country};
  }
}

class Attendance {
  final int id;
  final int? attendanceDayId;
  final int employeeId;
  final String employeeName;
  final String employeeNumber;
  final String departmentName;
  final DateTime date;
  final DateTime? clockIn;
  final DateTime? clockOut;
  final AttendanceStatus status;
  final AttendanceLocation? checkInLocation;
  final AttendanceLocation? checkOutLocation;
  final double? workedHours;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Attendance({
    required this.id,
    this.attendanceDayId,
    required this.employeeId,
    required this.employeeName,
    required this.employeeNumber,
    required this.departmentName,
    required this.date,
    this.clockIn,
    this.clockOut,
    required this.status,
    this.checkInLocation,
    this.checkOutLocation,
    this.workedHours,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: json['id'] as int,
      attendanceDayId: (json['attendance_day_id'] as num?)?.toInt(),
      employeeId: json['employee_id'] as int,
      employeeName: json['employee_name'] as String? ?? '',
      employeeNumber: json['employee_number'] as String? ?? '',
      departmentName: json['department_name'] as String? ?? '',
      date: DateTime.parse(json['date'] as String),
      clockIn: json['clock_in'] != null ? DateTime.parse(json['clock_in'] as String) : null,
      clockOut: json['clock_out'] != null ? DateTime.parse(json['clock_out'] as String) : null,
      status: parseStatus(json['status'] as String? ?? ''),
      checkInLocation: AttendanceLocation.fromJson(json['check_in_location'] as Map<String, dynamic>?),
      checkOutLocation: AttendanceLocation.fromJson(json['check_out_location'] as Map<String, dynamic>?),
      workedHours: json['worked_hours']?.toDouble(),
      notes: json['notes'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employee_id': employeeId,
      'employee_name': employeeName,
      'employee_number': employeeNumber,
      'department_name': departmentName,
      'date': date.toIso8601String(),
      'clock_in': clockIn?.toIso8601String(),
      'clock_out': clockOut?.toIso8601String(),
      'status': statusToString(status),
      'check_in_location': checkInLocation?.toJson(),
      'check_out_location': checkOutLocation?.toJson(),
      'worked_hours': workedHours,
      'notes': notes,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Converts status string to enum
  static AttendanceStatus parseStatus(String status) {
    switch (status.toLowerCase()) {
      case 'present':
        return AttendanceStatus.present;
      case 'late':
        return AttendanceStatus.late;
      case 'absent':
        return AttendanceStatus.absent;
      case 'early':
        return AttendanceStatus.early;
      case 'on leave':
      case 'on_leave':
      case 'onleave':
        return AttendanceStatus.onLeave;
      case 'half day':
      case 'half_day':
      case 'halfday':
        return AttendanceStatus.halfDay;
      case 'official work':
      case 'official_work':
      case 'officialwork':
        return AttendanceStatus.officialWork;
      case 'business trip':
      case 'business_trip':
      case 'businesstrip':
        return AttendanceStatus.businessTrip;
      default:
        return AttendanceStatus.present;
    }
  }

  /// Converts enum to status string
  static String statusToString(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.present:
        return 'Present';
      case AttendanceStatus.late:
        return 'Late';
      case AttendanceStatus.absent:
        return 'Absent';
      case AttendanceStatus.early:
        return 'Early';
      case AttendanceStatus.onLeave:
        return 'On Leave';
      case AttendanceStatus.halfDay:
        return 'Half Day';
      case AttendanceStatus.officialWork:
        return 'Official Work';
      case AttendanceStatus.businessTrip:
        return 'Business Trip';
    }
  }

  /// Gets status as string
  String get statusString => statusToString(status);

  /// Gets formatted check-in time string (HH:mm format)
  String? get formattedCheckIn {
    if (clockIn == null) return null;
    final hour = clockIn!.hour.toString().padLeft(2, '0');
    final minute = clockIn!.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  /// Gets formatted check-out time string (HH:mm format)
  String? get formattedCheckOut {
    if (clockOut == null) return null;
    final hour = clockOut!.hour.toString().padLeft(2, '0');
    final minute = clockOut!.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  /// Gets avatar initials from employee name
  String get avatarInitials {
    final names = employeeName.split(' ');
    if (names.isEmpty) return '';
    if (names.length == 1) {
      return names[0].isNotEmpty ? names[0][0].toUpperCase() : '';
    }
    return '${names[0][0]}${names[1][0]}'.toUpperCase();
  }
}
