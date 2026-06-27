import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/buttons/app_mobile_button.dart';
import 'package:grc/core/widgets/common/digify_mobile_tab_header.dart';
import 'package:grc/core/widgets/common/digify_tab_header.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class FunctionManagementHeader extends StatelessWidget {
  const FunctionManagementHeader({super.key, required this.onCreatePressed});

  final VoidCallback onCreatePressed;

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobileLayout;

    final createButton = isMobile
        ? AppMobileButton.primary(svgPath: Assets.icons.addIcon.path, onPressed: onCreatePressed)
        : AppButton.primary(
            label: 'Create Function',
            svgPath: Assets.icons.addDivisionIcon.path,
            onPressed: onCreatePressed,
          );

    return isMobile
        ? DigifyMobileTabHeader(title: 'Function Management', trailing: createButton)
        : DigifyTabHeader(
            title: 'Function Management',
            description: 'Define functions and their permissions',
            trailing: createButton,
          );
  }
}
