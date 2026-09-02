import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/models/cyber_security/identity_access/identity_user_model.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/features/cyber_security/presentation/widgets/cyber_screen_layout.dart';
import 'package:grc/features/cyber_security/sub_modules/identity_access/dialogs/user_access_review_dialog.dart';
import 'package:grc/features/cyber_security/sub_modules/identity_access/widgets/identity_kpi_row.dart';
import 'package:grc/features/cyber_security/sub_modules/identity_access/widgets/identity_users_table.dart';

class IdentityAccessScreen extends StatefulWidget {
  const IdentityAccessScreen({super.key});

  @override
  State<IdentityAccessScreen> createState() => _IdentityAccessScreenState();
}

class _IdentityAccessScreenState extends State<IdentityAccessScreen> {
  final List<IdentityUserModel> _users = const [
    IdentityUserModel(
      username: 'carlos.rodriguez',
      department: 'Cloud Platform',
      role: 'Cloud Admin',
      riskScore: 94,
      riskScoreColor: Color(0xFFEF4444),
      alertsCount: 5,
      hasMfa: true,
      isPrivileged: true,
      status: 'active',
      statusColor: Color(0xFF10B981),
    ),
    IdentityUserModel(
      username: 'ashley.wong',
      department: 'IT Operations',
      role: 'Sys Admin',
      riskScore: 87,
      riskScoreColor: Color(0xFFEF4444),
      alertsCount: 3,
      hasMfa: true,
      isPrivileged: true,
      status: 'active',
      statusColor: Color(0xFF10B981),
    ),
    IdentityUserModel(
      username: 'derek.okonkwo',
      department: 'Finance',
      role: 'AP Manager',
      riskScore: 76,
      riskScoreColor: Color(0xFFF97316),
      alertsCount: 2,
      hasMfa: false,
      isPrivileged: false,
      status: 'active',
      statusColor: Color(0xFF10B981),
    ),
    IdentityUserModel(
      username: 'svc-ci-pipeline',
      department: 'DevOps',
      role: 'Service Account',
      riskScore: 72,
      riskScoreColor: Color(0xFFF97316),
      alertsCount: 4,
      hasMfa: false,
      isPrivileged: true,
      status: 'active',
      statusColor: Color(0xFF10B981),
    ),
    IdentityUserModel(
      username: 'jen.martinez',
      department: 'Finance',
      role: 'Finance Analyst',
      riskScore: 60,
      riskScoreColor: Color(0xFFF97316),
      alertsCount: 1,
      hasMfa: false,
      isPrivileged: false,
      status: 'active',
      statusColor: Color(0xFF10B981),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return CyberScreenLayout(
      title: 'Identity & Access Security',
      subtitle: 'User risk scores, privilege analysis, and access anomalies',
      actions: [
        AppButton(
          label: 'Start Review',
          type: AppButtonType.primary,
          size: AppButtonSize.sm,
          onPressed: () {
            if (_users.isNotEmpty) {
              UserAccessReviewDialog.show(context, user: _users.first);
            }
          },
        ),
        const Gap(8),
        AppButton(
          label: 'Export Report',
          type: AppButtonType.secondary,
          size: AppButtonSize.sm,
          onPressed: () {
            ToastService.show(
              context: context,
              message: 'Identity risk & privilege report exported.',
              type: ToastType.success,
            );
          },
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const IdentityKpiRow(),
          const Gap(24),
          IdentityUsersTable(
            users: _users,
            onReviewUser: (user) => UserAccessReviewDialog.show(context, user: user),
          ),
        ],
      ),
    );
  }
}
