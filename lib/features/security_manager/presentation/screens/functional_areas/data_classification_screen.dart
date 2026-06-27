import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_tab_header.dart';
import 'package:grc/features/security_manager/presentation/providers/data_classification/data_classification_provider.dart';
import 'package:grc/features/security_manager/presentation/widgets/data_classification/data_classification_compliance_card.dart';
import 'package:grc/features/security_manager/presentation/widgets/data_classification/data_classification_guidelines_card.dart';
import 'package:grc/features/security_manager/presentation/widgets/data_classification/data_classification_levels_section.dart';
import 'package:grc/features/security_manager/presentation/widgets/data_classification/data_classification_search_card.dart';
import 'package:grc/features/security_manager/presentation/widgets/data_classification/data_classification_stats_cards.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DataClassificationScreen extends ConsumerStatefulWidget {
  const DataClassificationScreen({super.key});

  @override
  ConsumerState<DataClassificationScreen> createState() => _DataClassificationScreenState();
}

class _DataClassificationScreenState extends ConsumerState<DataClassificationScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.text = ref.read(dataClassificationProvider).query;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    ref.watch(dataClassificationProvider);
    final notifier = ref.read(dataClassificationProvider.notifier);
    final filteredLevels = notifier.filteredLevels;

    return Container(
      color: isDark ? AppColors.backgroundDark : AppColors.tableHeaderBackground,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 24.w).copyWith(bottom: 24.h),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 1100;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 20.h,
              children: [
                DigifyTabHeader(
                  title: 'Data Classification',
                  description: 'Manage data sensitivity levels and access controls',
                  trailing: AppButton.primary(
                    label: 'Add Classification',
                    svgPath: Assets.icons.addNewIconFigma.path,
                    onPressed: () {},
                  ),
                ),
                DataClassificationStatsCards(
                  isDark: isDark,
                  stats: [
                    DataClassificationStat(
                      title: 'Public Data',
                      value: notifier.publicCount.toString(),
                      iconPath: Assets.icons.blueEyeIcon.path,
                      iconColor: AppColors.primary,
                    ),
                    DataClassificationStat(
                      title: 'Confidential Data',
                      value: notifier.confidentialCount.toString(),
                      iconPath: Assets.icons.leaveManagement.shield.path,
                      iconColor: AppColors.primary,
                    ),
                    DataClassificationStat(
                      title: 'Restricted Data',
                      value: notifier.restrictedCount.toString(),
                      iconPath: Assets.icons.lockIcon.path,
                      iconColor: AppColors.primary,
                    ),
                  ],
                ),
                DataClassificationSearchCard(
                  isDark: isDark,
                  controller: _searchController,
                  onChanged: notifier.setQuery,
                ),
                DataClassificationLevelsSection(isDark: isDark, levels: filteredLevels),
                if (isWide)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 20.w,
                    children: [
                      Expanded(child: DataClassificationGuidelinesCard(isDark: isDark)),
                      Expanded(child: DataClassificationComplianceCard(isDark: isDark)),
                    ],
                  )
                else
                  Column(
                    spacing: 20.h,
                    children: [
                      DataClassificationGuidelinesCard(isDark: isDark),
                      DataClassificationComplianceCard(isDark: isDark),
                    ],
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
