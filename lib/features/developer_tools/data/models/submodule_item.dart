class SubmoduleItem {
  const SubmoduleItem({
    required this.subModuleId,
    required this.subModuleGuid,
    required this.subModuleCode,
    required this.subModuleName,
    this.description,
  });

  final int subModuleId;
  final String subModuleGuid;
  final String subModuleCode;
  final String subModuleName;
  final String? description;

  factory SubmoduleItem.fromJson(Map<String, dynamic> json) {
    return SubmoduleItem(
      subModuleId: (json['sub_module_id'] as num).toInt(),
      subModuleGuid: json['sub_module_guid'] as String,
      subModuleCode: json['sub_module_code'] as String,
      subModuleName: json['sub_module_name'] as String,
      description: json['description'] as String?,
    );
  }
}
