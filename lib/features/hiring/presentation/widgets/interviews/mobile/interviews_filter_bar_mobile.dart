import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_view_toggle_button.dart';
import 'package:grc/core/widgets/forms/digify_select_field.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/hiring/domain/models/interview_status_code.dart';
import 'package:grc/features/hiring/presentation/providers/interviews/interviews_controller_provider.dart';
import 'package:grc/features/hiring/presentation/providers/interviews/interviews_filter_provider.dart';
import 'package:grc/features/hiring/presentation/providers/interviews/interviews_tab_enterprise_provider.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class InterviewsFilterBarMobile extends ConsumerStatefulWidget {
  const InterviewsFilterBarMobile({super.key});

  @override
  ConsumerState<InterviewsFilterBarMobile> createState() => _InterviewsFilterBarMobileState();
}

class _InterviewsFilterBarMobileState extends ConsumerState<InterviewsFilterBarMobile> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final filterState = ref.watch(interviewsFilterProvider);
    final controller = ref.read(interviewsControllerProvider);
    final viewMode = ref.watch(interviewsViewModeProvider);

    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: DigifyTextField.search(
                  controller: _searchController,
                  hintText: loc.hiringInterviewsSearchHintMobile,
                  onChanged: controller.setSearch,
                ),
              ),
              Gap(8.w),
              _buildViewModeToggle(context, viewMode, isDark),
            ],
          ),
          Gap(12.h),
          DigifySelectField<String?>(
            hint: loc.allInterviews,
            value: filterState.status,
            items: [null, ...InterviewStatusCode.all],
            itemLabelBuilder: (value) => value ?? loc.allInterviews,
            onChanged: controller.setStatus,
          ),
        ],
      ),
    );
  }

  Widget _buildViewModeToggle(BuildContext context, InterviewsViewMode viewMode, bool isDark) {
    final nextMode = viewMode == InterviewsViewMode.calendar ? InterviewsViewMode.list : InterviewsViewMode.calendar;
    final assetPath = viewMode == InterviewsViewMode.calendar
        ? Assets.icons.employeesAssignedIcon.path
        : Assets.icons.hiring.listing.path;

    return AppViewToggleButton(
      svgPath: assetPath,
      onPressed: () {
        ref.read(interviewsViewModeProvider.notifier).state = nextMode;
      },
      backgroundColor: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
      foregroundColor: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
      borderColor: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
    );
  }
}
