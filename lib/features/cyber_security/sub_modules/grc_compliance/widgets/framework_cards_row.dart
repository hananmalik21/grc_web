import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/models/cyber_security/grc_compliance/compliance_framework_model.dart';

class FrameworkCardsRow extends StatelessWidget {
  final List<ComplianceFrameworkModel> frameworks;
  final String selectedFrameworkId;
  final ValueChanged<ComplianceFrameworkModel> onSelectFramework;

  const FrameworkCardsRow({
    super.key,
    required this.frameworks,
    required this.selectedFrameworkId,
    required this.onSelectFramework,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 950;

        if (isNarrow) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: frameworks.map((fw) {
                final isSelected = fw.id == selectedFrameworkId;
                return Padding(
                  padding: EdgeInsets.only(right: 12.w),
                  child: SizedBox(
                    width: 180.w,
                    child: _FrameworkCard(
                      framework: fw,
                      isSelected: isSelected,
                      onTap: () => onSelectFramework(fw),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        }

        return Row(
          children: frameworks.map((fw) {
            final isSelected = fw.id == selectedFrameworkId;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: fw == frameworks.last ? 0 : 12.w,
                ),
                child: _FrameworkCard(
                  framework: fw,
                  isSelected: isSelected,
                  onTap: () => onSelectFramework(fw),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _FrameworkCard extends StatefulWidget {
  final ComplianceFrameworkModel framework;
  final bool isSelected;
  final VoidCallback onTap;

  const _FrameworkCard({
    required this.framework,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_FrameworkCard> createState() => _FrameworkCardState();
}

class _FrameworkCardState extends State<_FrameworkCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final fw = widget.framework;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 125.h,
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? const Color(0xFF0F2B3E).withValues(alpha: 0.5)
                : _isHovered
                ? const Color(0xFF1E293B).withValues(alpha: 0.8)
                : const Color(0xFF0F172A).withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: widget.isSelected
                  ? fw.progressColor.withValues(alpha: 0.8)
                  : _isHovered
                  ? const Color(0xFF334155)
                  : const Color(0xFF1E293B),
              width: widget.isSelected ? 1.5 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Framework Name
              Text(
                fw.name,
                style: TextStyle(
                  color: fw.progressColor,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              // Large Score Percentage
              Text(
                '${fw.readinessScore}%',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  height: 1,
                ),
              ),

              // Progress Bar
              ClipRRect(
                borderRadius: BorderRadius.circular(2.r),
                child: LinearProgressIndicator(
                  value: fw.readinessScore / 100,
                  backgroundColor: const Color(0xFF1E293B),
                  valueColor: AlwaysStoppedAnimation<Color>(fw.progressColor),
                  minHeight: 3.5.h,
                ),
              ),

              // Passing / Failing / Partial breakdown badges
              Row(
                children: [
                  Text(
                    '${fw.passingCount}p',
                    style: TextStyle(
                      color: const Color(0xFF10B981),
                      fontSize: 10.5.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Gap(6),
                  Text(
                    '${fw.failingCount}f',
                    style: TextStyle(
                      color: const Color(0xFFEF4444),
                      fontSize: 10.5.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Gap(6),
                  Text(
                    '${fw.partialCount}~',
                    style: TextStyle(
                      color: const Color(0xFFF59E0B),
                      fontSize: 10.5.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
