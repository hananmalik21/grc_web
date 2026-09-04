import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/models/cyber_security/ai_soc_copilot/ai_soc_copilot_models.dart';
import 'package:grc/core/theme/theme_extensions.dart';

class QuickInvestigationsPanel extends StatelessWidget {
  final ValueChanged<String> onSelectPrompt;

  const QuickInvestigationsPanel({super.key, required this.onSelectPrompt});

  static const List<QuickInvestigationModel> defaultInvestigations = [
    QuickInvestigationModel(
      id: 'qi-1',
      title: 'Investigate INC-2847 suspicious login',
      queryPrompt: 'Investigate INC-2847 suspicious login',
    ),
    QuickInvestigationModel(
      id: 'qi-2',
      title: 'Analyze public S3 bucket F-2401',
      queryPrompt:
          'Analyze public S3 bucket F-2401 for sensitive data exposure',
    ),
    QuickInvestigationModel(
      id: 'qi-3',
      title: 'Show privileged access risks',
      queryPrompt: 'Show privileged access risks and excessive IAM permissions',
    ),
    QuickInvestigationModel(
      id: 'qi-4',
      title: 'What is our compliance posture?',
      queryPrompt: 'What is our compliance posture against NIST CSF and SOC 2?',
    ),
    QuickInvestigationModel(
      id: 'qi-5',
      title: 'Summarize malware incident INC-2842',
      queryPrompt: 'Summarize malware incident INC-2842 and containment status',
    ),
    QuickInvestigationModel(
      id: 'qi-6',
      title: 'Investigate SharePoint data download',
      queryPrompt: 'Investigate SharePoint data download',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'QUICK INVESTIGATIONS',
          style: TextStyle(
            color: context.isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            fontSize: 10.5.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
        const Gap(10),
        ...defaultInvestigations.map((item) {
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

  const _QuickInvestigationCard({required this.item, required this.onTap});

  @override
  State<_QuickInvestigationCard> createState() =>
      _QuickInvestigationCardState();
}

class _QuickInvestigationCardState extends State<_QuickInvestigationCard> {
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
                  ? AppColors.primaryLight.withValues(alpha: 0.6)
                  : (isDark ? const Color(0xFF2D2D2F) : const Color(0xFFE2E8F0)),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.search_rounded,
                size: 14.sp,
                color: _isHovered
                    ? AppColors.primaryLight
                    : (isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
              ),
              const Gap(10),
              Expanded(
                child: Text(
                  widget.item.title,
                  style: TextStyle(
                    color: _isHovered
                        ? (isDark ? Colors.white : AppColors.primaryLight)
                        : (isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569)),
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
