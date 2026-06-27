class GradeRecord {
  final String? gradeLevel;
  final String? description;
  final String? minSalary;
  final String? maxSalary;
  final String? increment;
  final String? steps;
  final String? status;

  GradeRecord({
    this.gradeLevel,
    this.description,
    this.minSalary,
    this.maxSalary,
    this.increment,
    this.steps,
    this.status,
  });

  factory GradeRecord.fromJson(Map<String, dynamic> json) {
    return GradeRecord(
      gradeLevel: json['grade_level'],
      description: json['description'],
      minSalary: json['min_salary'],
      maxSalary: json['max_salary'],
      increment: json['increment'],
      steps: json['steps'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'grade_level': gradeLevel,
      'description': description,
      'min_salary': minSalary,
      'max_salary': maxSalary,
      'increment': increment,
      'steps': steps,
      'status': status,
    };
  }

  GradeRecord copyWith({
    String? gradeLevel,
    String? description,
    String? minSalary,
    String? maxSalary,
    String? increment,
    String? steps,
    String? status,
  }) {
    return GradeRecord(
      gradeLevel: gradeLevel ?? this.gradeLevel,
      description: description ?? this.description,
      minSalary: minSalary ?? this.minSalary,
      maxSalary: maxSalary ?? this.maxSalary,
      increment: increment ?? this.increment,
      steps: steps ?? this.steps,
      status: status ?? this.status,
    );
  }
}
