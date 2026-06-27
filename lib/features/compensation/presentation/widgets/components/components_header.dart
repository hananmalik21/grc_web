import 'package:grc/features/compensation/presentation/screens/mixins/components_permission_mixin.dart';

import '../../../../../core/widgets/common/digify_tab_header.dart';
import '../../../../../core/widgets/buttons/app_button.dart';
import '../../providers/components_table_rows_provider.dart';
import '../../screens/components_tab/component_creation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ComponentsHeader extends ConsumerWidget with ComponentsPermissionMixin {
  const ComponentsHeader({this.onCreateComponentPressed, super.key});

  final Future<void> Function()? onCreateComponentPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DigifyTabHeader(
          title: 'Compensation Components',
          description:
              'Create, configure, validate, and manage compensation components used across salary structures, allowances, benefits, and payroll integration.',
          trailing: canCreateComponent
              ? AppButton.primary(
                  label: 'Create Component',
                  icon: CupertinoIcons.add,
                  onPressed: () async => onCreateComponentPressed == null
                      ? _handleCreateComponent(context, ref)
                      : onCreateComponentPressed!(),
                )
              : null,
        ),
      ],
    );
  }

  Future<void> _handleCreateComponent(BuildContext context, WidgetRef ref) async {
    final created = await context.pushNamed<bool>(ComponentCreationScreen.routeName);
    if (created != true) return;

    ref.invalidate(componentsPageProvider);
  }
}
