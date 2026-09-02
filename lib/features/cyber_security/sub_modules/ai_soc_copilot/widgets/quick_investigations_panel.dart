import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/features/cyber_security/sub_modules/ai_soc_copilot/models/quick_investigation_model.dart';

class QuickInvestigationsPanel extends StatelessWidget {
  final ValueChanged<String> onSelectPrompt;

  const QuickInvestigationsPanel({
    super.key,
    required this.onSelectPrompt,
  });

  @override
  Widget build(BuildContext context) {
    final items = QuickInvestigationModel.getQuickInvestigations();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          'QUICK INVESTIGATIONS',
          style: TextStyle(
            color: const Color(0xFF64748B),
            fontSize: 10.5.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
        const Gap(10),

        // List of Cards
        ...items.map((item) {
          return Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: _QuickInvestigationCard(
              item: item,
              onTap: () => onSelectPrompt(item.queryPrompt),
            ),
          );
        }),
      ],
    );
  }
}

class _QuickInvestigationCard extends StatefulWidget {
  final QuickInvestigationModel item;
  final VoidCallback onTap;

  const _QuickInvestigationCard({
    required this.item,
    required this.onTap,
  });

  @override
  State<_QuickInvestigationCard> createState() =>
      _QuickInvestigationCardState();
}

class _QuickInvestigationCardState extends State<_QuickInvestigationCard> {
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
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 11.h),
          decoration: BoxDecoration(
            color: _isHovered
                ? const Color(0xFF1E293B).withValues(alpha: 0.9)
                : const Color(0xFF0F172A).withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: _isHovered
                  ? const Color(0xFF38BDF8).withValues(alpha: 0.5)
                  : const Color(0xFF1E293B),
            ),
          ),
          child: Text(
            widget.item.title,
            style: TextStyle(
              color: _isHovered
                  ? const Color(0xFF38BDF8)
                  : const Color(0xFF94A3B8),
              fontSize: 11.5.sp,
              fontWeight: FontWeight.w500,
              height: 1.35,
            ),
          ),
        ),
      ),
    );
  }
}
