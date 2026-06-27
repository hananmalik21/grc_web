enum AssignmentLevel {
  department,
  employee;

  static AssignmentLevel fromString(String value) {
    if (value.toUpperCase() == 'EMPLOYEE') {
      return AssignmentLevel.employee;
    }
    return AssignmentLevel.department;
  }

  String toJson() => name.toUpperCase();
}
