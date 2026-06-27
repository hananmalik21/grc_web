import 'package:grc/features/developer_tools/data/datasources/function_management_remote_data_source.dart';
import 'package:grc/features/developer_tools/presentation/providers/function_management_enterprise_provider.dart';
import 'package:grc/features/developer_tools/data/models/action_item.dart';
import 'package:grc/features/developer_tools/data/models/module_item.dart';
import 'package:grc/features/developer_tools/data/models/submodule_item.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateFunctionFormState {
  const CreateFunctionFormState({
    this.functionName = '',
    this.functionCode = '',
    this.description = '',
    this.selectedModule,
    this.selectedSubmodule,
    this.selectedAction,
    this.isLoading = false,
    this.errorMessage,
  });

  final String functionName;
  final String functionCode;
  final String description;
  final ModuleItem? selectedModule;
  final SubmoduleItem? selectedSubmodule;
  final ActionItem? selectedAction;
  final bool isLoading;
  final String? errorMessage;

  CreateFunctionFormState copyWith({
    String? functionName,
    String? functionCode,
    String? description,
    ModuleItem? selectedModule,
    bool clearSelectedModule = false,
    SubmoduleItem? selectedSubmodule,
    bool clearSelectedSubmodule = false,
    ActionItem? selectedAction,
    bool clearSelectedAction = false,
    bool? isLoading,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return CreateFunctionFormState(
      functionName: functionName ?? this.functionName,
      functionCode: functionCode ?? this.functionCode,
      description: description ?? this.description,
      selectedModule: clearSelectedModule ? null : (selectedModule ?? this.selectedModule),
      selectedSubmodule: clearSelectedSubmodule ? null : (selectedSubmodule ?? this.selectedSubmodule),
      selectedAction: clearSelectedAction ? null : (selectedAction ?? this.selectedAction),
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class CreateFunctionFormNotifier extends StateNotifier<CreateFunctionFormState> {
  CreateFunctionFormNotifier(this._dataSource, this._enterpriseId) : super(const CreateFunctionFormState());

  final FunctionManagementRemoteDataSource _dataSource;
  final int? _enterpriseId;

  void updateFunctionName(String value) {
    state = state.copyWith(functionName: value);
  }

  void updateFunctionCode(String value) {
    state = state.copyWith(functionCode: value);
  }

  void updateDescription(String value) {
    state = state.copyWith(description: value);
  }

  void selectModule(ModuleItem value) {
    final hasChanged = value.moduleGuid != state.selectedModule?.moduleGuid;
    state = state.copyWith(selectedModule: value, clearSelectedSubmodule: hasChanged, clearSelectedAction: hasChanged);
  }

  void selectSubmodule(SubmoduleItem value) {
    final hasChanged = value.subModuleGuid != state.selectedSubmodule?.subModuleGuid;
    state = state.copyWith(selectedSubmodule: value, clearSelectedAction: hasChanged);
  }

  void selectAction(ActionItem value) {
    state = state.copyWith(selectedAction: value);
  }

  /// Returns `true` on success, `false` on failure.
  Future<bool> submitCreateFunction() async {
    final module = state.selectedModule!;
    final submodule = state.selectedSubmodule!;
    final action = state.selectedAction!;

    final permissionKey =
        '${module.moduleCode.toLowerCase()}.${submodule.subModuleCode.toLowerCase()}.${action.actionCode.toLowerCase()}';
    final functionType = action.actionCode.trim().toUpperCase();

    final routeUrl = '/${state.functionCode.toLowerCase().replaceAll('_', '-')}';

    state = state.copyWith(isLoading: true, clearErrorMessage: true);
    try {
      await _dataSource.createFunction(
        body: {
          'enterprise_id': _enterpriseId ?? 1,
          'module_guid': module.moduleGuid,
          'function_code': state.functionCode,
          'function_name': state.functionName,
          'description': state.description.trim().isEmpty ? null : state.description.trim(),
          'function_type': functionType.isEmpty ? 'MENU' : functionType,
          'permission_key': permissionKey,
          'route_url': routeUrl,
          'display_order': 1,
          'active_flag': 'Y',
          'is_system_flag': 'Y',
          'created_by': 'ADMIN',
        },
      );
      if (!mounted) return false;
      state = state.copyWith(isLoading: false, clearErrorMessage: true);
      return true;
    } on AppException catch (e) {
      if (!mounted) return false;
      state = state.copyWith(isLoading: false, errorMessage: e.message);
      return false;
    } catch (e) {
      if (!mounted) return false;
      state = state.copyWith(isLoading: false, errorMessage: 'Failed to create function: ${e.toString()}');
      return false;
    }
  }
}

final createFunctionFormProvider =
    StateNotifierProvider.autoDispose<CreateFunctionFormNotifier, CreateFunctionFormState>(
      (ref) => CreateFunctionFormNotifier(
        ref.watch(functionManagementDataSourceProvider),
        ref.watch(functionManagementEnterpriseIdProvider),
      ),
    );
