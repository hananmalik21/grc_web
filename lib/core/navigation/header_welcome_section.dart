import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'header_search_field.dart';

class HeaderWelcomeSection extends StatefulWidget {
  const HeaderWelcomeSection({super.key, required this.localizations, required this.layout, required this.isDark});

  final AppLocalizations localizations;
  final ScreenLayout layout;
  final bool isDark;

  @override
  State<HeaderWelcomeSection> createState() => _HeaderWelcomeSectionState();
}

class _HeaderWelcomeSectionState extends State<HeaderWelcomeSection> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double maxW = context.responsiveFine(
      mobile: 0.0,
      tabletSmall: 0.0,
      tabletMedium: 380.0.w,
      tabletLarge: 440.0.w,
      desktop: 500.0.w,
    );

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxW),
        child: HeaderSearchField(
          controller: _searchController,
          hintText: widget.localizations.search,
          isDark: widget.isDark,
          onSubmitted: (_) {},
        ),
      ),
    );
  }
}
