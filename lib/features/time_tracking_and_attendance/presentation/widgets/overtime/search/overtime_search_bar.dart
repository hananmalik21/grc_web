import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/widgets/forms/digify_text_field.dart';
import '../../../providers/overtime/overtime_provider.dart';

class OvertimeSearchBar extends ConsumerStatefulWidget {
  final String hintText;
  final bool isDark;
  final double? width;

  const OvertimeSearchBar({super.key, required this.hintText, required this.isDark, this.width});

  @override
  ConsumerState<OvertimeSearchBar> createState() => _OvertimeSearchBarState();
}

class _OvertimeSearchBarState extends ConsumerState<OvertimeSearchBar> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DigifyTextField.search(
      controller: _controller,
      hintText: widget.hintText,
      onChanged: (value) {
        ref.read(overtimeManagementProvider.notifier).setSearchQuery(value);
      },
    );
  }
}
