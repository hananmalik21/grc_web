import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/features/employee_management/domain/models/employee_list_item.dart';
import 'package:grc/features/employee_management/presentation/widgets/table/employee_table_row.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class EmployeeTableSkeleton extends StatelessWidget {
  final AppLocalizations localizations;

  const EmployeeTableSkeleton({super.key, required this.localizations});

  @override
  Widget build(BuildContext context) {
    final placeholderEmployees = [
      const EmployeeListItem(
        id: '1',
        fullName: 'Khurram K P Shahzad',
        employeeNumber: 'EMP1765637069447',
        position: 'HR Manager',
        department: 'Purchasing',
        status: 'probation',
      ),
      const EmployeeListItem(
        id: '2',
        fullName: 'Zahoor K Khan',
        employeeNumber: 'EMP1765637069448',
        position: 'HR Manager',
        department: 'Purchasing',
        status: 'probation',
      ),
      const EmployeeListItem(
        id: '3',
        fullName: 'Ali G H Shamkhani',
        employeeNumber: 'EMP1765637069449',
        position: 'HR Manager',
        department: 'Purchasing',
        status: 'probation',
      ),
    ];

    return Skeletonizer(
      enabled: true,
      child: Column(
        children: [
          for (var i = 0; i < placeholderEmployees.length; i++)
            EmployeeTableRow(
              employee: placeholderEmployees[i],
              index: i + 1,
              localizations: localizations,
              onView: (_) {},
              onEdit: (_) {},
              onMore: () {},
            ),
        ],
      ),
    );
  }
}
