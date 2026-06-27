class OrgSelectionNode {
  const OrgSelectionNode({
    required this.levelCode,
    required this.levelName,
    required this.unitId,
    required this.unitName,
    this.children = const [],
  });

  final String levelCode;
  final String levelName;
  final String unitId;
  final String unitName;
  final List<OrgSelectionNode> children;

  OrgSelectionNode copyWith({
    String? levelCode,
    String? levelName,
    String? unitId,
    String? unitName,
    List<OrgSelectionNode>? children,
  }) {
    return OrgSelectionNode(
      levelCode: levelCode ?? this.levelCode,
      levelName: levelName ?? this.levelName,
      unitId: unitId ?? this.unitId,
      unitName: unitName ?? this.unitName,
      children: children ?? this.children,
    );
  }
}
