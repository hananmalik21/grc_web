import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/models/cyber_security/identity_access/identity_user_model.dart';
import 'package:grc/core/permissions/permission_gate.dart';
import 'package:grc/core/permissions/perm_keys.dart';
import 'package:grc/core/permissions/permission_service.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/cyber_security/presentation/widgets/cyber_screen_layout.dart';
import 'package:grc/features/cyber_security/sub_modules/identity_access/dialogs/user_access_review_dialog.dart';
import 'package:grc/features/cyber_security/sub_modules/identity_access/widgets/identity_kpi_row.dart';
import 'package:grc/features/cyber_security/sub_modules/identity_access/widgets/identity_users_table.dart';
import 'package:grc/features/cyber_security/data/models/iam_posture_dto.dart';
import 'package:grc/features/cyber_security/data/repositories/iam_posture_repository.dart';
import 'package:grc/features/cyber_security/presentation/providers/iam_posture_provider.dart';

class IdentityAccessScreen extends ConsumerWidget {
  const IdentityAccessScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!PermissionService.instance.can(CyberPermKeys.iamPostureRead)) {
      return PermissionGate(
        permKey: CyberPermKeys.iamPostureRead,
        fallback: _buildPermissionDenied(),
        child: const SizedBox.shrink(),
      );
    }
    final posture = ref.watch(iamPostureProvider);
    return posture.when(
      loading: () => _buildLayout(context, const [], null),
      error: (error, stack) => _buildLayout(context, const [], null),
      data: (data) =>
          _buildLayout(context, data.principals.map(_toUser).toList(), data),
    );
  }

  Widget _buildPermissionDenied() {
    return CyberScreenLayout(
      title: 'Identity & Access Security',
      subtitle: 'You do not have permission to view IAM posture.',
      child: const SizedBox.shrink(),
    );
  }

  IdentityUserModel _toUser(IamPrincipalDto principal) {
    final riskColor = principal.isPrivileged
        ? const Color(0xFFF97316)
        : const Color(0xFF38BDF8);
    final status = principal.status.toLowerCase();
    return IdentityUserModel(
      username: principal.displayName.isEmpty
          ? principal.externalPrincipalId
          : principal.displayName,
      department: 'Not available',
      role: principal.principalType,
      riskScore: 0,
      riskScoreColor: riskColor,
      alertsCount: 0,
      hasMfa: principal.mfaEnrolled ?? false,
      isPrivileged: principal.isPrivileged,
      status: status,
      statusColor: status == 'active'
          ? const Color(0xFF10B981)
          : const Color(0xFF94A3B8),
    );
  }

  Widget _buildLayout(
    BuildContext context,
    List<IdentityUserModel> users,
    IamPostureData? data,
  ) {
    return CyberScreenLayout(
      title: 'Identity & Access Security',
      subtitle: 'User risk scores, privilege analysis, and access anomalies',
      actions: [
        InkWell(
          onTap: () {
            if (users.isNotEmpty) {
              UserAccessReviewDialog.show(context, user: users.first);
            }
          },
          borderRadius: BorderRadius.circular(20.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: const Color(0xFF00B4D8),
              borderRadius: BorderRadius.circular(20.r),
            ),
            alignment: Alignment.center,
            child: Text(
              'Start Review',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const Gap(8),
        InkWell(
          onTap: () {
            ToastService.show(
              context: context,
              message: 'Identity risk & privilege report exported.',
              type: ToastType.success,
            );
          },
          borderRadius: BorderRadius.circular(20.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: context.isDark ? const Color(0xFF333333) : const Color(0xFFE2E8F0),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              'Export Report',
              style: TextStyle(
                color: context.isDark ? const Color(0xFFE2E8F0) : const Color(0xFF0F172A),
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IdentityKpiRow(
            totalUsers: data?.summary.totalPrincipals ?? 0,
            privilegedUsers: users.where((user) => user.isPrivileged).length,
            noMfa: data?.summary.withoutMfa ?? 0,
          ),
          const Gap(24),
          IdentityUsersTable(
            users: users,
            onReviewUser: (user) =>
                UserAccessReviewDialog.show(context, user: user),
          ),
        ],
      ),
    );
  }
}
