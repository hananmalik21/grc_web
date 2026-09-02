import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/features/cyber_security/sub_modules/incidents/dialogs/create_incident_dialog.dart';
import 'package:grc/features/cyber_security/sub_modules/incidents/dialogs/incident_ai_triage_dialog.dart';
import 'package:grc/features/cyber_security/sub_modules/incidents/models/incident_item_model.dart';
import 'package:grc/features/cyber_security/sub_modules/incidents/widgets/incident_kpi_row.dart';
import 'package:grc/features/cyber_security/sub_modules/incidents/widgets/incidents_table.dart';

class IncidentsScreen extends StatefulWidget {
  const IncidentsScreen({super.key});

  @override
  State<IncidentsScreen> createState() => _IncidentsScreenState();
}

class _IncidentsScreenState extends State<IncidentsScreen> {
  late List<IncidentItemModel> _incidents;

  @override
  void initState() {
    super.initState();
    _incidents = List.from(IncidentItemModel.getMockIncidents());
  }

  void _openCreateIncidentDialog() {
    showDialog(
      context: context,
      builder: (ctx) => CreateIncidentDialog(
        onCreated: (newIncident) {
          setState(() {
            _incidents.insert(0, newIncident);
          });
        },
      ),
    );
  }

  void _exportIncidents() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Color(0xFF131D31),
        content: Text(
          'Incident report exported to CSV and compliance archive.',
          style: TextStyle(color: Color(0xFF00B4D8)),
        ),
      ),
    );
  }

  void _handleTakeOwnership(IncidentItemModel incident) {
    setState(() {
      final index = _incidents.indexWhere((i) => i.id == incident.id);
      if (index != -1) {
        _incidents[index] = _incidents[index].copyWith(
          owner: 'P. Nair',
          status: IncidentStatus.investigating,
        );
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF131D31),
        content: Text(
          'Assigned ${incident.id} to P. Nair (Status: Investigating)',
          style: const TextStyle(color: Color(0xFF00B4D8)),
        ),
      ),
    );
  }

  void _handleTriage(IncidentItemModel incident) {
    showDialog(
      context: context,
      builder: (ctx) => IncidentAiTriageDialog(
        incident: incident,
        onExecuteContainment: () {
          setState(() {
            final index = _incidents.indexWhere((i) => i.id == incident.id);
            if (index != -1) {
              _incidents[index] = _incidents[index].copyWith(
                status: IncidentStatus.contained,
              );
            }
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;
    final padding = ResponsiveHelper.getPagePadding(context);

    final openCount =
        _incidents.where((i) => i.status == IncidentStatus.open).length;
    final investigatingCount =
        _incidents.where((i) => i.status == IncidentStatus.investigating).length;
    final containedCount =
        _incidents.where((i) => i.status == IncidentStatus.contained).length;
    final resolvedCount =
        _incidents.where((i) => i.status == IncidentStatus.resolved).length +
            _incidents.where((i) => i.status == IncidentStatus.closed).length;

    final titleSection = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Incident Response',
          style: TextStyle(
            color: Colors.white,
            fontSize: isMobile ? 18.sp : 22.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Gap(4),
        Text(
          'Security incident queue with AI-assisted triage and investigation',
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
        // + New Incident Button
        InkWell(
          onTap: _openCreateIncidentDialog,
          borderRadius: BorderRadius.circular(6.r),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 14.w,
              vertical: 8.h,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF131D31),
              borderRadius: BorderRadius.circular(6.r),
              border: Border.all(color: const Color(0xFF1E293B)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.add_rounded,
                  size: 14.sp,
                  color: const Color(0xFFCBD5E1),
                ),
                const Gap(6),
                Text(
                  'New Incident',
                  style: TextStyle(
                    color: const Color(0xFFCBD5E1),
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        const Gap(10),

        // Export Button
        InkWell(
          onTap: _exportIncidents,
          borderRadius: BorderRadius.circular(6.r),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 14.w,
              vertical: 8.h,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF131D31),
              borderRadius: BorderRadius.circular(6.r),
              border: Border.all(color: const Color(0xFF1E293B)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.download_rounded,
                  size: 14.sp,
                  color: const Color(0xFFCBD5E1),
                ),
                const Gap(6),
                Text(
                  'Export',
                  style: TextStyle(
                    color: const Color(0xFFCBD5E1),
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
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
          IncidentKpiRow(
            openCount: openCount,
            investigatingCount: investigatingCount,
            containedCount: containedCount,
            resolvedCount: resolvedCount,
          ),
          const Gap(24),

          // Incidents Table with Status Filter Tabs
          IncidentsTable(
            incidents: _incidents,
            onTakeOwnership: _handleTakeOwnership,
            onTriage: _handleTriage,
          ),
        ],
      ),
    );
  }
}
