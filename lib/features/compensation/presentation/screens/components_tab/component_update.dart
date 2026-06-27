import 'package:grc/features/compensation/domain/models/components/comp_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'update_component_screen.dart';

class ComponentUpdateScreen extends ConsumerWidget {
  static const String routeName = 'compensation-components-component-update';

  final CompComponent component;

  const ComponentUpdateScreen({super.key, required this.component});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(
      key: ValueKey(component.componentGuid),
      child: UpdateComponentScreen(component: component),
    );
  }
}
