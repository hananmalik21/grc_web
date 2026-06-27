import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/forms/digify_select_field.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class TeamLeaveRiskFiltersSection extends StatefulWidget {
  final AppLocalizations localizations;
  final bool isDark;

  const TeamLeaveRiskFiltersSection({super.key, required this.localizations, required this.isDark});

  @override
  State<TeamLeaveRiskFiltersSection> createState() => _TeamLeaveRiskFiltersSectionState();
}

class _TeamLeaveRiskFiltersSectionState extends State<TeamLeaveRiskFiltersSection> {
  late TextEditingController _searchController;
  String? _selectedLeaveType;

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
    final leaveTypes = [
      widget.localizations.annualLeave,
      widget.localizations.sickLeave,
      widget.localizations.hajjLeave,
      widget.localizations.compassionateLeave,
    ];

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: widget.isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DigifyTextField.search(
            controller: _searchController,
            hintText: widget.localizations.tmSearchPlaceholder,
            onChanged: (value) {
              // Handle search
            },
          ),
          Gap(16.h),
          Wrap(
            spacing: 12.w,
            runSpacing: 12.h,
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SizedBox(
                width: 144.w,
                child: DigifySelectField<String?>(
                  hint: widget.localizations.allLeaveTypes,
                  value: _selectedLeaveType,
                  items: [null, ...leaveTypes],
                  itemLabelBuilder: (leaveType) => leaveType ?? widget.localizations.allLeaveTypes,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedLeaveType = newValue;
                    });
                  },
                ),
              ),
              AppButton(
                label: widget.localizations.export,
                onPressed: () {},
                svgPath: Assets.icons.downloadIcon.path,
                backgroundColor: AppColors.shiftExportButton,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
