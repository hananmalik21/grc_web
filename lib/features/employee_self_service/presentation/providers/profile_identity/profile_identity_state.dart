class EmergencyContact {
  final String name;
  final String relationshipLabel;
  final String phoneNumber;
  final bool isPrimary;

  const EmergencyContact({
    required this.name,
    required this.relationshipLabel,
    required this.phoneNumber,
    this.isPrimary = false,
  });
}

class ProfileIdentityState {
  final String fullNameEnglish;
  final String fullNameArabic;
  final String jobTitle;
  final String nationalityLabel;
  final String civilIdOrPassport;
  final String employeeNumber;
  final String maritalStatus;
  final String gender;
  final String emailAddress;
  final String mobileNumber;
  final String residentialAddress;
  final List<EmergencyContact> emergencyContacts;

  const ProfileIdentityState({
    required this.fullNameEnglish,
    required this.fullNameArabic,
    required this.jobTitle,
    required this.nationalityLabel,
    required this.civilIdOrPassport,
    required this.employeeNumber,
    required this.maritalStatus,
    required this.gender,
    required this.emailAddress,
    required this.mobileNumber,
    required this.residentialAddress,
    required this.emergencyContacts,
  });

  ProfileIdentityState copyWith({
    String? fullNameEnglish,
    String? fullNameArabic,
    String? jobTitle,
    String? nationalityLabel,
    String? civilIdOrPassport,
    String? employeeNumber,
    String? maritalStatus,
    String? gender,
    String? emailAddress,
    String? mobileNumber,
    String? residentialAddress,
    List<EmergencyContact>? emergencyContacts,
  }) {
    return ProfileIdentityState(
      fullNameEnglish: fullNameEnglish ?? this.fullNameEnglish,
      fullNameArabic: fullNameArabic ?? this.fullNameArabic,
      jobTitle: jobTitle ?? this.jobTitle,
      nationalityLabel: nationalityLabel ?? this.nationalityLabel,
      civilIdOrPassport: civilIdOrPassport ?? this.civilIdOrPassport,
      employeeNumber: employeeNumber ?? this.employeeNumber,
      maritalStatus: maritalStatus ?? this.maritalStatus,
      gender: gender ?? this.gender,
      emailAddress: emailAddress ?? this.emailAddress,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      residentialAddress: residentialAddress ?? this.residentialAddress,
      emergencyContacts: emergencyContacts ?? this.emergencyContacts,
    );
  }
}

