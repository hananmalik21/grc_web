import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/enterprise_structure/domain/models/enterprise_structure.dart';
import 'package:grc/features/enterprise_structure/domain/usecases/save_enterprise_structure_usecase.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/edit_enterprise_structure_provider.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/structure_level_providers.dart'
    show saveEnterpriseStructureUseCaseProvider;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SaveEnterpriseStructureState {
  final bool isSaving;
  final String? errorMessage;
  final bool hasError;
  final bool isSuccess;
  final String? loadingStructureId;

  const SaveEnterpriseStructureState({
    this.isSaving = false,
    this.errorMessage,
    this.hasError = false,
    this.isSuccess = false,
    this.loadingStructureId,
  });

  SaveEnterpriseStructureState copyWith({
    bool? isSaving,
    String? errorMessage,
    bool? hasError,
    bool? isSuccess,
    String? loadingStructureId,
  }) {
    return SaveEnterpriseStructureState(
      isSaving: isSaving ?? this.isSaving,
      errorMessage: errorMessage ?? this.errorMessage,
      hasError: hasError ?? this.hasError,
      isSuccess: isSuccess ?? this.isSuccess,
      loadingStructureId: loadingStructureId ?? this.loadingStructureId,
    );
  }
}

class SaveEnterpriseStructureNotifier extends StateNotifier<SaveEnterpriseStructureState> {
  final SaveEnterpriseStructureUseCase saveUseCase;
  final VoidCallback? onSuccess;

  SaveEnterpriseStructureNotifier({required this.saveUseCase, this.onSuccess})
    : super(const SaveEnterpriseStructureState());

  Future<bool> saveStructure({
    required String structureName,
    required String description,
    required List<HierarchyLevel> levels,
    int? enterpriseId,
    String? structureCode,
    bool isActive = true,
    String? structureId,
  }) async {
    try {
      state = state.copyWith(isSaving: true, hasError: false, errorMessage: null, loadingStructureId: structureId);
    } catch (_) {}

    String? errorMessage;

    try {
      final code = structureCode ?? _generateStructureCode(structureName);

      List<EnterpriseStructureLevel> structureLevels = [];
      if (structureId == null) {
        structureLevels = levels.where((level) => level.isActive).toList().asMap().entries.map((entry) {
          final level = entry.value;
          final displayOrder = entry.key + 1;
          final structureLevelId = int.tryParse(level.id) ?? 0;

          return EnterpriseStructureLevel(
            structureLevelId: structureLevelId,
            levelNumber: level.level,
            displayOrder: displayOrder,
          );
        }).toList();
      }

      final enterpriseStructure = EnterpriseStructure(
        enterpriseId: enterpriseId,
        structureCode: code,
        structureName: structureName,
        structureType: 'ENTERPRISE',
        description: description,
        isActive: isActive,
        levels: structureLevels,
      );

      if (structureId != null) {
        await saveUseCase.updateStructure(structureId, enterpriseStructure);
      } else {
        await saveUseCase(enterpriseStructure);
      }

      try {
        state = state.copyWith(
          isSaving: false,
          isSuccess: true,
          hasError: false,
          errorMessage: null,
          loadingStructureId: null,
        );
        onSuccess?.call();
      } catch (_) {}
      return true;
    } on ValidationException catch (e) {
      try {
        state = state.copyWith(isSaving: false, loadingStructureId: null);
      } catch (_) {}

      errorMessage = e.message;
      if (e.errors != null && e.errors!.isNotEmpty) {
        final errorMessages = <String>[];
        e.errors!.forEach((key, value) {
          if (value is List) {
            errorMessages.addAll(value.map((v) => v.toString()));
          } else {
            errorMessages.add(value.toString());
          }
        });
        if (errorMessages.isNotEmpty) {
          errorMessage = errorMessages.join('\n');
        }
      }

      throw ValidationException(errorMessage, errors: e.errors);
    } on AppException {
      try {
        state = state.copyWith(isSaving: false, loadingStructureId: null);
      } catch (_) {}

      rethrow;
    } catch (e) {
      try {
        state = state.copyWith(isSaving: false, loadingStructureId: null);
      } catch (_) {}

      errorMessage = 'Failed to save enterprise structure: ${e.toString()}';
      throw UnknownException(errorMessage, originalError: e);
    }
  }

  String _generateStructureCode(String structureName) {
    if (structureName.isEmpty) {
      return 'ORG${DateTime.now().millisecondsSinceEpoch}';
    }

    final code = structureName
        .toUpperCase()
        .replaceAll(RegExp(r'[^A-Z0-9]'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');

    if (code.isEmpty || code.length < 3) {
      return 'ORG${DateTime.now().millisecondsSinceEpoch}';
    }

    final finalCode = code.length > 20 ? code.substring(0, 20) : code;
    return '${finalCode}_${DateTime.now().millisecondsSinceEpoch % 10000}';
  }

  void reset() {
    state = const SaveEnterpriseStructureState();
  }
}

final saveEnterpriseStructureProvider =
    StateNotifierProvider.autoDispose<SaveEnterpriseStructureNotifier, SaveEnterpriseStructureState>((ref) {
      final saveUseCase = ref.watch(saveEnterpriseStructureUseCaseProvider);
      return SaveEnterpriseStructureNotifier(saveUseCase: saveUseCase);
    });
