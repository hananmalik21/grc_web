import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CyberComplianceBars extends StatelessWidget {
  const CyberComplianceBars({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: const Color(0xFF070C18),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFF131E30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'FRAMEWORK COMPLIANCE',
            style: TextStyle(
              color: const Color(0xFF94A3B8),
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
            ),
          ),
          const Gap(20),
          _buildFrameworkRow(
            label: 'NIST\nCSF',
            percentage: 0.72,
            barColor: const Color(0xFF00BCD4),
          ),
          const Gap(14),
          _buildFrameworkRow(
            label: 'CIS v8',
            percentage: 0.80,
            barColor: const Color(0xFF448AFF),
          ),
          const Gap(14),
          _buildFrameworkRow(
            label: 'ISO\n27001',
            percentage: 0.68,
            barColor: const Color(0xFFA78BFA),
          ),
          const Gap(14),
          _buildFrameworkRow(
            label: 'SOC 2',
            percentage: 0.85,
            barColor: const Color(0xFF10B981),
          ),
          const Gap(14),
          _buildFrameworkRow(
            label: 'CSA\nCCM',
            percentage: 0.62,
            barColor: const Color(0xFFF59E0B),
          ),
          const Gap(16),
          // Percentage Axis
          Row(
            children: [
              SizedBox(width: 55.w), // alignment spacer matching labels
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('0%', style: _axisStyle),
                      const Gap(16),
                      Text('25%', style: _axisStyle),
                      const Gap(16),
                      Text('50%', style: _axisStyle),
                      const Gap(16),
                      Text('75%', style: _axisStyle),
                      const Gap(16),
                      Text('100%', style: _axisStyle),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  TextStyle get _axisStyle => TextStyle(
    color: const Color(0xFF64748B),
    fontSize: 10.sp,
    fontWeight: FontWeight.w500,
  );

  Widget _buildFrameworkRow({
    required String label,
    required double percentage,
    required Color barColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 55.w,
          child: Text(
            label,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: const Color(0xFF94A3B8),
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
              height: 1.1,
            ),
          ),
        ),
        const Gap(12),
        Expanded(
          child: Container(
            height: 22.h,
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: constraints.maxWidth * percentage,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: barColor,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
