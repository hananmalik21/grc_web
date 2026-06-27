import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/feedback/placeholder_screen.dart';

class RevisionHistoryTab extends ConsumerStatefulWidget {
  const RevisionHistoryTab({super.key});

  @override
  ConsumerState<RevisionHistoryTab> createState() => _RevisionHistoryTabState();
}

class _RevisionHistoryTabState extends ConsumerState<RevisionHistoryTab> {
  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(title: 'Revision History');
  }
}
