import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:flutter/material.dart';

import '../person_results_content.dart';

class PersonResultsDesktopLayout extends StatelessWidget {
  const PersonResultsDesktopLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return PersonResultsContent(padding: ResponsiveHelper.getScreenPadding(context));
  }
}
