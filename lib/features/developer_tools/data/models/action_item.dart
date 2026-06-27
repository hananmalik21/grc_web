class ActionItem {
  const ActionItem({
    required this.actionId,
    required this.actionGuid,
    required this.actionCode,
    required this.actionName,
    this.description,
  });

  final int actionId;
  final String actionGuid;
  final String actionCode;
  final String actionName;
  final String? description;

  factory ActionItem.fromJson(Map<String, dynamic> json) {
    return ActionItem(
      actionId: (json['action_id'] as num).toInt(),
      actionGuid: json['action_guid'] as String,
      actionCode: json['action_code'] as String,
      actionName: json['action_name'] as String,
      description: json['description'] as String?,
    );
  }
}
