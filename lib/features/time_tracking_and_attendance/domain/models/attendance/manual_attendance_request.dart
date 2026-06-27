/// Domain model for manual attendance submission
class ManualAttendanceRequest {
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

  const ManualAttendanceRequest({
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
}
