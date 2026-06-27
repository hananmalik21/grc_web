import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/dashboard_task.dart';

class TasksNotifier extends Notifier<List<DashboardTask>> {
  @override
  List<DashboardTask> build() {
    return [
      DashboardTask(id: '1', title: 'Review Leave Requests', subtitle: 'Due Today', isCompleted: false),
      DashboardTask(id: '2', title: 'Process Monthly Payroll', subtitle: 'Due in 3 Days', isCompleted: false),
      DashboardTask(id: '3', title: 'Update Employee Records', subtitle: 'Completed', isCompleted: true),
    ];
  }

  void toggleTask(String id) {
    state = [
      for (final task in state)
        if (task.id == id) task.copyWith(isCompleted: !task.isCompleted) else task,
    ];
  }
}

final tasksProvider = NotifierProvider<TasksNotifier, List<DashboardTask>>(TasksNotifier.new);
