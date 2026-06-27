import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:flutter/material.dart';

class FunctionRoleModuleField extends StatelessWidget {
  const FunctionRoleModuleField({
    super.key,
    required this.moduleNames,
    required this.formModule,
    required this.modulesLoading,
    required this.modulesError,
    required this.onModuleChanged,
  });

  final List<String> moduleNames;
  final String? formModule;
  final bool modulesLoading;
  final String? modulesError;
  final ValueChanged<String> onModuleChanged;

  @override
  Widget build(BuildContext context) {
    final fieldLocked = modulesLoading || moduleNames.isEmpty;
    final hint = modulesLoading
        ? 'Loading...'
        : (moduleNames.isEmpty
            ? (modulesError ?? 'No modules available for this enterprise.')
            : null);

    return DigifySelectFieldWithLabel<String>(
      label: 'Module',
      isRequired: true,
      hint: hint,
      items: fieldLocked ? const <String>[] : moduleNames,
      value: fieldLocked ? null : formModule,
      itemLabelBuilder: (item) => item,
      onChanged: fieldLocked
          ? null
          : (value) {
              if (value != null) onModuleChanged(value);
            },
    );
  }
}
