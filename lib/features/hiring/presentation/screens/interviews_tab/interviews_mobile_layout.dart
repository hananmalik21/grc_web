import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/core/widgets/common/digify_mobile_tab_header.dart';
import 'package:grc/core/widgets/common/enterprise_selector_mobile_widget.dart';
import 'package:grc/features/hiring/presentation/screens/interviews_tab/interviews_content.dart';
import 'package:grc/features/hiring/presentation/widgets/interviews/interviews_header_actions.dart';
import 'package:flutter/material.dart';

class InterviewsMobileLayout extends StatelessWidget {
  const InterviewsMobileLayout({
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
    final loc = AppLocalizations.of(context)!;

    return InterviewsContent(
      padding: ResponsiveHelper.getScreenPadding(context),
      header: DigifyMobileTabHeader(
        title: loc.hiringInterviewsTitle,
        trailing: InterviewsHeaderActions(compact: true, onScheduleInterviewPressed: onScheduleInterviewPressed),
      ),
      enterpriseSelector: EnterpriseSelectorMobileWidget(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: onEnterpriseChanged,
      ),
      onScheduleInterviewPressed: onScheduleInterviewPressed,
    );
  }
}
