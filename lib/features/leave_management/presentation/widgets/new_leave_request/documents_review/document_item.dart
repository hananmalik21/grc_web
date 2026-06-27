import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/leave_management/domain/models/document.dart';
import 'package:grc/features/leave_management/presentation/providers/document_provider.dart';
import 'package:grc/features/leave_management/presentation/providers/new_leave_request_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class DocumentItem extends ConsumerStatefulWidget {
  final Document document;
  final NewLeaveRequestNotifier notifier;

  const DocumentItem({super.key, required this.document, required this.notifier});

  @override
  ConsumerState<DocumentItem> createState() => _DocumentItemState();
}

class _DocumentItemState extends ConsumerState<DocumentItem> {
  Future<void> _removeDocument() async {
    final documentRepository = ref.read(documentRepositoryProvider);
    try {
      await documentRepository.removeDocument(widget.document.path);
      if (!mounted) return;
      widget.notifier.removeDocument(widget.document.id);
      ToastService.success(context, 'File removed successfully');
    } catch (e) {
      if (!mounted) return;
      widget.notifier.removeDocument(widget.document.id);
      ToastService.warning(context, 'File removed from list');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.document.name,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Gap(4.h),
                Text(
                  widget.document.formattedSize,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: _removeDocument,
            borderRadius: BorderRadius.circular(8.r),
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(color: AppColors.errorBg, borderRadius: BorderRadius.circular(8.r)),
              child: Icon(Icons.close, size: 18.sp, color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
