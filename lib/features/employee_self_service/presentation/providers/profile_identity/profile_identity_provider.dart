import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'profile_identity_state.dart';

class ProfileIdentityNotifier extends StateNotifier<ProfileIdentityState> {
  ProfileIdentityNotifier() : super(_initial());

  static ProfileIdentityState _initial() {
    return const ProfileIdentityState(
      fullNameEnglish: 'KHURAM K P SHAHZAD',
      fullNameArabic: 'khuram shahzad saddf',
      jobTitle: 'HR Manager',
      nationalityLabel: 'Pakistani National',
      civilIdOrPassport: '989987878',
      employeeNumber: 'EMP1765637069447',
      maritalStatus: 'Married',
      gender: 'Male',
      emailAddress: 'kh@gmail.com',
      mobileNumber: '8888',
      residentialAddress: 'Kuwait City, Registered Address',
      emergencyContacts: [
        EmergencyContact(
          name: 'cs',
          relationshipLabel: 'Other',
          phoneNumber: '234234',
          isPrimary: true,
        ),
      ],
    );
  }

  void addEmergencyContact(EmergencyContact contact) {
    state = state.copyWith(emergencyContacts: [...state.emergencyContacts, contact]);
  }
}

final profileIdentityProvider =
    StateNotifierProvider<ProfileIdentityNotifier, ProfileIdentityState>((ref) {
  return ProfileIdentityNotifier();
});

