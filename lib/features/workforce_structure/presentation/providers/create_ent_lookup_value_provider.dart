import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/workforce_structure/data/mappers/ent_lookup_value_mapper.dart';
import 'package:grc/features/workforce_structure/domain/models/ent_lookup_value_input.dart';
import 'package:grc/features/workforce_structure/domain/usecases/create_ent_lookup_value_usecase.dart';
import 'package:grc/features/workforce_structure/presentation/providers/create_grade_form_state_provider.dart';
import 'package:grc/features/workforce_structure/presentation/providers/ent_lookup_providers.dart';
import 'package:grc/features/workforce_structure/presentation/providers/grade_structure_enterprise_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final createEntLookupValueUseCaseProvider = Provider<CreateEntLookupValueUseCase>((ref) {
  return CreateEntLookupValueUseCase(ref.read(entLookupRepositoryProvider));
});

class CreateEntLookupValueState {
  final bool isLoading;

  const CreateEntLookupValueState({this.isLoading = false});

  CreateEntLookupValueState copyWith({bool? isLoading}) =>
      CreateEntLookupValueState(isLoading: isLoading ?? this.isLoading);
}

class CreateEntLookupValueNotifier extends StateNotifier<CreateEntLookupValueState> {
  CreateEntLookupValueNotifier(this._ref) : super(const CreateEntLookupValueState());

  final Ref _ref;

  Future<String?> submit({required String lookupTypeCode, required List<EntLookupValueInput> values}) async {
    final enterpriseId = _ref.read(gradeStructureEnterpriseIdProvider);
    if (enterpriseId == null || values.isEmpty) return '';

    state = state.copyWith(isLoading: true);
    try {
      final useCase = _ref.read(createEntLookupValueUseCaseProvider);
      final items = _mapValues(lookupTypeCode: lookupTypeCode, values: values);
      if (items == null) return '';

      await useCase.executeBulk(enterpriseId: enterpriseId, lookupTypeCode: lookupTypeCode, values: items);

      if (lookupTypeCode == 'GRADE_CATEGORY') {
        _ref.invalidate(gradeCategoryLookupValuesProvider);
        await _ref.read(gradeCategoryLookupValuesProvider.future);
      } else if (lookupTypeCode == 'GRADE_NUMBER') {
        _ref.invalidate(gradeNumberLookupValuesProvider);
        await _ref.read(gradeNumberLookupValuesProvider.future);
      }
      return null;
    } on AppException catch (e) {
      final message = e.displayMessage;
      return message.isNotEmpty ? message : '';
    } catch (_) {
      return '';
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  List<EntLookupValueInput>? _mapValues({required String lookupTypeCode, required List<EntLookupValueInput> values}) {
    if (lookupTypeCode == 'GRADE_NUMBER') {
      final category = _ref.read(createGradeFormStateProvider).selectedGradeCategory;
      if (category == null) return null;

      return values
          .map(
            (value) => EntLookupValueInput(
              lookupCode: EntLookupValueMapper.gradeCategoryLookupCode(value.lookupCode),
              meaningEn: value.meaningEn,
            ),
          )
          .toList();
    }

    return values
        .map(
          (value) => EntLookupValueInput(
            lookupCode: EntLookupValueMapper.gradeCategoryLookupCode(value.lookupCode),
            meaningEn: value.meaningEn,
          ),
        )
        .toList();
  }
}

final createEntLookupValueProvider =
    StateNotifierProvider.autoDispose<CreateEntLookupValueNotifier, CreateEntLookupValueState>((ref) {
      return CreateEntLookupValueNotifier(ref);
    });
