import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/features/cyber_security/sub_modules/ai_soc_copilot/models/open_incident_item_model.dart';

class OpenIncidentsPanel extends StatelessWidget {
  final ValueChanged<String> onSelectIncident;

  const OpenIncidentsPanel({
    super.key,
    required this.onSelectIncident,
  });

  @override
  Widget build(BuildContext context) {
    final incidents = OpenIncidentItemModel.getMockOpenIncidents();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Text(
          'OPEN INCIDENTS',
          style: TextStyle(
            color: const Color(0xFF64748B),
            fontSize: 10.5.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
        const Gap(10),

        // List of Incident Cards
        ...incidents.map((incident) {
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

  const _OpenIncidentCard({
    required this.incident,
    required this.onTap,
  });

  @override
  State<_OpenIncidentCard> createState() => _OpenIncidentCardState();
}

class _OpenIncidentCardState extends State<_OpenIncidentCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
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
                ? const Color(0xFF1E293B).withValues(alpha: 0.9)
                : const Color(0xFF0F172A).withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: _isHovered
                  ? widget.incident.severityColor.withValues(alpha: 0.6)
                  : const Color(0xFF1E293B),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Badge & Incident ID row
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: widget.incident.severityColor.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(4.r),
                      border: Border.all(
                        color: widget.incident.severityColor.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Text(
                      widget.incident.severityLabel,
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
                      color: const Color(0xFF64748B),
                      fontSize: 10.5.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const Gap(6),
              // Title
              Text(
                widget.incident.title,
                style: TextStyle(
                  color: _isHovered
                      ? Colors.white
                      : const Color(0xFFCBD5E1),
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
