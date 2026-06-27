import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/feedback/placeholder_screen.dart';

class MeritPlanningTab extends ConsumerStatefulWidget {
  const MeritPlanningTab({super.key});

  @override
  ConsumerState<MeritPlanningTab> createState() => _MeritPlanningTabState();
}

class _MeritPlanningTabState extends ConsumerState<MeritPlanningTab> {
  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(title: 'Merit Planning');
  }
}
