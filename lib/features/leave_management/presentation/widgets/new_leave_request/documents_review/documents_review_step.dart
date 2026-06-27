import 'package:grc/features/leave_management/presentation/providers/new_leave_request_provider.dart';
import 'package:grc/features/leave_management/presentation/widgets/new_leave_request/documents_review/declaration_section.dart';
import 'package:grc/features/leave_management/presentation/widgets/new_leave_request/documents_review/documents_section.dart';
import 'package:grc/features/leave_management/presentation/widgets/new_leave_request/documents_review/request_summary_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DocumentsReviewStep extends ConsumerStatefulWidget {
  const DocumentsReviewStep({super.key});

  @override
  ConsumerState<DocumentsReviewStep> createState() => _DocumentsReviewStepState();
}

class _DocumentsReviewStepState extends ConsumerState<DocumentsReviewStep> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(newLeaveRequestProvider);
    final notifier = ref.read(newLeaveRequestProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16.h,
      children: [
        DocumentsSection(state: state, notifier: notifier),
        RequestSummarySection(state: state),
        DeclarationSection(),
      ],
    );
  }
}
