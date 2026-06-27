import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'pay_benefits_state.dart';

class PayBenefitsNotifier extends StateNotifier<PayBenefitsState> {
  PayBenefitsNotifier() : super(_initial());

  static PayBenefitsState _initial() {
    return const PayBenefitsState(
      headerTitle: 'Pay & Benefits',
      headerSubtitle: 'Overview of your salary structure and organization benefits',
      salaryComponents: [
        SalaryComponentItem(label: 'Basic Salary', value: '3,000 KWD'),
        SalaryComponentItem(label: 'Social Allowance', value: '450.000 KWD'),
      ],
      totalMonthlyPay: '3,450.000 KWD',
      bankDetails: BankDetailsInfo(
        bankName: 'National Bank of Kuwait',
        accountNumber: '020023',
        iban: 'KW819200009089888',
      ),
    );
  }
}

final payBenefitsProvider = StateNotifierProvider<PayBenefitsNotifier, PayBenefitsState>((ref) {
  return PayBenefitsNotifier();
});
