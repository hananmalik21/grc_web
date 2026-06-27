import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/buttons/app_mobile_button.dart';
import 'package:flutter/material.dart';

class InterviewsHeaderActions extends StatelessWidget {
  const InterviewsHeaderActions({super.key, this.compact = false, this.onScheduleInterviewPressed});

  final bool compact;
  final VoidCallback? onScheduleInterviewPressed;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    if (compact) {
      return AppMobileButton.primary(onPressed: onScheduleInterviewPressed, icon: Icons.add);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppButton.primary(label: loc.hiringInterviewsNew, onPressed: onScheduleInterviewPressed, icon: Icons.add),
      ],
    );
  }
}
