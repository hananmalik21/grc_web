class SalaryComponentItem {
  final String label;
  final String value;
  final bool isHighlighted;

  const SalaryComponentItem({
    required this.label,
    required this.value,
    this.isHighlighted = false,
  });
}

class BankDetailsInfo {
  final String bankName;
  final String accountNumber;
  final String iban;

  const BankDetailsInfo({
    required this.bankName,
    required this.accountNumber,
    required this.iban,
  });

  BankDetailsInfo copyWith({
    String? bankName,
    String? accountNumber,
    String? iban,
  }) {
    return BankDetailsInfo(
      bankName: bankName ?? this.bankName,
      accountNumber: accountNumber ?? this.accountNumber,
      iban: iban ?? this.iban,
    );
  }
}

class PayBenefitsState {
  final String headerTitle;
  final String headerSubtitle;
  final List<SalaryComponentItem> salaryComponents;
  final String totalMonthlyPay;
  final BankDetailsInfo bankDetails;

  const PayBenefitsState({
    required this.headerTitle,
    required this.headerSubtitle,
    required this.salaryComponents,
    required this.totalMonthlyPay,
    required this.bankDetails,
  });

  PayBenefitsState copyWith({
    String? headerTitle,
    String? headerSubtitle,
    List<SalaryComponentItem>? salaryComponents,
    String? totalMonthlyPay,
    BankDetailsInfo? bankDetails,
  }) {
    return PayBenefitsState(
      headerTitle: headerTitle ?? this.headerTitle,
      headerSubtitle: headerSubtitle ?? this.headerSubtitle,
      salaryComponents: salaryComponents ?? this.salaryComponents,
      totalMonthlyPay: totalMonthlyPay ?? this.totalMonthlyPay,
      bankDetails: bankDetails ?? this.bankDetails,
    );
  }
}
