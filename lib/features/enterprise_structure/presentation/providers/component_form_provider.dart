import 'package:grc/features/enterprise_structure/domain/models/component_value.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Form mode enum
enum ComponentFormMode { create, edit }

/// State for component form
class ComponentFormState {
  final ComponentFormMode mode;
  final String? id;
  final String code;
  final String name;
  final String arabicName;
  final ComponentType? type;
  final String? parentId;
  final String? managerId;
  final String? location;
  final bool status;
  final String? description;
  final Map<String, String> errors;
  final bool isLoading;

  ComponentFormState({
    this.mode = ComponentFormMode.create,
    this.id,
    this.code = '',
    this.name = '',
    this.arabicName = '',
    this.type,
    this.parentId,
    this.managerId,
    this.location,
    this.status = true,
    this.description,
    this.errors = const {},
    this.isLoading = false,
  });

  ComponentFormState copyWith({
    ComponentFormMode? mode,
    String? id,
    String? code,
    String? name,
    String? arabicName,
    ComponentType? type,
    String? parentId,
    String? managerId,
    String? location,
    bool? status,
    String? description,
    Map<String, String>? errors,
    bool? isLoading,
    bool clearErrors = false,
  }) {
    return ComponentFormState(
      mode: mode ?? this.mode,
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      arabicName: arabicName ?? this.arabicName,
      type: type ?? this.type,
      parentId: parentId ?? this.parentId,
      managerId: managerId ?? this.managerId,
      location: location ?? this.location,
      status: status ?? this.status,
      description: description ?? this.description,
      errors: clearErrors ? {} : (errors ?? this.errors),
      isLoading: isLoading ?? this.isLoading,
    );
  }

  bool get isValid {
    return code.isNotEmpty && type != null && errors.isEmpty;
  }
}

/// StateNotifier for managing component form
class ComponentFormNotifier extends StateNotifier<ComponentFormState> {
  ComponentFormNotifier({ComponentValue? initialValue, ComponentType? defaultType})
    : super(
        initialValue != null
            ? ComponentFormState(
                mode: ComponentFormMode.edit,
                id: initialValue.id,
                code: initialValue.code,
                name: initialValue.name,
                arabicName: initialValue.arabicName,
                type: initialValue.type,
                parentId: initialValue.parentId,
                managerId: initialValue.managerId,
                location: initialValue.location,
                status: initialValue.status,
                description: initialValue.description,
              )
            : ComponentFormState(type: defaultType),
      );

  /// Update field
  void updateField(String field, dynamic value) {
    final errors = Map<String, String>.from(state.errors);
    errors.remove(field); // Clear error for this field

    switch (field) {
      case 'code':
        state = state.copyWith(code: value as String, errors: errors);
        break;
      case 'name':
        state = state.copyWith(name: value as String, errors: errors);
        break;
      case 'arabicName':
        state = state.copyWith(arabicName: value as String, errors: errors);
        break;
      case 'type':
        state = state.copyWith(type: value as ComponentType?, errors: errors);
        break;
      case 'parentId':
        state = state.copyWith(parentId: value as String?, errors: errors);
        break;
      case 'managerId':
        state = state.copyWith(managerId: value as String?, errors: errors);
        break;
      case 'location':
        state = state.copyWith(location: value as String?, errors: errors);
        break;
      case 'status':
        state = state.copyWith(status: value as bool, errors: errors);
        break;
      case 'description':
        state = state.copyWith(description: value as String?, errors: errors);
        break;
    }
  }

  /// Validate form
  bool validate() {
    final errors = <String, String>{};

    if (state.code.isEmpty) {
      errors['code'] = 'Code is required';
    }

    if (state.name.isEmpty) {
      errors['name'] = 'Name is required';
    }

    if (state.type == null) {
      errors['type'] = 'Type is required';
    }

    state = state.copyWith(errors: errors);
    return errors.isEmpty;
  }

  /// Submit form
  Future<bool> submit() async {
    if (!validate()) {
      return false;
    }

    state = state.copyWith(isLoading: true);

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errors: {'general': e.toString()});
      return false;
    }
  }

  /// Reset form
  void reset() {
    state = ComponentFormState();
  }
}

/// Provider for component form (non-family for simplicity)
final componentFormProvider = StateNotifierProvider<ComponentFormNotifier, ComponentFormState>(
  (ref) => ComponentFormNotifier(),
);
