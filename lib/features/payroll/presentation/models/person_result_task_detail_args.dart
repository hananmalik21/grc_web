import 'package:grc/features/payroll/domain/models/payroll_process_result_task.dart';
import 'package:grc/features/payroll/domain/models/person_result_employee.dart';

class PersonResultTaskDetailArgs {
  const PersonResultTaskDetailArgs({required this.employee, required this.task});

  final PersonResultEmployee employee;
  final PayrollProcessResultTask task;
}
