import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/feedback/placeholder_screen.dart';

class CompensationSimulationTab extends ConsumerStatefulWidget {
  const CompensationSimulationTab({super.key});

  @override
  ConsumerState<CompensationSimulationTab> createState() => _CompensationSimulationTabState();
}

class _CompensationSimulationTabState extends ConsumerState<CompensationSimulationTab> {
  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(title: 'Compensation Simulation');
  }
}
