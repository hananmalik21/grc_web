import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchField extends StatefulWidget {
  final String hintText;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final String initialValue;

  const SearchField({
    super.key,
    required this.hintText,
    required this.onChanged,
    required this.onClear,
    this.initialValue = '',
  });

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(SearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != _controller.text && widget.initialValue.isEmpty) {
      _controller.text = widget.initialValue;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DigifyTextField(
      controller: _controller,
      hintText: widget.hintText,
      prefixIcon: Icon(Icons.search, size: 16.sp),
      textInputAction: TextInputAction.search,
      onChanged: (value) {
        widget.onChanged(value);
        setState(() {});
      },
      onSubmitted: widget.onChanged,
      suffixIcon: _controller.text.isNotEmpty
          ? IconButton(
              onPressed: () {
                _controller.clear();
                widget.onClear();
                setState(() {});
              },
              icon: Icon(Icons.close_rounded, size: 18.sp),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            )
          : null,
    );
  }
}
