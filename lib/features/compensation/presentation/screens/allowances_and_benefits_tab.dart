import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/feedback/placeholder_screen.dart';

class AllowancesAndBenefitsTab extends ConsumerStatefulWidget {
  const AllowancesAndBenefitsTab({super.key});

  @override
  ConsumerState<AllowancesAndBenefitsTab> createState() => _State();
}

class _State extends ConsumerState<AllowancesAndBenefitsTab> {
  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(title: 'Allowances & Benefits');
  }
}
