import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/widgets/common/digify_stat_card.dart';
import '../../../../../gen/assets.gen.dart';

class ComponentStatuses extends ConsumerWidget {
  const ComponentStatuses({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 900;
        if (isMobile) {
          return Wrap(
            spacing: 16.w,
            runSpacing: 16.h,
            children: [
              _buildStatCard(
                context,
                width: (constraints.maxWidth - 16.w) / 2,
                label: 'Active Countries',
                value: '9',
                description: '+2 this quarter',
                icon: Icons.public,
              ),
              _buildStatCard(
                context,
                width: (constraints.maxWidth - 16.w) / 2,
                label: 'Draft Configurations',
                value: '3',
                description: 'Pending review',
                iconPath: Assets.icons.descriptionIcon.path,
              ),
              _buildStatCard(
                context,
                width: (constraints.maxWidth - 16.w) / 2,
                label: 'Mandatory Components',
                value: '42',
                description: 'Across all countries',
                iconPath: Assets.icons.activeCheckIcon.path,
              ),
              _buildStatCard(
                context,
                width: (constraints.maxWidth - 16.w) / 2,
                label: 'Statutory Rules Enabled',
                value: '18',
                description: '100% compliance',
                iconPath: Assets.icons.securityIcon.path,
              ),
              _buildStatCard(
                context,
                width: constraints.maxWidth,
                label: 'Last Published',
                value: '2 days ago',
                description: 'By Sarah Mitchell',
                iconPath: Assets.icons.calendarIcon.path,
              ),
            ],
          );
        }

        final cardWidth = (constraints.maxWidth - (16.w * 4)) / 5;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildStatCard(
              context,
              width: cardWidth,
              label: 'Active Countries',
              value: '9',
              description: '+2 this quarter',
              icon: Icons.public,
            ),
            _buildStatCard(
              context,
              width: cardWidth,
              label: 'Draft Configurations',
              value: '3',
              description: 'Pending review',
              iconPath: Assets.icons.descriptionIcon.path,
            ),
            _buildStatCard(
              context,
              width: cardWidth,
              label: 'Mandatory Components',
              value: '42',
              description: 'Across all countries',
              iconPath: Assets.icons.activeCheckIcon.path,
            ),
            _buildStatCard(
              context,
              width: cardWidth,
              label: 'Statutory Rules Enabled',
              value: '18',
              description: '100% compliance',
              iconPath: Assets.icons.securityIcon.path,
            ),
            _buildStatCard(
              context,
              width: cardWidth,
              label: 'Last Published',
              value: '2 days ago',
              description: 'By Sarah Mitchell',
              iconPath: Assets.icons.calendarIcon.path,
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required double width,
    required String label,
    required String value,
    required String description,
    IconData? icon,
    String? iconPath,
  }) {
    return SizedBox(
      width: width,
      child: DigifyStatCard(
        label: label,
        value: value,
        description: description,
        icon: icon,
        iconPath: iconPath,
        isDark: false,
      ),
    );
  }
}
