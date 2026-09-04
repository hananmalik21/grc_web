import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/enums/nav_item_ids.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'dashboard_button_model.dart';

class ModernModuleCard extends StatefulWidget {
  final DashboardButton button;
  final VoidCallback onTap;
  final bool isDragging;
  final int? index;

  const ModernModuleCard({
    super.key,
    required this.button,
    required this.onTap,
    this.isDragging = false,
    this.index,
  });

  @override
  State<ModernModuleCard> createState() => _ModernModuleCardState();
}

class _ModernModuleCardState extends State<ModernModuleCard> {
  bool _isHovered = false;

  IconData _fallbackIconForId(String id) {
    if (id == NavItemIds.dashboard) return Icons.analytics_outlined;
    if (id == NavItemIds.cyberSecurityButton || id.contains('cyber')) return Icons.shield_outlined;
    if (id == NavItemIds.grc || id.contains('grc')) return Icons.verified_user_outlined;
    if (id == NavItemIds.securityManager || id.contains('security')) return Icons.admin_panel_settings_outlined;
    if (id == NavItemIds.enterpriseStructureButton || id.contains('enterprise')) return Icons.apartment_rounded;
    if (id.contains('risk') || id.contains('assess')) return Icons.assessment_outlined;
    if (id.contains('threat')) return Icons.radar_outlined;
    if (id.contains('incident')) return Icons.crisis_alert_outlined;
    if (id.contains('cloud')) return Icons.cloud_done_outlined;
    if (id.contains('identity')) return Icons.badge_outlined;
    if (id.contains('ai')) return Icons.psychology_outlined;
    if (id.contains('emergency')) return Icons.error_outline_rounded;
    if (id.contains('receipt') || id.contains('pay')) return Icons.receipt_long_outlined;
    if (id.contains('patient') || id.contains('record')) return Icons.description_outlined;
    return Icons.widgets_outlined;
  }

  String _descriptionForButton(DashboardButton button) {
    if (button.subtitle != null && button.subtitle!.isNotEmpty) {
      return button.subtitle!;
    }
    final id = button.id;
    if (id == NavItemIds.dashboard) return 'Analytics & reports';
    if (id == NavItemIds.cyberSecurityButton) return 'Threat detection & posture';
    if (id == NavItemIds.grc) return 'Frameworks & risk register';
    if (id == NavItemIds.securityManager) return 'IAM posture & access controls';
    if (id == NavItemIds.enterpriseStructureButton) return 'Workforce & hierarchy';
    return 'Manage operations';
  }

  @override
  Widget build(BuildContext context) {
    final button = widget.button;
    final isDark = context.isDark;
    final description = _descriptionForButton(button);
    final isHover = _isHovered && !widget.isDragging;

    // Clean single-line title for card display
    final title = button.label.replaceAll('\n', ' ');
    final indexStr = widget.index != null
        ? widget.index!.toString().padLeft(2, '0')
        : '';

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          // Smooth subtle zoom on hover
          transform: isHover
              ? (Matrix4.identity()..scale(1.028))
              : Matrix4.identity(),
          transformAlignment: Alignment.center,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
            borderRadius: BorderRadius.circular(28.r),
            // No borders
            boxShadow: isDark
                ? []
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28.r),
            child: Stack(
              children: [
                // Smooth full-card sky blue fill on hover
                Positioned.fill(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Stack(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOutCubic,
                            width: isHover ? constraints.maxWidth : 0,
                            height: constraints.maxHeight,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE0F2FE).withValues(alpha: 0.5), // Sky blue fill
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                // Main Card Content
              Padding(
                padding: EdgeInsets.all(18.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Row: Soft Squircle Icon Badge + Card Index Number
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 42.r,
                          height: 42.r,
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF2D2D2F)
                                : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(14.r),
                            // No border
                          ),
                          child: Center(
                            child: button.icon.isNotEmpty
                                ? DigifyAsset(
                                    assetPath: button.icon,
                                    width: 20.r,
                                    height: 20.r,
                                    color: isDark
                                        ? Colors.white70
                                        : const Color(0xFF475569),
                                  )
                                : Icon(
                                    _fallbackIconForId(button.id),
                                    size: 20.r,
                                    color: isDark
                                        ? Colors.white70
                                        : const Color(0xFF475569),
                                  ),
                          ),
                        ),
                        if (indexStr.isNotEmpty)
                          Text(
                            indexStr,
                            style: TextStyle(
                              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                              fontSize: 10.sp, // Minimized per request
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                            ),
                          ),
                      ],
                    ),

                    const Spacer(),

                    // Bottom Row: Title, Subtitle & Arrow
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                                  fontSize: 13.sp, // Minimized per request
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -0.2,
                                ),
                              ),
                              const Gap(4),
                              Text(
                                description,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.chevron_right_rounded,
                          size: 20.sp,
                          color: const Color(0xFFCBD5E1),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Sky Blue Line Fill Under the Card on Hover (as in reference image)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 240),
                        curve: Curves.easeOutCubic,
                        height: 3.5,
                        width: isHover ? constraints.maxWidth : 0.0,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0284C7),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20.r),
                            bottomRight: Radius.circular(20.r),
                          ),
                          boxShadow: isHover
                              ? [
                                  BoxShadow(
                                    color: const Color(0xFF0284C7).withValues(alpha: 0.6),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                      ),
                    );
                  }
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
