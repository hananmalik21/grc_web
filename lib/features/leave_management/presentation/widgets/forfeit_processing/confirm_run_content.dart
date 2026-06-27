import 'package:grc/features/leave_management/domain/models/forfeit_preview_employee.dart';
import 'package:grc/features/leave_management/presentation/providers/forfeit_schedule_provider.dart';
import 'package:grc/features/leave_management/presentation/widgets/forfeit_processing/forfeit_confirmation_dialog.dart';
import 'package:grc/features/leave_management/presentation/widgets/forfeit_processing/forfeit_processing_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConfirmRunContent extends ConsumerStatefulWidget {
  final List<ForfeitPreviewEmployee> employees;

  const ConfirmRunContent({super.key, required this.employees});

  @override
  ConsumerState<ConfirmRunContent> createState() => _ConfirmRunContentState();
}

class _ConfirmRunContentState extends ConsumerState<ConfirmRunContent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showDialog();
    });
  }

  Future<void> _showDialog() async {
    if (!mounted) return;

    final employees = widget.employees;
    if (employees.isEmpty) return;

    final totalDays = employees.fold<double>(
      0.0,
      (sum, employee) => sum + (employee.forfeitDays < 0 ? employee.forfeitDays.abs() : 0),
    );
    final employeeCount = employees.length;

    final confirmed = await ForfeitConfirmationDialog.show(context, totalDays: totalDays, employeeCount: employeeCount);

    if (confirmed == true && mounted) {
      ref.read(forfeitProcessingStepProvider.notifier).nextStep();
    } else if (confirmed == false && mounted) {
      ref.read(forfeitProcessingStepProvider.notifier).setStep(ForfeitProcessingStep.previewReview);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(); // Dialog is shown in initState
  }
}
