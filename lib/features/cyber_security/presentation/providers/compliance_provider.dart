import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grc/core/models/cyber_security/grc_compliance/compliance_framework_model.dart';
import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/features/auth/presentation/providers/auth_provider.dart';
import 'package:grc/features/cyber_security/data/datasources/compliance_remote_data_source.dart';
import 'package:grc/features/cyber_security/data/models/compliance_dto.dart';
import 'package:grc/features/cyber_security/data/repositories/compliance_repository.dart';

final complianceApiClientProvider = Provider<ApiClient>(
  (ref) => ApiClient(
    baseUrl: ApiConfig.baseUrl,
    authStorage: ref.watch(authLocalStorageProvider),
  ),
);

final complianceRemoteDataSourceProvider = Provider<ComplianceRemoteDataSource>(
  (ref) => DioComplianceRemoteDataSource(
    apiClient: ref.watch(complianceApiClientProvider),
  ),
);

final complianceRepositoryProvider = Provider<ComplianceRepository>(
  (ref) => ComplianceRepositoryImpl(
    remoteDataSource: ref.watch(complianceRemoteDataSourceProvider),
  ),
);

class ComplianceState {
  final bool isLoading;
  final List<ComplianceFrameworkModel> frameworks;
  final String? selectedFrameworkId;
  final String? error;

  const ComplianceState({
    this.isLoading = true,
    this.frameworks = const [],
    this.selectedFrameworkId,
    this.error,
  });

  ComplianceState copyWith({
    bool? isLoading,
    List<ComplianceFrameworkModel>? frameworks,
    Object? selectedFrameworkId = _unset,
    Object? error = _unset,
  }) {
    return ComplianceState(
      isLoading: isLoading ?? this.isLoading,
      frameworks: frameworks ?? this.frameworks,
      selectedFrameworkId: identical(selectedFrameworkId, _unset)
          ? this.selectedFrameworkId
          : selectedFrameworkId as String?,
      error: identical(error, _unset) ? this.error : error as String?,
    );
  }
}

const _unset = Object();

class ComplianceNotifier extends StateNotifier<ComplianceState> {
  ComplianceNotifier(this._repository) : super(const ComplianceState()) {
    load();
  }

  final ComplianceRepository _repository;

  Future<void> load() async {
    try {
      final frameworks = await _repository.getFrameworks();
      final assessments = await _repository.getAssessments();
      final models = frameworks.map((framework) {
        final scores = assessments
            .where(
              (assessment) =>
                  assessment.frameworkVersionId == framework.currentVersionId,
            )
            .map((assessment) => assessment.overallScore)
            .whereType<double>()
            .toList();
        final score = scores.isEmpty
            ? 0
            : scores.reduce((a, b) => a + b) / scores.length;
        return ComplianceFrameworkModel(
          id: framework.id,
          name: framework.name,
          readinessScore: score.round().clamp(0, 100),
          progressColor: _colorFor(framework.code),
          passingCount: 0,
          failingCount: 0,
          partialCount: 0,
          totalControls: 0,
          controls: const [],
        );
      }).toList();
      state = state.copyWith(
        isLoading: false,
        frameworks: models,
        selectedFrameworkId: models.isEmpty ? null : models.first.id,
        error: null,
      );
      if (models.isNotEmpty) await loadControls(models.first.id);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> selectFramework(String id) async {
    if (!state.frameworks.any((framework) => framework.id == id)) return;
    state = state.copyWith(selectedFrameworkId: id);
    await loadControls(id);
  }

  Future<void> loadControls(String frameworkId) async {
    try {
      final controls = await _repository.getFrameworkControls(frameworkId);
      final mapped = controls
          .map((json) => _toControl(json, frameworkId))
          .toList();
      final index = state.frameworks.indexWhere(
        (framework) => framework.id == frameworkId,
      );
      if (index == -1) return;
      final updated = [...state.frameworks];
      final framework = updated[index];
      updated[index] = ComplianceFrameworkModel(
        id: framework.id,
        name: framework.name,
        readinessScore: framework.readinessScore,
        progressColor: framework.progressColor,
        passingCount: mapped
            .where((control) => control.status == ControlStatus.pass)
            .length,
        failingCount: mapped
            .where((control) => control.status == ControlStatus.fail)
            .length,
        partialCount: mapped
            .where((control) => control.status == ControlStatus.partial)
            .length,
        totalControls: mapped.length,
        controls: mapped,
      );
      state = state.copyWith(frameworks: updated);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  ControlItemModel _toControl(Map<String, dynamic> json, String frameworkId) {
    final score = (json['score'] as num?)?.toInt() ?? 0;
    final status = json['status']?.toString().toUpperCase() ?? '';
    final controlStatus = status == 'IMPLEMENTED' || score >= 80
        ? ControlStatus.pass
        : status == 'PARTIALLY_IMPLEMENTED' || score > 0
        ? ControlStatus.partial
        : ControlStatus.fail;
    return ControlItemModel(
      controlId: json['id']?.toString() ?? json['code']?.toString() ?? '',
      controlName: json['title']?.toString() ?? '',
      status: controlStatus,
      score: score,
      frameworkId: frameworkId,
      description: json['description']?.toString() ?? '',
      automatedEvidence: json['guidance']?.toString() ?? '',
    );
  }

  Color _colorFor(String code) {
    final value = code.toUpperCase();
    if (value.contains('NIST')) return const Color(0xFF00B4D8);
    if (value.contains('CIS')) return const Color(0xFF38BDF8);
    if (value.contains('ISO')) return const Color(0xFFA855F7);
    if (value.contains('SOC')) return const Color(0xFF10B981);
    return const Color(0xFFF59E0B);
  }
}

final complianceProvider =
    StateNotifierProvider<ComplianceNotifier, ComplianceState>(
      (ref) => ComplianceNotifier(ref.watch(complianceRepositoryProvider)),
    );

final frameworkComplianceProvider =
    FutureProvider<List<FrameworkComplianceItem>>(
      (ref) => ref.watch(complianceRepositoryProvider).getFrameworkCompliance(),
    );
