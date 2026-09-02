import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/features/cyber_security/sub_modules/identity_access/dialogs/user_access_review_dialog.dart';
import 'package:grc/features/cyber_security/sub_modules/identity_access/models/identity_user_model.dart';
import 'package:grc/features/cyber_security/sub_modules/identity_access/widgets/identity_kpi_row.dart';
import 'package:grc/features/cyber_security/sub_modules/identity_access/widgets/identity_users_table.dart';

class IdentityAccessScreen extends StatefulWidget {
  const IdentityAccessScreen({super.key});

  @override
  State<IdentityAccessScreen> createState() => _IdentityAccessScreenState();
}

class _IdentityAccessScreenState extends State<IdentityAccessScreen> {
  final List<IdentityUserModel> _users = IdentityUserModel.getMockUsers();

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;
    final padding = ResponsiveHelper.getPagePadding(context);

    final titleSection = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Identity & Access Security',
          style: TextStyle(
            color: Colors.white,
            fontSize: isMobile ? 18.sp : 22.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Gap(3),
        Text(
          'User risk scores, privilege analysis, and access anomalies',
          style: TextStyle(
            color: const Color(0xFF94A3B8),
            fontSize: isMobile ? 11.sp : 12.sp,
          ),
        ),
      ],
    );

    final actionsSection = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHeaderButton(
          icon: Icons.add,
          label: 'Start Review',
          onTap: () {
            if (_users.isNotEmpty) {
              UserAccessReviewDialog.show(context, user: _users.first);
            }
          },
        ),
        const Gap(10),
        _buildHeaderButton(
          icon: Icons.download_rounded,
          label: 'Export',
          onTap: () {},
        ),
      ],
    );

    return SingleChildScrollView(
      padding: padding.copyWith(bottom: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          if (isMobile) ...[
            titleSection,
            const Gap(12),
            actionsSection,
          ] else ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: titleSection),
                actionsSection,
              ],
            ),
          ],

          const Gap(20),

          // 4 Top KPI Cards
          const IdentityKpiRow(),

          const Gap(24),

          // User Access Table
          IdentityUsersTable(
            users: _users,
            onReviewUser: (user) {
              UserAccessReviewDialog.show(context, user: user);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
        decoration: BoxDecoration(
          color: const Color(0xFF131D31),
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(color: const Color(0xFF1E293B)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14.sp, color: const Color(0xFFCBD5E1)),
            const Gap(6),
            Text(
              label,
              style: TextStyle(
                color: const Color(0xFFCBD5E1),
                fontSize: 11.5.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
