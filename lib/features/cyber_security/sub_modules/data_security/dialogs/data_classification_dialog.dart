import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/models/cyber_security/data_security/datastore_item_model.dart';
import 'package:grc/core/services/toast_service.dart';

class DataClassificationDialog extends StatelessWidget {
  final DatastoreItemModel datastore;

  const DataClassificationDialog({super.key, required this.datastore});

  static void show(BuildContext context, {required DatastoreItemModel datastore}) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.75),
      builder: (context) => DataClassificationDialog(datastore: datastore),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 540.w,
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),
          margin: EdgeInsets.all(20.r),
          padding: EdgeInsets.all(22.r),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: const Color(0xFF1E293B), width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.6),
                blurRadius: 25,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Data Classification & DLP Policy',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Gap(2),
                        Text(
                          '${datastore.source} (${datastore.type})',
                          style: TextStyle(
                            color: const Color(0xFF00B4D8),
                            fontSize: 12.sp,
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: Color(0xFF94A3B8)),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const Gap(16),

                // Specs Summary Card
                Container(
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: const Color(0xFF131D31),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: const Color(0xFF1E293B)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('CLASSIFICATION TIER', style: TextStyle(color: const Color(0xFF64748B), fontSize: 9.sp, fontWeight: FontWeight.w700)),
                          const Gap(2),
                          Text(datastore.classification.label, style: TextStyle(color: datastore.classification.color, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('SIZE / VOLUME', style: TextStyle(color: const Color(0xFF64748B), fontSize: 9.sp, fontWeight: FontWeight.w700)),
                          const Gap(2),
                          Text(datastore.size, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('ENCRYPTION AT REST', style: TextStyle(color: const Color(0xFF64748B), fontSize: 9.sp, fontWeight: FontWeight.w700)),
                          const Gap(2),
                          Text(datastore.isEncrypted ? 'AES-256 (KMS)' : 'Unencrypted', style: TextStyle(color: datastore.isEncrypted ? const Color(0xFF10B981) : const Color(0xFFEF4444), fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ],
                  ),
                ),
                const Gap(16),

                // DLP Discovered Artifacts
                Text(
                  'SENSITIVE PATTERNS DETECTED',
                  style: TextStyle(
                    color: const Color(0xFF64748B),
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
                const Gap(6),
                Container(
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: const Color(0xFF090E1A),
                    borderRadius: BorderRadius.circular(6.r),
                    border: Border.all(color: const Color(0xFF1E293B)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDlpItem('Customer PII (Email, Phone, SSN)', datastore.classification == DataClassification.restricted ? 'Found (High Confidence)' : 'None Detected'),
                      const Gap(6),
                      _buildDlpItem('Payment Card Numbers (PCI-DSS)', datastore.source.contains('customer') ? '4,102 Records' : 'None Detected'),
                      const Gap(6),
                      _buildDlpItem('Dynamic Column Masking', datastore.isMasked ? 'Active (SHA-256)' : 'Missing - Raw Text Visible'),
                    ],
                  ),
                ),
                const Gap(20),

                // Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Close', style: TextStyle(color: Color(0xFF94A3B8))),
                    ),
                    const Gap(10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        ToastService.show(
                          context: context,
                          message: 'DLP protection & encryption policy updated for ${datastore.source}',
                          type: ToastType.success,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00B4D8),
                        foregroundColor: const Color(0xFF090E1A),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.r)),
                      ),
                      child: const Text('Update DLP Policy'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDlpItem(String label, String status) {
    final isNegative = status.contains('Found') || status.contains('Missing') || status.contains('Records');
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFFCBD5E1))),
        Text(
          status,
          style: TextStyle(
            color: isNegative ? const Color(0xFFEF4444) : const Color(0xFF10B981),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
