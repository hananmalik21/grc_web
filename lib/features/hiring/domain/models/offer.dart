class Offer {
  final String id;
  final String offerGuid;
  final int enterpriseId;
  final String candidateName;
  final String candidateInitials;
  final String position;
  final String department;
  final String location;
  final String startDate;
  final String annualSalary;
  final String status;
  final String level;
  final String type;
  final String probationPeriod;
  final String? signedDate;
  final String? expiryDate;

  const Offer({
    required this.id,
    this.offerGuid = '',
    this.enterpriseId = 0,
    required this.candidateName,
    required this.candidateInitials,
    required this.position,
    required this.department,
    required this.location,
    required this.startDate,
    required this.annualSalary,
    required this.status,
    required this.level,
    required this.type,
    required this.probationPeriod,
    this.signedDate,
    this.expiryDate,
  });

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      id: json['id'] as String,
      candidateName: json['candidateName'] as String,
      candidateInitials: json['candidateInitials'] as String,
      position: json['position'] as String,
      department: json['department'] as String,
      location: json['location'] as String,
      startDate: json['startDate'] as String,
      annualSalary: json['annualSalary'] as String,
      status: json['status'] as String,
      level: json['level'] as String,
      type: json['type'] as String,
      probationPeriod: json['probationPeriod'] as String,
      signedDate: json['signedDate'] as String?,
      expiryDate: json['expiryDate'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'candidateName': candidateName,
      'candidateInitials': candidateInitials,
      'position': position,
      'department': department,
      'location': location,
      'startDate': startDate,
      'annualSalary': annualSalary,
      'status': status,
      'level': level,
      'type': type,
      'probationPeriod': probationPeriod,
      'signedDate': signedDate,
      'expiryDate': expiryDate,
    };
  }
}
