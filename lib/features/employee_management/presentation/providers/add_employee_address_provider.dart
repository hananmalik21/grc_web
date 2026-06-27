import 'package:grc/core/utils/form_validators.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddEmployeeAddressState {
  final String? addressLine1;
  final String? addressLine2;
  final String? city;
  final String? area;
  final String? countryCode;
  final String? emergAddress;
  final String? emergPhone;
  final String? emergEmail;
  final String? emergRelationship;
  final String? contactName;

  const AddEmployeeAddressState({
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.area,
    this.countryCode,
    this.emergAddress,
    this.emergPhone,
    this.emergEmail,
    this.emergRelationship,
    this.contactName,
  });

  bool get isStepValid {
    final r1 = addressLine1?.trim() ?? '';
    final cty = city?.trim() ?? '';
    final ar = area?.trim() ?? '';
    final cc = countryCode?.trim() ?? '';
    final p = emergPhone?.trim() ?? '';
    final e = emergEmail?.trim() ?? '';
    final r = emergRelationship?.trim() ?? '';
    final c = contactName?.trim() ?? '';
    return r1.isNotEmpty &&
        cty.isNotEmpty &&
        ar.isNotEmpty &&
        cc.isNotEmpty &&
        p.isNotEmpty &&
        e.isNotEmpty &&
        r.isNotEmpty &&
        c.isNotEmpty &&
        FormValidators.phone(emergPhone) == null;
  }

  AddEmployeeAddressState copyWith({
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? area,
    String? countryCode,
    String? emergAddress,
    String? emergPhone,
    String? emergEmail,
    String? emergRelationship,
    String? contactName,
    bool clearAddressLine1 = false,
    bool clearAddressLine2 = false,
    bool clearCity = false,
    bool clearArea = false,
    bool clearCountryCode = false,
    bool clearEmergAddress = false,
    bool clearEmergPhone = false,
    bool clearEmergEmail = false,
    bool clearEmergRelationship = false,
    bool clearContactName = false,
  }) {
    return AddEmployeeAddressState(
      addressLine1: clearAddressLine1 ? null : (addressLine1 ?? this.addressLine1),
      addressLine2: clearAddressLine2 ? null : (addressLine2 ?? this.addressLine2),
      city: clearCity ? null : (city ?? this.city),
      area: clearArea ? null : (area ?? this.area),
      countryCode: clearCountryCode ? null : (countryCode ?? this.countryCode),
      emergAddress: clearEmergAddress ? null : (emergAddress ?? this.emergAddress),
      emergPhone: clearEmergPhone ? null : (emergPhone ?? this.emergPhone),
      emergEmail: clearEmergEmail ? null : (emergEmail ?? this.emergEmail),
      emergRelationship: clearEmergRelationship ? null : (emergRelationship ?? this.emergRelationship),
      contactName: clearContactName ? null : (contactName ?? this.contactName),
    );
  }
}

class AddEmployeeAddressNotifier extends StateNotifier<AddEmployeeAddressState> {
  AddEmployeeAddressNotifier() : super(const AddEmployeeAddressState());

  void setAddressLine1(String? value) {
    state = state.copyWith(addressLine1: value, clearAddressLine1: value == null || value.isEmpty);
  }

  void setAddressLine2(String? value) {
    state = state.copyWith(addressLine2: value, clearAddressLine2: value == null || value.isEmpty);
  }

  void setCity(String? value) {
    state = state.copyWith(city: value, clearCity: value == null || value.isEmpty);
  }

  void setArea(String? value) {
    state = state.copyWith(area: value, clearArea: value == null || value.isEmpty);
  }

  void setCountryCode(String? value) {
    state = state.copyWith(countryCode: value, clearCountryCode: value == null || value.isEmpty);
  }

  void setEmergAddress(String? value) {
    state = state.copyWith(emergAddress: value, clearEmergAddress: value == null || value.isEmpty);
  }

  void setEmergPhone(String? value) {
    state = state.copyWith(emergPhone: value, clearEmergPhone: value == null || value.isEmpty);
  }

  void setEmergEmail(String? value) {
    state = state.copyWith(emergEmail: value, clearEmergEmail: value == null || value.isEmpty);
  }

  void setEmergRelationship(String? value) {
    state = state.copyWith(emergRelationship: value, clearEmergRelationship: value == null || value.isEmpty);
  }

  void setContactName(String? value) {
    state = state.copyWith(contactName: value, clearContactName: value == null || value.isEmpty);
  }

  void setFromFullDetails({
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? area,
    String? countryCode,
    String? emergAddress,
    String? emergPhone,
    String? emergEmail,
    String? emergRelationship,
    String? contactName,
  }) {
    state = state.copyWith(
      addressLine1: addressLine1 ?? state.addressLine1,
      addressLine2: addressLine2 ?? state.addressLine2,
      city: city ?? state.city,
      area: area ?? state.area,
      countryCode: countryCode ?? state.countryCode,
      emergAddress: emergAddress ?? state.emergAddress,
      emergPhone: emergPhone ?? state.emergPhone,
      emergEmail: emergEmail ?? state.emergEmail,
      emergRelationship: emergRelationship ?? state.emergRelationship,
      contactName: contactName ?? state.contactName,
    );
  }

  void reset() {
    state = const AddEmployeeAddressState();
  }
}

final addEmployeeAddressProvider = StateNotifierProvider<AddEmployeeAddressNotifier, AddEmployeeAddressState>((ref) {
  return AddEmployeeAddressNotifier();
});
