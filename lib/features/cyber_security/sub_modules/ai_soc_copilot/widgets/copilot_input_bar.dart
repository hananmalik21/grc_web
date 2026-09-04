import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/theme/theme_extensions.dart';

class CopilotInputBar extends StatefulWidget {
  final ValueChanged<String> onSend;
  final bool isGenerating;

  const CopilotInputBar({
    super.key,
    required this.onSend,
    this.isGenerating = false,
  });

  @override
  State<CopilotInputBar> createState() => _CopilotInputBarState();
}

class _CopilotInputBarState extends State<CopilotInputBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  void _submit() {
    final text = _controller.text.trim();
    if (text.isNotEmpty && !widget.isGenerating) {
      widget.onSend(text);
      _controller.clear();
      _focusNode.requestFocus();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: isDark ? const Color(0xFF2D2D2F) : const Color(0xFFE2E8F0)),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 12,
                  offset: const Offset(0, -4),
                ),
              ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              style: TextStyle(color: isDark ? Colors.white : const Color(0xFF0F172A), fontSize: 12.5.sp),
              decoration: InputDecoration(
                isDense: true,
                hintText:
                    'Ask about any alert, finding, incident, or security event...',
                hintStyle: TextStyle(
                  color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                  fontSize: 12.sp,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
                contentPadding: EdgeInsets.symmetric(vertical: 8.h),
              ),
              onSubmitted: (_) => _submit(),
            ),
          ),
          const Gap(10),
          InkWell(
            onTap: widget.isGenerating ? null : _submit,
            borderRadius: BorderRadius.circular(6.r),
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: widget.isGenerating
                    ? (isDark ? const Color(0xFF2D2D2F) : const Color(0xFFF1F5F9))
                    : const Color(0xFF38BDF8),
                borderRadius: BorderRadius.circular(6.r),
                border: Border.all(
                  color: widget.isGenerating
                      ? (isDark ? const Color(0xFF3A3A3C) : const Color(0xFFCBD5E1))
                      : const Color(0xFF38BDF8),
                ),
              ),
              child: widget.isGenerating
                  ? SizedBox(
                      width: 16.sp,
                      height: 16.sp,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Color(0xFF38BDF8),
                      ),
                    )
                  : Icon(
                      Icons.send_rounded,
                      size: 16.sp,
                      color: Colors.white,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
