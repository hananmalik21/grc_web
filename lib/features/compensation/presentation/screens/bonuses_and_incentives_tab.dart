import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/feedback/placeholder_screen.dart';

class BonusesAndIncentivesTab extends ConsumerStatefulWidget {
  const BonusesAndIncentivesTab({super.key});

  @override
  ConsumerState<BonusesAndIncentivesTab> createState() => _State();
}

class _State extends ConsumerState<BonusesAndIncentivesTab> {
  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(title: 'Bonuses & Incentives');
  }
}
