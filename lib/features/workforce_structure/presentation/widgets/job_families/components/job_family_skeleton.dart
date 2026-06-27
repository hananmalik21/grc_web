import 'package:grc/features/workforce_structure/domain/models/job_family.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/job_families/job_family_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';

class JobFamilySkeleton extends StatelessWidget {
  final int itemCount;

  const JobFamilySkeleton({super.key, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    // Create dummy job families for the skeleton
    final dummyJobFamilies = List.generate(
      itemCount,
      (index) => JobFamily(
        id: index,
        code: 'JF00${index + 1}',
        nameEnglish: 'Skeleton Job Family Name',
        nameArabic: 'اسم عائلة الوظيفة',
        description:
            'This is a skeleton description for the job family card to show how it looks while loading.',
        totalPositions: 10,
        filledPositions: 5,
        fillRate: 0.5,
        isActive: true,
      ),
    );

    return Skeletonizer(
      enabled: true,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxW = constraints.maxWidth;
          final spacing = 16.w;
          final runSpacing = 20.h;
          final targetCardWidth = 466.0;

          final columns = maxW < 600
              ? 1
              : maxW < 900
              ? 2
              : 3;
          final computed = (maxW - (spacing * (columns - 1))) / columns;
          final cardWidth = computed > targetCardWidth
              ? targetCardWidth
              : computed;

          return Wrap(
            spacing: spacing,
            runSpacing: runSpacing,
            children: dummyJobFamilies.map<Widget>((jobFamily) {
              return SizedBox(
                width: cardWidth,
                child: JobFamilyCard(
                  jobFamily: jobFamily,
                  jobLevels: const [],
                  localizations: localizations,
                  isDark: Theme.of(context).brightness == Brightness.dark,
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
