import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddEmployeeDemographicsState {
  final Map<String, String?> lookupCodesByTypeCode;
  final String? civilIdNumber;
  final String? passportNumber;

  const AddEmployeeDemographicsState({this.lookupCodesByTypeCode = const {}, this.civilIdNumber, this.passportNumber});

  String? getLookupCodeByTypeCode(String typeCode) => lookupCodesByTypeCode[typeCode];

  bool isStepValid(Iterable<String> requiredTypeCodes) {
    for (final code in requiredTypeCodes) {
      final value = lookupCodesByTypeCode[code];
      if (value == null || value.trim().isEmpty) return false;
    }
    final civil = civilIdNumber?.trim() ?? '';
    final passport = passportNumber?.trim() ?? '';
    return civil.isNotEmpty && passport.isNotEmpty;
  }

  AddEmployeeDemographicsState copyWith({
    Map<String, String?>? lookupCodesByTypeCode,
    String? civilIdNumber,
    String? passportNumber,
    bool clearCivilIdNumber = false,
    bool clearPassportNumber = false,
  }) {
    return AddEmployeeDemographicsState(
      lookupCodesByTypeCode: lookupCodesByTypeCode ?? this.lookupCodesByTypeCode,
      civilIdNumber: clearCivilIdNumber ? null : (civilIdNumber ?? this.civilIdNumber),
      passportNumber: clearPassportNumber ? null : (passportNumber ?? this.passportNumber),
    );
  }
}

class AddEmployeeDemographicsNotifier extends StateNotifier<AddEmployeeDemographicsState> {
  AddEmployeeDemographicsNotifier() : super(const AddEmployeeDemographicsState());

  void setLookupValueByTypeCode(String typeCode, String? value) {
    final newMap = Map<String, String?>.from(state.lookupCodesByTypeCode);
    if (value == null) {
      newMap.remove(typeCode);
    } else {
      newMap[typeCode] = value;
    }
    state = state.copyWith(lookupCodesByTypeCode: newMap);
  }

  void setCivilIdNumber(String? value) {
    state = state.copyWith(civilIdNumber: value, clearCivilIdNumber: value == null || value.isEmpty);
  }

  void setPassportNumber(String? value) {
    state = state.copyWith(passportNumber: value, clearPassportNumber: value == null || value.isEmpty);
  }

  void setFromFullDetails({
    Map<String, String?>? lookupCodesByTypeCode,
    String? civilIdNumber,
    String? passportNumber,
  }) {
    state = state.copyWith(
      lookupCodesByTypeCode: lookupCodesByTypeCode ?? state.lookupCodesByTypeCode,
      civilIdNumber: civilIdNumber ?? state.civilIdNumber,
      passportNumber: passportNumber ?? state.passportNumber,
    );
  }

  void reset() {
    state = const AddEmployeeDemographicsState();
  }
}

final addEmployeeDemographicsProvider =
    StateNotifierProvider<AddEmployeeDemographicsNotifier, AddEmployeeDemographicsState>((ref) {
      return AddEmployeeDemographicsNotifier();
    });
