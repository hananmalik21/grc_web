import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/features/cyber_security/sub_modules/ai_governance/models/ai_governance_models.dart';

class PromptAuditLogTable extends StatelessWidget {
  final List<AiPromptLogItem> logs;

  const PromptAuditLogTable({
    super.key,
    required this.logs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        children: [
          // Header Row
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: const Color(0xFF0B132B).withValues(alpha: 0.8),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.r),
                topRight: Radius.circular(10.r),
              ),
              border: const Border(
                bottom: BorderSide(color: Color(0xFF1E293B)),
              ),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 100.w,
                  child: _buildHeaderLabel('PROMPT ID'),
                ),
                SizedBox(
                  width: 120.w,
                  child: _buildHeaderLabel('USER'),
                ),
                Expanded(
                  flex: 4,
                  child: _buildHeaderLabel('ACTION / QUERY'),
                ),
                SizedBox(
                  width: 120.w,
                  child: _buildHeaderLabel('MODEL'),
                ),
                SizedBox(
                  width: 90.w,
                  child: _buildHeaderLabel('TIME'),
                ),
                SizedBox(
                  width: 90.w,
                  child: _buildHeaderLabel('STATUS'),
                ),
              ],
            ),
          ),

          // Data Rows
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: logs.length,
            separatorBuilder: (context, index) => const Divider(
              color: Color(0xFF1E293B),
              height: 1,
            ),
            itemBuilder: (context, index) {
              final item = logs[index];
              return _PromptLogRow(item: item);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        color: const Color(0xFF64748B),
        fontSize: 10.5.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
      ),
    );
  }
}

class _PromptLogRow extends StatefulWidget {
  final AiPromptLogItem item;

  const _PromptLogRow({required this.item});

  @override
  State<_PromptLogRow> createState() => _PromptLogRowState();
}

class _PromptLogRowState extends State<_PromptLogRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        color: _isHovered
            ? const Color(0xFF1E293B).withValues(alpha: 0.45)
            : Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 13.h),
        child: Row(
          children: [
            // Prompt ID
            SizedBox(
              width: 100.w,
              child: Text(
                item.promptId,
                style: TextStyle(
                  color: const Color(0xFF00B4D8),
                  fontSize: 11.5.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // User
            SizedBox(
              width: 120.w,
              child: Text(
                item.user,
                style: TextStyle(
                  color: const Color(0xFF94A3B8),
                  fontSize: 11.5.sp,
                ),
              ),
            ),

            // Action / Query
            Expanded(
              flex: 4,
              child: Text(
                item.actionQuery,
                style: TextStyle(
                  color: const Color(0xFFF1F5F9),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Model
            SizedBox(
              width: 120.w,
              child: Text(
                item.model,
                style: TextStyle(
                  color: const Color(0xFF818CF8),
                  fontSize: 11.5.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            // Time
            SizedBox(
              width: 90.w,
              child: Text(
                item.timeAgo,
                style: TextStyle(
                  color: const Color(0xFF64748B),
                  fontSize: 11.sp,
                ),
              ),
            ),

            // Status Indicator with dot
            SizedBox(
              width: 90.w,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6.w,
                    height: 6.w,
                    decoration: const BoxDecoration(
                      color: Color(0xFF10B981),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const Gap(6),
                  Text(
                    item.status,
                    style: TextStyle(
                      color: const Color(0xFF10B981),
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
