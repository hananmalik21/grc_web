class ModuleItem {
  const ModuleItem({
    required this.moduleId,
    required this.moduleGuid,
    required this.moduleCode,
    required this.moduleName,
    this.description,
  });

  final int moduleId;
  final String moduleGuid;
  final String moduleCode;
  final String moduleName;
  final String? description;

  factory ModuleItem.fromJson(Map<String, dynamic> json) {
    return ModuleItem(
      moduleId: (json['module_id'] as num).toInt(),
      moduleGuid: json['module_guid'] as String,
      moduleCode: json['module_code'] as String,
      moduleName: json['module_name'] as String,
      description: json['description'] as String?,
    );
  }
}
