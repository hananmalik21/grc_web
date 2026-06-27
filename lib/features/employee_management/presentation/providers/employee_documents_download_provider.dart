import 'package:grc/core/services/toast_service.dart';
import 'package:grc/features/employee_management/domain/models/employee_full_details.dart';
import 'package:grc/features/employee_management/presentation/providers/manage_employees_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmployeeDocumentsDownloadNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  Future<void> downloadAllDocuments(
    BuildContext context,
    EmployeeFullDetails? fullDetails,
    String employeeIdFallback,
  ) async {
    final documents = fullDetails?.documents ?? [];
    if (documents.isEmpty) {
      ToastService.warning(context, 'No documents to download');
      return;
    }
    state = true;
    try {
      final service = ref.read(employeeDocumentsDownloadServiceProvider);
      final prefix = fullDetails?.employee.fullNameEn.trim().isNotEmpty == true
          ? fullDetails!.employee.fullNameEn.replaceAll(RegExp(r'[^\w\- ]'), '_')
          : 'employee_$employeeIdFallback';
      final ok = await service.downloadAllAsZip(documents: documents, fileNamePrefix: prefix);
      if (!context.mounted) return;
      if (ok) {
        ToastService.success(context, 'Documents ready to save');
      } else {
        ToastService.warning(context, 'No documents could be downloaded');
      }
    } catch (_) {
      if (context.mounted) {
        ToastService.error(context, 'Failed to prepare documents');
      }
    } finally {
      state = false;
    }
  }
}

final employeeDocumentsDownloadNotifierProvider = NotifierProvider<EmployeeDocumentsDownloadNotifier, bool>(
  EmployeeDocumentsDownloadNotifier.new,
);
