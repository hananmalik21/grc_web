import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/core/widgets/common/enterprise_selector_widget.dart';
import 'package:grc/features/hiring/presentation/screens/interviews_tab/interviews_content.dart';
import 'package:grc/features/hiring/presentation/widgets/interviews/interviews_header.dart';
import 'package:flutter/material.dart';

class InterviewsTabletLayout extends StatelessWidget {
  const InterviewsTabletLayout({
    required this.selectedEnterpriseId,
    required this.onEnterpriseChanged,
    required this.onScheduleInterviewPressed,
    super.key,
  });

  final int? selectedEnterpriseId;
  final ValueChanged<int?> onEnterpriseChanged;
  final VoidCallback onScheduleInterviewPressed;

  @override
  Widget build(BuildContext context) {
    return InterviewsContent(
      padding: ResponsiveHelper.getScreenPadding(context),
      header: InterviewsHeader(onScheduleInterviewPressed: onScheduleInterviewPressed),
      enterpriseSelector: EnterpriseSelectorWidget(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: onEnterpriseChanged,
      ),
      onScheduleInterviewPressed: onScheduleInterviewPressed,
    );
  }
}
