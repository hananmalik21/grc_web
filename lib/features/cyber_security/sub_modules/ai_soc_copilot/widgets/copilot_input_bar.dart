import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.5.sp,
              ),
              decoration: InputDecoration(
                isDense: true,
                hintText: 'Ask about any alert, finding, incident, or security event...',
                hintStyle: TextStyle(
                  color: const Color(0xFF64748B),
                  fontSize: 12.sp,
                ),
                border: InputBorder.none,
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
                    ? const Color(0xFF1E293B)
                    : const Color(0xFF0F3E57).withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(6.r),
                border: Border.all(
                  color: widget.isGenerating
                      ? const Color(0xFF334155)
                      : const Color(0xFF0284C7).withValues(alpha: 0.4),
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
                      color: const Color(0xFF38BDF8),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
