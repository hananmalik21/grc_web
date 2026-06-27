import 'perm_action.dart';

class PermSubModule {
  const PermSubModule({
    required this.label,
    required this.baseKey,
    required this.route,
    this.actions = const [PermAction.create, PermAction.view, PermAction.update, PermAction.delete],
  });

  final String label;
  final String baseKey;
  final String route;
  final List<PermAction> actions;

  String action(PermAction a) => '$baseKey.${a.key}';

  String get wildcard => '$baseKey.*';
}

class PermModule {
  const PermModule({required this.label, required this.baseKey, required this.subModules});

  final String label;
  final String baseKey;
  final List<PermSubModule> subModules;

  String get wildcard => '$baseKey.*';
}
