import 'package:grc/features/compensation/domain/models/grade_structure_management/grade_record.dart';
import 'package:grc/features/compensation/domain/repositories/grade_structure_management/grade_structure_repository.dart';

class GradeStructureRepositoryImpl implements GradeStructureRepository {
  final List<GradeRecord> _mockGrades = [
    GradeRecord(
      gradeLevel: 'Grade 1',
      description: 'Entry Level',
      minSalary: '2000',
      maxSalary: '4000',
      increment: '200',
      steps: '10',
      status: 'Active',
    ),
    GradeRecord(
      gradeLevel: 'Grade 2',
      description: 'Junior Specialist',
      minSalary: '4000',
      maxSalary: '7000',
      increment: '400',
      steps: '8',
      status: 'Active',
    ),
    GradeRecord(
      gradeLevel: 'Grade 3',
      description: 'Specialist',
      minSalary: '7000',
      maxSalary: '11000',
      increment: '600',
      steps: '7',
      status: 'Active',
    ),
    GradeRecord(
      gradeLevel: 'Grade 4',
      description: 'Senior Specialist',
      minSalary: '11000',
      maxSalary: '16000',
      increment: '800',
      steps: '6',
      status: 'Active',
    ),
    GradeRecord(
      gradeLevel: 'Grade 5',
      description: 'Principal Specialist',
      minSalary: '16000',
      maxSalary: '22000',
      increment: '1000',
      steps: '6',
      status: 'Active',
    ),
  ];

  @override
  Future<List<GradeRecord>> getGrades() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_mockGrades);
  }

  @override
  Future<void> createGrade(GradeRecord grade) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockGrades.add(grade);
  }

  @override
  Future<void> updateGrade(GradeRecord grade) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _mockGrades.indexWhere(
      (element) => element.gradeLevel == grade.gradeLevel,
    );
    if (index != -1) {
      _mockGrades[index] = grade;
    }
  }

  @override
  Future<void> deleteGrade(String gradeLevel) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockGrades.removeWhere((element) => element.gradeLevel == gradeLevel);
  }
}
