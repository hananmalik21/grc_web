import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/widgets/common/digify_tab_header.dart';
import 'package:grc/features/hiring/presentation/widgets/interviews/interviews_header_actions.dart';
import 'package:flutter/material.dart';

class InterviewsHeader extends StatelessWidget {
  const InterviewsHeader({super.key, this.onScheduleInterviewPressed});

  final VoidCallback? onScheduleInterviewPressed;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return DigifyTabHeader(
      title: loc.hiringInterviews,
      description: loc.hiringInterviewsDescription,
      trailing: InterviewsHeaderActions(onScheduleInterviewPressed: onScheduleInterviewPressed),
    );
  }
}
