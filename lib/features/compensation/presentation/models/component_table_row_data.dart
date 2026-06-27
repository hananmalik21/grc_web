import 'package:grc/features/compensation/domain/models/components/comp_component.dart';

class ComponentTableRowData {
  final String name;
  final String code;
  final String category;
  final String calculation;
  final String status;
  final String payroll;
  final String description;
  final int usedInPlans;
  final CompComponent? component;

  const ComponentTableRowData({
    required this.name,
    required this.code,
    required this.category,
    required this.calculation,
    required this.status,
    this.payroll = 'Not Mapped',
    this.description = '',
    required this.usedInPlans,
    this.component,
  });
}
