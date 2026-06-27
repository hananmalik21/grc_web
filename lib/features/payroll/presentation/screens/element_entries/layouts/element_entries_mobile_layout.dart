import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/features/payroll/presentation/widgets/element_entries/element_entries_header.dart';
import 'package:flutter/material.dart';

import '../element_entries_content.dart';

class ElementEntriesMobileLayout extends StatelessWidget {
  const ElementEntriesMobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return ElementEntriesContent(
      padding: ResponsiveHelper.getScreenPadding(context),
      header: const ElementEntriesHeaderMobile(),
    );
  }
}
