import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddEmployeeBankingState {
  final String? bankCode;
  final String? bankName;
  final String? accountNumber;
  final String? iban;

  const AddEmployeeBankingState({this.bankCode, this.bankName, this.accountNumber, this.iban});

  static bool _isFilled(String? value) {
    final t = value?.trim();
    return t != null && t.isNotEmpty;
  }

  bool get isStepValid => _isFilled(bankCode) && _isFilled(accountNumber) && _isFilled(iban);

  AddEmployeeBankingState copyWith({
    String? bankCode,
    String? bankName,
    String? accountNumber,
    String? iban,
    bool clearBankCode = false,
    bool clearBankName = false,
    bool clearAccountNumber = false,
    bool clearIban = false,
  }) {
    return AddEmployeeBankingState(
      bankCode: clearBankCode ? null : (bankCode ?? this.bankCode),
      bankName: clearBankName ? null : (bankName ?? this.bankName),
      accountNumber: clearAccountNumber ? null : (accountNumber ?? this.accountNumber),
      iban: clearIban ? null : (iban ?? this.iban),
    );
  }
}

class AddEmployeeBankingNotifier extends StateNotifier<AddEmployeeBankingState> {
  AddEmployeeBankingNotifier() : super(const AddEmployeeBankingState());

  void setBank(String? code, String? displayName) {
    state = state.copyWith(
      bankCode: code,
      bankName: displayName,
      clearBankCode: code == null || code.isEmpty,
      clearBankName: displayName == null || displayName.isEmpty,
    );
  }

  void setAccountNumber(String? value) {
    state = state.copyWith(accountNumber: value, clearAccountNumber: value == null || value.isEmpty);
  }

  void setIban(String? value) {
    state = state.copyWith(iban: value, clearIban: value == null || value.isEmpty);
  }

  void setFromFullDetails({String? bankCode, String? bankName, String? accountNumber, String? iban}) {
    state = state.copyWith(
      bankCode: bankCode ?? state.bankCode,
      bankName: bankName ?? state.bankName,
      accountNumber: accountNumber ?? state.accountNumber,
      iban: iban ?? state.iban,
    );
  }

  void reset() {
    state = const AddEmployeeBankingState();
  }
}

final addEmployeeBankingProvider = StateNotifierProvider<AddEmployeeBankingNotifier, AddEmployeeBankingState>((ref) {
  return AddEmployeeBankingNotifier();
});
