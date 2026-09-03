import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/models/cyber_security/identity_access/identity_user_model.dart';
import 'package:grc/core/services/toast_service.dart';

class UserAccessReviewDialog extends StatelessWidget {
  final IdentityUserModel user;

  const UserAccessReviewDialog({super.key, required this.user});

  static void show(BuildContext context, {required IdentityUserModel user}) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.75),
      builder: (context) => UserAccessReviewDialog(user: user),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 520.w,
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),
          margin: EdgeInsets.all(20.r),
          padding: EdgeInsets.all(22.r),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: const Color(0xFF1E293B), width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.6),
                blurRadius: 25,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'User Access Review',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Gap(2),
                        Text(
                          user.username,
                          style: TextStyle(
                            color: const Color(0xFF00B4D8),
                            fontSize: 12.sp,
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Color(0xFF94A3B8),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const Gap(16),

                // User Summary Card
                Container(
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: const Color(0xFF131D31),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: const Color(0xFF1E293B)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'DEPARTMENT / ROLE',
                            style: TextStyle(
                              color: const Color(0xFF64748B),
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Gap(2),
                          Text(
                            '${user.department} · ${user.role}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'RISK SCORE',
                            style: TextStyle(
                              color: const Color(0xFF64748B),
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Gap(2),
                          Text(
                            '${user.riskScore} / 100',
                            style: TextStyle(
                              color: user.riskScoreColor,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Gap(16),

                // Entitlement Checks
                Text(
                  'CURRENT ENTITLEMENTS & ACCESS POLICIES',
                  style: TextStyle(
                    color: const Color(0xFF64748B),
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
                const Gap(8),
                _buildEntitlementRow(
                  'Multi-Factor Authentication (MFA)',
                  user.hasMfa ? 'Enforced' : 'Missing',
                  user.hasMfa
                      ? const Color(0xFF10B981)
                      : const Color(0xFFEF4444),
                ),
                const Gap(6),
                _buildEntitlementRow(
                  'Privileged IAM Administrator Roles',
                  user.isPrivileged ? 'Assigned' : 'Standard User',
                  user.isPrivileged
                      ? const Color(0xFFF59E0B)
                      : const Color(0xFF94A3B8),
                ),
                const Gap(6),
                _buildEntitlementRow(
                  'Active Security Alerts',
                  '${user.alertsCount} Alerts Flagged',
                  user.alertsCount > 0
                      ? const Color(0xFFF97316)
                      : const Color(0xFF10B981),
                ),
                const Gap(20),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Color(0xFF94A3B8)),
                      ),
                    ),
                    const Gap(10),
                    if (!user.hasMfa) ...[
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          ToastService.show(
                            context: context,
                            message:
                                'MFA enforcement notice sent to ${user.username}',
                            type: ToastType.warning,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEF4444),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                        ),
                        child: const Text('Enforce MFA'),
                      ),
                      const Gap(8),
                    ],
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        ToastService.show(
                          context: context,
                          message:
                              'Access permissions certified for ${user.username}',
                          type: ToastType.success,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00B4D8),
                        foregroundColor: const Color(0xFF090E1A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                      ),
                      child: const Text('Certify Access'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEntitlementRow(String label, String value, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFF090E1A),
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFFCBD5E1))),
          Text(
            value,
            style: TextStyle(color: color, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
