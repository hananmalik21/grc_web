import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/features/auth/presentation/providers/auth_provider.dart';
import 'live_clock_widget.dart';

class DashboardHeroBanner extends ConsumerWidget {
  const DashboardHeroBanner({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning,';
    if (hour < 17) return 'Good Afternoon,';
    return 'Good Evening,';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    // Resolve real user name
    String userName = authState.userFullName ?? '';
    if (userName.isEmpty) {
      userName = 'M Ikhlaq Ahmed'; // Default/demo display matching design
    }

    // Resolve role
    String userRole = authState.userRole ?? '';
    if (userRole.isEmpty) {
      userRole = 'System Administrator';
    }

    final greeting = _getGreeting();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;

        return Container(
          width: double.infinity,
          margin: EdgeInsets.only(bottom: 20.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF0284C7), // Sky Blue 600
                Color(0xFF0EA5E9), // Sky Blue 500
                Color(0xFF38BDF8), // Sky Blue 400
              ],
              stops: [0.0, 0.55, 1.0],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0284C7).withValues(alpha: 0.30),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              // Decorative background glow circles
              Positioned(
                top: -50,
                right: 120,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
              ),
              Positioned(
                bottom: -70,
                left: 80,
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF38BDF8).withValues(alpha: 0.12),
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 16.w : 28.w,
                  vertical: isMobile ? 16.h : 22.h,
                ),
                child: !isMobile
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Left text & branding
                          Expanded(
                            child: _buildGreetingContent(
                              greeting: greeting,
                              userName: userName,
                              isMobile: false,
                            ),
                          ),
                          Gap(16.w),
                          // Right status chips & live watch (anchored right, never moves)
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerRight,
                            child: _buildStatusAndClock(
                              userRole: userRole,
                              isMobile: false,
                            ),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildGreetingContent(
                            greeting: greeting,
                            userName: userName,
                            isMobile: true,
                          ),
                          Gap(16.h),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: _buildStatusAndClock(
                              userRole: userRole,
                              isMobile: true,
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGreetingContent({
    required String greeting,
    required String userName,
    required bool isMobile,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Pill Badge
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.16),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.28),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF4ADE80), // Pulsing green
                ),
              ),
              const Gap(7),
              Text(
                'DIGIFY GRC PLATFORM',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.95),
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.4,
                ),
              ),
            ],
          ),
        ),
        Gap(12.h),

        // Main Greeting & User Name
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '$greeting\n',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isMobile ? 18.sp : 24.sp,
                  fontWeight: FontWeight.w800,
                  height: 1.15,
                  letterSpacing: -0.5,
                ),
              ),
              TextSpan(
                text: userName,
                style: TextStyle(
                  color: const Color(0xFFE0F2FE), // Very light sky tint
                  fontSize: isMobile ? 18.sp : 24.sp,
                  fontWeight: FontWeight.w800,
                  height: 1.15,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ),
        Gap(10.h),

        // Subtitle
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 580),
          child: Text(
            'Manage governance, risks, compliance, and telemetry from a connected workspace with real-time cyber security intelligence.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.88),
              fontSize: isMobile ? 11.sp : 12.sp,
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusAndClock({
    required String userRole,
    required bool isMobile,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Status Chips Stack
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildStatusChip(
              icon: Icons.wifi_tethering,
              label: 'System Status',
              value: 'Online',
              valueColor: const Color(0xFF4ADE80),
              showDot: true,
            ),
            Gap(5.h),
            _buildStatusChip(
              icon: Icons.shield_outlined,
              label: 'Role',
              value: userRole,
            ),
            Gap(5.h),
            _buildStatusChip(
              icon: Icons.business_outlined,
              label: 'Group',
              value: 'Digify Solutions LLC',
            ),
            Gap(5.h),
            _buildStatusChip(
              icon: Icons.dashboard_customize_outlined,
              label: 'Modules',
              value: '13 Active',
            ),
          ],
        ),

        Gap(14.w),

        // Analog & Digital Live Clock
        const LiveClockWidget(size: 88),
      ],
    );
  }

  Widget _buildStatusChip({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
    bool showDot = false,
  }) {
    return Container(
      width: 210.w,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 15.sp,
            color: Colors.white.withValues(alpha: 0.85),
          ),
          Gap(9.w),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.82),
              fontSize: 11.5.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          if (showDot) ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: valueColor ?? Colors.white,
              ),
            ),
            const Gap(6),
          ],
          Flexible(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: valueColor ?? Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
