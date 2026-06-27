import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_tab_header.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class SecurityPoliciesHeader extends StatelessWidget {
  final VoidCallback? onSave;

  const SecurityPoliciesHeader({super.key, required this.onSave});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return DigifyTabHeader(
      title: localizations.securityPolicies,
      description: 'Configure system-wide security rules and requirements',
      trailing: AppButton.primary(
        label: localizations.saveChanges,
        svgPath: Assets.icons.saveDivisionIcon.path,
        onPressed: onSave,
      ),
    );
  }
}
