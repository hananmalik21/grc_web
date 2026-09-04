import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/models/cyber_security/ai_soc_copilot/ai_soc_copilot_models.dart';
import 'package:grc/core/theme/theme_extensions.dart';

class OpenIncidentsPanel extends StatelessWidget {
  final ValueChanged<String> onSelectIncident;

  const OpenIncidentsPanel({super.key, required this.onSelectIncident});

  static const List<OpenIncidentItemModel> defaultIncidents = [
    OpenIncidentItemModel(
      id: 'inc-1',
      incidentNumber: 'INC-2847',
      title: 'Suspicious Login from Tor Exit Node',
      severity: 'HIGH',
      severityColor: AppColors.cyberHigh,
      queryPrompt: 'Investigate INC-2847 suspicious login',
    ),
    OpenIncidentItemModel(
      id: 'inc-2',
      incidentNumber: 'INC-2846',
      title: 'Mass File Download — SharePoint Online',
      severity: 'CRITICAL',
      severityColor: AppColors.cyberCritical,
      queryPrompt: 'Investigate SharePoint data download',
    ),
    OpenIncidentItemModel(
      id: 'inc-3',
      incidentNumber: 'INC-2843',
      title: 'Privilege Escalation — IAM Role Modification',
      severity: 'HIGH',
      severityColor: AppColors.cyberHigh,
      queryPrompt:
          'Investigate INC-2843 IAM privilege escalation and unauthorized role binding',
    ),
    OpenIncidentItemModel(
      id: 'inc-4',
      incidentNumber: 'INC-2840',
      title: 'Unusual Database Query Volume Spike',
      severity: 'MEDIUM',
      severityColor: AppColors.cyberMedium,
      queryPrompt:
          'Investigate INC-2840 unusual database query volume spike on RDS cluster',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'OPEN INCIDENTS',
          style: TextStyle(
            color: context.isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            fontSize: 10.5.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
        const Gap(10),
        ...defaultIncidents.map((incident) {
          return Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: _OpenIncidentCard(
              incident: incident,
              onTap: () => onSelectIncident(incident.queryPrompt),
            ),
          );
        }),
      ],
    );
  }
}

class _OpenIncidentCard extends StatefulWidget {
  final OpenIncidentItemModel incident;
  final VoidCallback onTap;

  const _OpenIncidentCard({required this.incident, required this.onTap});

  @override
  State<_OpenIncidentCard> createState() => _OpenIncidentCardState();
}

class _OpenIncidentCardState extends State<_OpenIncidentCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: _isHovered
                ? (isDark ? const Color(0xFF2D2D2F) : const Color(0xFFF1F5F9))
                : (isDark ? const Color(0xFF1C1C1E) : Colors.white),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: _isHovered
                  ? widget.incident.severityColor.withValues(alpha: 0.6)
                  : (isDark ? const Color(0xFF2D2D2F) : const Color(0xFFE2E8F0)),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: widget.incident.severityColor.withValues(
                        alpha: 0.18,
                      ),
                      borderRadius: BorderRadius.circular(4.r),
                      border: Border.all(
                        color: widget.incident.severityColor.withValues(
                          alpha: 0.4,
                        ),
                      ),
                    ),
                    child: Text(
                      widget.incident.severity,
                      style: TextStyle(
                        color: widget.incident.severityColor,
                        fontSize: 9.5.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                  const Gap(8),
                  Text(
                    widget.incident.incidentNumber,
                    style: TextStyle(
                      color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                      fontSize: 10.5.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const Gap(6),
              Text(
                widget.incident.title,
                style: TextStyle(
                  color: _isHovered
                      ? (isDark ? Colors.white : AppColors.primaryLight)
                      : (isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569)),
                  fontSize: 11.5.sp,
                  fontWeight: FontWeight.w500,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
