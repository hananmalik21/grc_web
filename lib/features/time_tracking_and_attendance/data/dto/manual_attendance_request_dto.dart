import 'package:grc/features/time_tracking_and_attendance/domain/models/attendance/manual_attendance_request.dart';

class ManualAttendanceRequestDto {
  final int attendanceDayId;
  final String checkInTime;
  final String checkOutTime;
  final String actor;
  final String? locationNameIn;
  final double? latitudeIn;
  final double? longitudeIn;
  final String? locationNameOut;
  final double? latitudeOut;
  final double? longitudeOut;
  final String? reason;

  const ManualAttendanceRequestDto({
    required this.attendanceDayId,
    required this.checkInTime,
    required this.checkOutTime,
    required this.actor,
    this.locationNameIn,
    this.latitudeIn,
    this.longitudeIn,
    this.locationNameOut,
    this.latitudeOut,
    this.longitudeOut,
    this.reason,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'attendance_day_id': attendanceDayId,
      'check_in_time': checkInTime,
      'check_out_time': checkOutTime,
      'actor': actor,
    };
    if (locationNameIn != null && locationNameIn!.isNotEmpty) {
      map['location_name_in'] = locationNameIn;
    }
    if (latitudeIn != null) map['latitude_in'] = latitudeIn;
    if (longitudeIn != null) map['longitude_in'] = longitudeIn;
    if (locationNameOut != null && locationNameOut!.isNotEmpty) {
      map['location_name_out'] = locationNameOut;
    }
    if (latitudeOut != null) map['latitude_out'] = latitudeOut;
    if (longitudeOut != null) map['longitude_out'] = longitudeOut;
    if (reason != null && reason!.isNotEmpty) map['reason'] = reason;
    return map;
  }

  factory ManualAttendanceRequestDto.fromDomain(ManualAttendanceRequest req) {
    return ManualAttendanceRequestDto(
      attendanceDayId: req.attendanceDayId,
      checkInTime: req.checkInTime,
      checkOutTime: req.checkOutTime,
      actor: req.actor,
      locationNameIn: req.locationNameIn,
      latitudeIn: req.latitudeIn,
      longitudeIn: req.longitudeIn,
      locationNameOut: req.locationNameOut,
      latitudeOut: req.latitudeOut,
      longitudeOut: req.longitudeOut,
      reason: req.reason,
    );
  }
}
