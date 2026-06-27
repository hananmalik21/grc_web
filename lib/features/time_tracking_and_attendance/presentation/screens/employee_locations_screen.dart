import 'package:grc/core/widgets/feedback/placeholder_screen.dart';
import 'package:flutter/material.dart';

class EmployeeLocationsScreen extends StatelessWidget {
  const EmployeeLocationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: 'Employee Locations',
      subtitle: 'View and manage employee location data used for attendance and verification.',
    );
  }
}
