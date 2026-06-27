import 'package:flutter_riverpod/flutter_riverpod.dart';

enum LeaveFilter { all, draft, pending, approved, rejected }

class LeaveFilterNotifier extends StateNotifier<LeaveFilter> {
  LeaveFilterNotifier() : super(LeaveFilter.all);

  void setFilter(LeaveFilter filter) {
    state = filter;
  }
}

final leaveFilterProvider = StateNotifierProvider<LeaveFilterNotifier, LeaveFilter>((ref) => LeaveFilterNotifier());
