import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class GeneratePolicyDialog extends StatefulWidget {
  const GeneratePolicyDialog({super.key});

  @override
  State<GeneratePolicyDialog> createState() => _GeneratePolicyDialogState();
}

class _GeneratePolicyDialogState extends State<GeneratePolicyDialog> {
  final _policyNameController = TextEditingController(
    text: 'Zero-Trust Access Control & MFA Policy',
  );
  String _selectedFramework = 'NIST CSF 2.0';
  String _scope = 'All Production & Staging Environments';

  @override
  void dispose() {
    _policyNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF0F172A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: const BorderSide(color: Color(0xFF1E293B)),
      ),
      child: Container(
        width: 520.w,
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.description_outlined,
                      size: 18.sp,
                      color: const Color(0xFF00B4D8),
                    ),
                    const Gap(8),
                    Text(
                      'Generate Compliance Policy',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.close_rounded,
                    size: 18.sp,
                    color: const Color(0xFF64748B),
                  ),
                  splashRadius: 20.r,
                ),
              ],
            ),
            const Gap(16),

            // Policy Name
            Text(
              'Policy Title',
              style: TextStyle(
                color: const Color(0xFF94A3B8),
                fontSize: 11.5.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Gap(6),
            TextField(
              controller: _policyNameController,
              style: TextStyle(color: Colors.white, fontSize: 12.sp),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF1E293B).withValues(alpha: 0.6),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6.r),
                  borderSide: const BorderSide(color: Color(0xFF334155)),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              ),
            ),
            const Gap(14),

            // Framework dropdown
            Text(
              'Governing Framework',
              style: TextStyle(
                color: const Color(0xFF94A3B8),
                fontSize: 11.5.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Gap(6),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B).withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(6.r),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedFramework,
                  isExpanded: true,
                  dropdownColor: const Color(0xFF0F172A),
                  items: const [
                    DropdownMenuItem(
                        value: 'NIST CSF 2.0',
                        child: Text('NIST CSF 2.0',
                            style: TextStyle(color: Colors.white))),
                    DropdownMenuItem(
                        value: 'SOC 2 Type II',
                        child: Text('SOC 2 Type II',
                            style: TextStyle(color: Colors.white))),
                    DropdownMenuItem(
                        value: 'ISO 27001:2022',
                        child: Text('ISO 27001:2022',
                            style: TextStyle(color: Colors.white))),
                    DropdownMenuItem(
                        value: 'CIS Controls v8',
                        child: Text('CIS Controls v8',
                            style: TextStyle(color: Colors.white))),
                    DropdownMenuItem(
                        value: 'CSA CCM v4',
                        child: Text('CSA CCM v4',
                            style: TextStyle(color: Colors.white))),
                  ],
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedFramework = val);
                  },
                ),
              ),
            ),
            const Gap(14),

            // Scope
            Text(
              'Enforcement Scope',
              style: TextStyle(
                color: const Color(0xFF94A3B8),
                fontSize: 11.5.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Gap(6),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B).withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(6.r),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _scope,
                  isExpanded: true,
                  dropdownColor: const Color(0xFF0F172A),
                  items: const [
                    DropdownMenuItem(
                        value: 'All Production & Staging Environments',
                        child: Text('All Production & Staging Environments',
                            style: TextStyle(color: Colors.white))),
                    DropdownMenuItem(
                        value: 'AWS Member Accounts Only',
                        child: Text('AWS Member Accounts Only',
                            style: TextStyle(color: Colors.white))),
                    DropdownMenuItem(
                        value: 'Identity & SaaS Applications',
                        child: Text('Identity & SaaS Applications',
                            style: TextStyle(color: Colors.white))),
                  ],
                  onChanged: (val) {
                    if (val != null) setState(() => _scope = val);
                  },
                ),
              ),
            ),
            const Gap(20),

            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: const Color(0xFF94A3B8),
                      fontSize: 12.sp,
                    ),
                  ),
                ),
                const Gap(10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: const Color(0xFF131D31),
                        content: Text(
                          'Policy "${_policyNameController.text}" generated and published to GRC catalog.',
                          style: const TextStyle(color: Color(0xFF00B4D8)),
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0284C7),
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                  ),
                  child: Text(
                    'Publish Policy',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
