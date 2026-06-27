import 'package:grc/core/widgets/feedback/app_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../providers/overtime/new_overtime_provider.dart';
import 'new_overtime_request_dialog_widgets/new_overtime_request_dialog_widgets.dart';

class NewOvertimeRequestDialog extends ConsumerStatefulWidget {
  const NewOvertimeRequestDialog({super.key});

  static void show(BuildContext context) {
    showDialog(context: context, barrierDismissible: false, builder: (context) => NewOvertimeRequestDialog());
  }

  @override
  ConsumerState<NewOvertimeRequestDialog> createState() => _NewOvertimeRequestDialogState();
}

class _NewOvertimeRequestDialogState extends ConsumerState<NewOvertimeRequestDialog> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(newOvertimeRequestProvider.notifier).reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: 'New Overtime Request',
      width: 600.w,
      onClose: () => context.pop(),
      content: const NewOvertimeRequestFormBody(),
      actions: [NewOvertimeRequestDialogActions(onClose: () => context.pop())],
    );
  }
}
