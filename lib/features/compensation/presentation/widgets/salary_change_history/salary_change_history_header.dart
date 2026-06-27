import 'package:grc/core/widgets/common/digify_tab_header.dart';
import 'package:flutter/material.dart';

class SalaryChangeHistoryHeader extends StatelessWidget {
  const SalaryChangeHistoryHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return DigifyTabHeader(
      title: 'Salary Change History',
      description: 'View and track all compensation changes across the organization',
    );
  }
}
