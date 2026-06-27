import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'create_new_component_screen.dart';

class ComponentCreationScreen extends ConsumerWidget {
  static const String routeName = 'compensation-components-component-creation';

  const ComponentCreationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(key: UniqueKey(), child: const CreateNewComponentScreen());
  }
}
