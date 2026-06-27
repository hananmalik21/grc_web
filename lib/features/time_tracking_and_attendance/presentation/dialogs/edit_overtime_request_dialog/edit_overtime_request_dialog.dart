import 'package:grc/core/widgets/feedback/app_dialog.dart';
import 'package:grc/features/time_tracking_and_attendance/domain/models/overtime/overtime_record.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../providers/overtime/edit_overtime_request_provider.dart';
import 'edit_overtime_request_dialog_actions.dart';
import 'edit_overtime_request_form_body.dart';

class EditOvertimeRequestDialog extends ConsumerStatefulWidget {
  final OvertimeRecord record;

  const EditOvertimeRequestDialog({super.key, required this.record});

  static void show(BuildContext context, OvertimeRecord record) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => EditOvertimeRequestDialog(record: record),
    );
  }

  @override
  ConsumerState<EditOvertimeRequestDialog> createState() => _EditOvertimeRequestDialogState();
}

class _EditOvertimeRequestDialogState extends ConsumerState<EditOvertimeRequestDialog> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(editOvertimeRequestProvider.notifier).init(widget.record);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: 'Edit Overtime Request',
      width: 600.w,
      onClose: () => context.pop(),
      content: const EditOvertimeRequestFormBody(),
      actions: [EditOvertimeRequestDialogActions(onClose: () => context.pop())],
    );
  }
}
