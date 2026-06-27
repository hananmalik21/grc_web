enum FunctionAssignmentType {
  direct,
  inherited;

  static FunctionAssignmentType fromString(String value) {
    return switch (value.toUpperCase()) {
      'DIRECT' => FunctionAssignmentType.direct,
      'INHERITED' => FunctionAssignmentType.inherited,
      _ => FunctionAssignmentType.direct,
    };
  }
}
