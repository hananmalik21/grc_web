import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../gen/assets.gen.dart';
import 'package:grc/features/compensation/data/repositories/grade_structure_management/grade_structure_repository_impl.dart';
import 'package:grc/features/compensation/domain/models/grade_structure_management/grade_record.dart';
import 'package:grc/features/compensation/domain/repositories/grade_structure_management/grade_structure_repository.dart';
import 'package:grc/features/compensation/domain/usecases/grade_structure_management/create_grade_usecase.dart';
import 'package:grc/features/compensation/domain/usecases/grade_structure_management/delete_grade_usecase.dart';
import 'package:grc/features/compensation/domain/usecases/grade_structure_management/get_grades_usecase.dart';
import 'package:grc/features/compensation/domain/usecases/grade_structure_management/update_grade_usecase.dart';

class GradeStructureStat {
  final String title;
  final String subTitle;
  final String value;
  final String icon;
  final Color? iconBackground;
  final Color? iconColor;

  GradeStructureStat({
    required this.title,
    required this.value,
    required this.icon,
    required this.subTitle,
    this.iconBackground = AppColors.infoBg,
    this.iconColor = AppColors.statIconBlue,
  });

  GradeStructureStat copyWith({
    String? title,
    String? subTitle,
    String? value,
    String? icon,
    Color? iconBackground,
    Color? iconColor,
  }) {
    return GradeStructureStat(
      title: title ?? this.title,
      subTitle: subTitle ?? this.subTitle,
      value: value ?? this.value,
      icon: icon ?? this.icon,
      iconBackground: iconBackground ?? this.iconBackground,
      iconColor: iconColor ?? this.iconColor,
    );
  }
}

class GradeStructureManagment {
  final bool isLoading;
  final bool clearError;
  final bool isError;
  final String? error;
  final String companyId;
  final List<GradeStructureStat>? stats;
  final List records;

  GradeStructureManagment({
    this.isLoading = false,
    this.clearError = false,
    this.isError = false,
    this.companyId = '',
    this.stats,
    this.error,
    this.records = const [],
  });

  GradeStructureManagment copyWith({
    bool? isLoading,
    bool? clearError,
    bool? isError,
    String? error,
    String? companyId,
    List<GradeStructureStat>? stats,
    List? records,
  }) {
    return GradeStructureManagment(
      isLoading: isLoading ?? this.isLoading,
      clearError: clearError ?? this.clearError,
      isError: isError ?? this.isError,
      companyId: companyId ?? this.companyId,
      stats: stats ?? this.stats,
      error: error ?? this.error,
      records: records ?? this.records,
    );
  }
}

final gradeStructureRepositoryProvider = Provider<GradeStructureRepository>((
  ref,
) {
  return GradeStructureRepositoryImpl();
});

final getGradesUseCaseProvider = Provider<GetGradesUseCase>((ref) {
  final repository = ref.watch(gradeStructureRepositoryProvider);
  return GetGradesUseCase(repository: repository);
});

final createGradeUseCaseProvider = Provider<CreateGradeUseCase>((ref) {
  final repository = ref.watch(gradeStructureRepositoryProvider);
  return CreateGradeUseCase(repository: repository);
});

final updateGradeUseCaseProvider = Provider<UpdateGradeUseCase>((ref) {
  final repository = ref.watch(gradeStructureRepositoryProvider);
  return UpdateGradeUseCase(repository: repository);
});

final deleteGradeUseCaseProvider = Provider<DeleteGradeUseCase>((ref) {
  final repository = ref.watch(gradeStructureRepositoryProvider);
  return DeleteGradeUseCase(repository: repository);
});

class GradeStructureManagementNotifier
    extends StateNotifier<GradeStructureManagment> {
  final GetGradesUseCase getGradesUseCase;
  final CreateGradeUseCase createGradeUseCase;
  final UpdateGradeUseCase updateGradeUseCase;
  final DeleteGradeUseCase deleteGradeUseCase;

  GradeStructureManagementNotifier({
    required this.getGradesUseCase,
    required this.createGradeUseCase,
    required this.updateGradeUseCase,
    required this.deleteGradeUseCase,
  }) : super(GradeStructureManagment()) {
    _initializeStats();
    loadGrades();
  }

  void _initializeStats() {
    state = state.copyWith(
      stats: [
        GradeStructureStat(
          title: 'Total Grade Levels',
          subTitle: 'Institutional Standard',
          value: '5',
          icon: Assets.icons.gradeIcon.path,
        ),
        GradeStructureStat(
          title: 'Total Steps',
          subTitle: 'Granular Progression',
          value: '25',
          icon: Assets.icons.gradeIcon.path,
        ),
        GradeStructureStat(
          title: 'Avg. Min Salary',
          subTitle: 'Base Benchmark',
          value: '660.000',
          icon: Assets.icons.attendanceMainIcon.path,
        ),
        GradeStructureStat(
          title: 'Staff Allocated',
          subTitle: 'Active Allocation',
          value: '0',
          icon: Assets.icons.usersIcon.path,
        ),
      ],
    );
  }

  Future<void> loadGrades() async {
    state = state.copyWith(isLoading: true);
    try {
      final grades = await getGradesUseCase();
      state = state.copyWith(records: grades, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isError: true,
        isLoading: false,
      );
    }
  }

  Future<void> createGrade(GradeRecord grade) async {
    state = state.copyWith(isLoading: true);
    try {
      await createGradeUseCase(grade);
      await loadGrades();
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isError: true,
        isLoading: false,
      );
    }
  }

  Future<void> updateGrade(GradeRecord grade) async {
    state = state.copyWith(isLoading: true);
    try {
      await updateGradeUseCase(grade);
      await loadGrades();
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isError: true,
        isLoading: false,
      );
    }
  }

  Future<void> deleteGrade(String gradeLevel) async {
    state = state.copyWith(isLoading: true);
    try {
      await deleteGradeUseCase(gradeLevel);
      await loadGrades();
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isError: true,
        isLoading: false,
      );
    }
  }

  void refresh() {
    loadGrades();
  }

  void setCompanyId(String companyId) {
    state = state.copyWith(companyId: companyId);
  }
}

final gradeStructureManagementProvider =
    StateNotifierProvider<
      GradeStructureManagementNotifier,
      GradeStructureManagment
    >((ref) {
      final getGradesUseCase = ref.watch(getGradesUseCaseProvider);
      final createGradeUseCase = ref.watch(createGradeUseCaseProvider);
      final updateGradeUseCase = ref.watch(updateGradeUseCaseProvider);
      final deleteGradeUseCase = ref.watch(deleteGradeUseCaseProvider);

      return GradeStructureManagementNotifier(
        getGradesUseCase: getGradesUseCase,
        createGradeUseCase: createGradeUseCase,
        updateGradeUseCase: updateGradeUseCase,
        deleteGradeUseCase: deleteGradeUseCase,
      );
    });
