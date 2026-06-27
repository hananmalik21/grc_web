enum PermAction {
  create,
  view,
  update,
  delete,
  activate,
  approval;

  String get key => name;

  String get label => '${name[0].toUpperCase()}${name.substring(1)}';
}
