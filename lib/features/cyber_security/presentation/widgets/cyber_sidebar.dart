import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/features/cyber_security/presentation/providers/cyber_security_tab_state_provider.dart';

class CyberSidebarGroup {
  final String title;
  final List<CyberSidebarItemData> items;

  const CyberSidebarGroup({required this.title, required this.items});
}

class CyberSidebarItemData {
  final int tabIndex;
  final String label;
  final IconData icon;
  final int? badgeCount;

  const CyberSidebarItemData({
    required this.tabIndex,
    required this.label,
    required this.icon,
    this.badgeCount,
  });
}

class CyberSidebar extends ConsumerStatefulWidget {
  const CyberSidebar({super.key});

  @override
  ConsumerState<CyberSidebar> createState() => _CyberSidebarState();
}

class _CyberSidebarState extends ConsumerState<CyberSidebar> {
  final Map<String, bool> _collapsedGroups = {};

  static const List<CyberSidebarGroup> _groups = [
    CyberSidebarGroup(
      title: 'OVERVIEW',
      items: [
        CyberSidebarItemData(
          tabIndex: 0,
          label: 'Dashboard',
          icon: Icons.bar_chart_rounded,
          badgeCount: 4,
        ),
      ],
    ),
    CyberSidebarGroup(
      title: 'SECURITY POSTURE',
      items: [
        CyberSidebarItemData(
          tabIndex: 1,
          label: 'Cloud Posture',
          icon: Icons.cloud_outlined,
          badgeCount: 4,
        ),
        CyberSidebarItemData(
          tabIndex: 2,
          label: 'Identity & Access',
          icon: Icons.people_outline_rounded,
        ),
        CyberSidebarItemData(
          tabIndex: 3,
          label: 'Network Security',
          icon: Icons.hub_outlined,
        ),
        CyberSidebarItemData(
          tabIndex: 4,
          label: 'App & API',
          icon: Icons.language_rounded,
        ),
        CyberSidebarItemData(
          tabIndex: 5,
          label: 'Data Security',
          icon: Icons.storage_rounded,
        ),
      ],
    ),
    CyberSidebarGroup(
      title: 'SOC OPERATIONS',
      items: [
        CyberSidebarItemData(
          tabIndex: 6,
          label: 'AI SOC Copilot',
          icon: Icons.psychology_outlined,
        ),
        CyberSidebarItemData(
          tabIndex: 7,
          label: 'Threat Detection',
          icon: Icons.bolt_rounded,
          badgeCount: 3,
        ),
        CyberSidebarItemData(
          tabIndex: 8,
          label: 'Incidents',
          icon: Icons.error_outline_rounded,
          badgeCount: 2,
        ),
      ],
    ),
    CyberSidebarGroup(
      title: 'GRC & GOVERNANCE',
      items: [
        CyberSidebarItemData(
          tabIndex: 9,
          label: 'GRC & Compliance',
          icon: Icons.shield_outlined,
        ),
        CyberSidebarItemData(
          tabIndex: 10,
          label: 'AI Governance',
          icon: Icons.verified_user_outlined,
        ),
      ],
    ),
    CyberSidebarGroup(title: 'PLATFORM', items: []),
  ];

  @override
  Widget build(BuildContext context) {
    final selectedIndex = ref
        .watch(cyberSecurityTabStateProvider)
        .currentTabIndex;

    return Container(
      width: 235.w,
      decoration: BoxDecoration(
        color: const Color(0xFF090E1A),
        border: const Border(
          right: BorderSide(color: Color(0xFF1E293B), width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // CyberShield Brand Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
            child: Row(
              children: [
                Container(
                  width: 28.r,
                  height: 28.r,
                  decoration: BoxDecoration(
                    color: const Color(0xFF00B4D8).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6.r),
                    border: Border.all(
                      color: const Color(0xFF00B4D8).withValues(alpha: 0.4),
                    ),
                  ),
                  child: Icon(
                    Icons.security_rounded,
                    color: const Color(0xFF00B4D8),
                    size: 16.sp,
                  ),
                ),
                const Gap(10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'CYBERSHIELDAI',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        'Cloud Security Platform',
                        style: TextStyle(
                          color: const Color(0xFF64748B),
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: Color(0xFF1E293B), height: 1),

          // Scrollable Menu Groups
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
              itemCount: _groups.length,
              itemBuilder: (context, groupIndex) {
                final group = _groups[groupIndex];
                final isCollapsed = _collapsedGroups[group.title] ?? false;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Group Header
                    InkWell(
                      onTap: () {
                        setState(() {
                          _collapsedGroups[group.title] = !isCollapsed;
                        });
                      },
                      borderRadius: BorderRadius.circular(4.r),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 7.h,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              group.title,
                              style: TextStyle(
                                color: const Color(0xFF475569),
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                              ),
                            ),
                            Icon(
                              isCollapsed
                                  ? Icons.keyboard_arrow_down_rounded
                                  : Icons.keyboard_arrow_up_rounded,
                              size: 14.sp,
                              color: const Color(0xFF475569),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Items in Group
                    if (!isCollapsed)
                      ...group.items.map((item) {
                        final isSelected = selectedIndex == item.tabIndex;
                        return _buildMenuItem(item, isSelected);
                      }),
                    const Gap(8),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(CyberSidebarItemData item, bool isSelected) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            ref
                .read(cyberSecurityTabStateProvider.notifier)
                .setTabIndex(item.tabIndex);
          },
          borderRadius: BorderRadius.circular(6.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF0F2B38) : Colors.transparent,
              borderRadius: BorderRadius.circular(6.r),
              border: isSelected
                  ? Border.all(
                      color: const Color(0xFF00B4D8).withValues(alpha: 0.4),
                      width: 1,
                    )
                  : null,
            ),
            child: Row(
              children: [
                Icon(
                  item.icon,
                  size: 15.sp,
                  color: isSelected
                      ? const Color(0xFF00B4D8)
                      : const Color(0xFF94A3B8),
                ),
                const Gap(10),
                Expanded(
                  child: Text(
                    item.label,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF94A3B8),
                      fontSize: 12.sp,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ),
                if (item.badgeCount != null)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.w,
                      vertical: 1.5.h,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF00B4D8).withValues(alpha: 0.25)
                          : (item.badgeCount! > 2 && item.tabIndex != 0
                                ? const Color(0xFFEF4444).withValues(alpha: 0.2)
                                : const Color(0xFF1E293B)),
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF00B4D8).withValues(alpha: 0.5)
                            : (item.badgeCount! > 2 && item.tabIndex != 0
                                  ? const Color(
                                      0xFFEF4444,
                                    ).withValues(alpha: 0.4)
                                  : const Color(0xFF334155)),
                        width: 0.8,
                      ),
                    ),
                    child: Text(
                      item.badgeCount.toString(),
                      style: TextStyle(
                        color: isSelected
                            ? const Color(0xFF00B4D8)
                            : (item.badgeCount! > 2 && item.tabIndex != 0
                                  ? const Color(0xFFEF4444)
                                  : const Color(0xFF94A3B8)),
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
