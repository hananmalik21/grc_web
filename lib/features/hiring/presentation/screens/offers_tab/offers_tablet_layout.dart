import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/core/widgets/common/enterprise_selector_widget.dart';
import 'package:grc/features/hiring/presentation/screens/offers_tab/offers_content.dart';
import 'package:grc/features/hiring/presentation/widgets/offers/offers_header.dart';
import 'package:flutter/material.dart';

class OffersTabletLayout extends StatelessWidget {
  const OffersTabletLayout({
    required this.selectedEnterpriseId,
    required this.onEnterpriseChanged,
    required this.onCreateOfferPressed,
    required this.onExportPressed,
    this.isExporting = false,
    super.key,
  });

  final int? selectedEnterpriseId;
  final ValueChanged<int?> onEnterpriseChanged;
  final VoidCallback onCreateOfferPressed;
  final VoidCallback onExportPressed;
  final bool isExporting;

  @override
  Widget build(BuildContext context) {
    return OffersContent(
      padding: ResponsiveHelper.getScreenPadding(context),
      header: OffersHeader(
        onCreateOfferPressed: onCreateOfferPressed,
        onExportPressed: onExportPressed,
        isExporting: isExporting,
      ),
      enterpriseSelector: EnterpriseSelectorWidget(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: onEnterpriseChanged,
      ),
      onCreateOfferPressed: onCreateOfferPressed,
      onExportPressed: onExportPressed,
    );
  }
}
