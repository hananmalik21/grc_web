import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CyberSubmoduleSpec {
  final String title;
  final String category;
  final String description;
  final IconData icon;
  final List<CyberSubmoduleMetric> metrics;
  final List<String> primaryFindings;

  const CyberSubmoduleSpec({
    required this.title,
    required this.category,
    required this.description,
    required this.icon,
    required this.metrics,
    required this.primaryFindings,
  });
}

class CyberSubmoduleMetric {
  final String label;
  final String value;
  final String change;
  final Color? changeColor;

  const CyberSubmoduleMetric({
    required this.label,
    required this.value,
    required this.change,
    this.changeColor,
  });
}

class CyberSubmoduleView extends StatelessWidget {
  final CyberSubmoduleSpec spec;

  const CyberSubmoduleView({super.key, required this.spec});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Submodule Header
          Row(
            children: [
              Container(
                width: 38.r,
                height: 38.r,
                decoration: BoxDecoration(
                  color: const Color(0xFF00B4D8).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: const Color(0xFF00B4D8).withValues(alpha: 0.35),
                  ),
                ),
                child: Icon(spec.icon, color: const Color(0xFF00B4D8), size: 20.sp),
              ),
              const Gap(14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          spec.category.toUpperCase(),
                          style: TextStyle(
                            color: const Color(0xFF64748B),
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                          ),
                        ),
                        const Gap(8),
                        Container(
                          width: 4.r,
                          height: 4.r,
                          decoration: const BoxDecoration(
                            color: Color(0xFF64748B),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const Gap(8),
                        Text(
                          'Active Telemetry',
                          style: TextStyle(
                            color: const Color(0xFF10B981),
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const Gap(2),
                    Text(
                      spec.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Gap(8),
          Text(
            spec.description,
            style: TextStyle(
              color: const Color(0xFF94A3B8),
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
          const Gap(22),

          // Metrics Grid
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 800;
              return Wrap(
                spacing: 14.w,
                runSpacing: 14.h,
                children: spec.metrics.map((metric) {
                  return Container(
                    width: isNarrow
                        ? (constraints.maxWidth - 14.w) / 2
                        : (constraints.maxWidth - 42.w) / 4,
                    padding: EdgeInsets.all(16.r),
                    decoration: BoxDecoration(
                      color: const Color(0xFF131D31),
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: const Color(0xFF1E293B)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          metric.label.toUpperCase(),
                          style: TextStyle(
                            color: const Color(0xFF64748B),
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const Gap(8),
                        Text(
                          metric.value,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const Gap(4),
                        Text(
                          metric.change,
                          style: TextStyle(
                            color: metric.changeColor ?? const Color(0xFF94A3B8),
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),
          const Gap(22),

          // Findings & Controls Panel
          Container(
            padding: EdgeInsets.all(20.r),
            decoration: BoxDecoration(
              color: const Color(0xFF131D31),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: const Color(0xFF1E293B)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ACTIVE FINDINGS & AUDIT CONTROLS',
                      style: TextStyle(
                        color: const Color(0xFF94A3B8),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.8,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        'Live Guardrails',
                        style: TextStyle(
                          color: const Color(0xFF00B4D8),
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const Gap(16),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: spec.primaryFindings.length,
                  separatorBuilder: (_, _) => const Gap(10),
                  itemBuilder: (context, index) {
                    final finding = spec.primaryFindings[index];
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 11.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFF090E1A),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: const Color(0xFF1E293B)),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle_outline_rounded,
                            color: const Color(0xFF10B981),
                            size: 16.sp,
                          ),
                          const Gap(12),
                          Expanded(
                            child: Text(
                              finding,
                              style: TextStyle(
                                color: const Color(0xFFCBD5E1),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Text(
                            'Compliant',
                            style: TextStyle(
                              color: const Color(0xFF10B981),
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
