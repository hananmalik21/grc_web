import 'package:grc/core/services/debouncer.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WorkforceSearchBar extends ConsumerStatefulWidget {
  final String hintText;
  final bool isDark;
  final double? width;
  final ValueChanged<String>? onSearchChanged;

  const WorkforceSearchBar({super.key, required this.hintText, required this.isDark, this.width, this.onSearchChanged});

  @override
  ConsumerState<WorkforceSearchBar> createState() => _WorkforceSearchBarState();
}

class _WorkforceSearchBarState extends ConsumerState<WorkforceSearchBar> {
  late TextEditingController _controller;
  final Debouncer _debouncer = Debouncer(delay: const Duration(milliseconds: 500));

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _debouncer.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DigifyTextField.search(
      controller: _controller,
      hintText: widget.hintText,
      onChanged: (value) {
        _debouncer.run(() {
          widget.onSearchChanged?.call(value.trim());
        });
      },
      onSubmitted: (value) {
        _debouncer.dispose();
        widget.onSearchChanged?.call(value.trim());
      },
    );
  }
}
