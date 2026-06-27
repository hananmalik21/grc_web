import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/enterprise_structure/domain/models/structure_level.dart';
import 'package:grc/features/enterprise_structure/domain/usecases/get_structure_levels_usecase.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/edit_enterprise_structure_provider.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/structure_level_providers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State for enterprise structure dialog
class EnterpriseStructureDialogState {
  final List<StructureLevel> structureLevels;
  final bool isLoading;
  final String? errorMessage;
  final bool hasError;

  const EnterpriseStructureDialogState({
    required this.structureLevels,
    this.isLoading = false,
    this.errorMessage,
    this.hasError = false,
  });

  EnterpriseStructureDialogState copyWith({
    List<StructureLevel>? structureLevels,
    bool? isLoading,
    String? errorMessage,
    bool? hasError,
  }) {
    return EnterpriseStructureDialogState(
      structureLevels: structureLevels ?? this.structureLevels,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      hasError: hasError ?? this.hasError,
    );
  }

  /// Converts StructureLevel to HierarchyLevel for compatibility
  /// Returns empty list if no levels are loaded (caller should use defaults)
  List<HierarchyLevel> toHierarchyLevels(AppLocalizations localizations) {
    if (structureLevels.isEmpty) {
      return [];
    }

    if (kDebugMode) {}

    return structureLevels.map((level) {
      return HierarchyLevel(
        id: level.id,
        name: level.name,
        icon: level.icon,
        level: level.level,
        isMandatory: level.isMandatory,
        isActive: level.isActive,
        previewIcon: level.previewIcon,
      );
    }).toList();
  }

  /// Default levels fallback
  // List<HierarchyLevel> _getDefaultLevels(AppLocalizations localizations) {
  //   return [
  //     HierarchyLevel(
  //       id: 'company',
  //       name: localizations.company,
  //       icon: 'assets/icons/company_icon_small.svg',
  //       level: 1,
  //       isMandatory: true,
  //       isActive: true,
  //       previewIcon: 'assets/icons/company_icon_preview.svg',
  //     ),
  //     HierarchyLevel(
  //       id: 'division',
  //       name: localizations.division,
  //       icon: 'assets/icons/division_icon_small.svg',
  //       level: 2,
  //       isMandatory: false,
  //       isActive: true,
  //       previewIcon: 'assets/icons/division_icon_preview.svg',
  //     ),
  //     HierarchyLevel(
  //       id: 'business_unit',
  //       name: localizations.businessUnit,
  //       icon: 'assets/icons/business_unit_icon_small.svg',
  //       level: 3,
  //       isMandatory: false,
  //       isActive: true,
  //       previewIcon: 'assets/icons/business_unit_icon_preview.svg',
  //     ),
  //     HierarchyLevel(
  //       id: 'department',
  //       name: localizations.department,
  //       icon: 'assets/icons/department_icon_small.svg',
  //       level: 4,
  //       isMandatory: false,
  //       isActive: true,
  //       previewIcon: 'assets/icons/department_icon_preview.svg',
  //     ),
  //     HierarchyLevel(
  //       id: 'section',
  //       name: localizations.section,
  //       icon: 'assets/icons/section_icon_small.svg',
  //       level: 5,
  //       isMandatory: false,
  //       isActive: true,
  //       previewIcon: 'assets/icons/section_icon_preview.svg',
  //     ),
  //   ];
  // }
}

/// Notifier for enterprise structure dialog
/// Automatically loads data when created (each dialog instance gets fresh data)
class EnterpriseStructureDialogNotifier extends StateNotifier<EnterpriseStructureDialogState> {
  final GetStructureLevelsUseCase getStructureLevelsUseCase;
  bool _hasLoaded = false;

  EnterpriseStructureDialogNotifier({required this.getStructureLevelsUseCase})
    : super(const EnterpriseStructureDialogState(structureLevels: [])) {
    // Automatically load data when provider is created
    // This ensures fresh data every time a dialog opens
    _loadData();
  }

  /// Internal method to load data
  Future<void> _loadData() async {
    if (_hasLoaded) return; // Prevent duplicate loads

    _hasLoaded = true;
    state = state.copyWith(isLoading: true, hasError: false, errorMessage: null);

    try {
      final levels = await getStructureLevelsUseCase();
      state = state.copyWith(structureLevels: levels, isLoading: false, hasError: false);
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, hasError: true, errorMessage: e.message);
      _hasLoaded = false; // Allow retry on error
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: 'Failed to load structure levels: ${e.toString()}',
      );
      _hasLoaded = false; // Allow retry on error
    }
  }

  /// Public method to manually load structure levels
  Future<void> loadStructureLevels() async {
    _hasLoaded = false;
    await _loadData();
  }

  /// Refreshes structure levels
  Future<void> refresh() async {
    await loadStructureLevels();
  }
}

/// Provider for enterprise structure dialog notifier
/// Uses a family provider to create a unique instance for each dialog
/// Each dialog instance gets its own provider with a unique key
final enterpriseStructureDialogProvider = StateNotifierProvider.autoDispose
    .family<EnterpriseStructureDialogNotifier, EnterpriseStructureDialogState, String>((ref, dialogId) {
      final useCase = ref.watch(getStructureLevelsUseCaseProvider);
      return EnterpriseStructureDialogNotifier(getStructureLevelsUseCase: useCase);
    });
