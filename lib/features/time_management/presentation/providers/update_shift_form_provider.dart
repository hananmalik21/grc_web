import 'package:grc/core/enums/time_management_enums.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/core/utils/duration_formatter.dart';
import 'package:grc/features/employee_management/domain/models/empl_lookup_value.dart';
import 'package:grc/features/time_management/data/config/shift_form_config.dart';
import 'package:grc/features/time_management/domain/models/shift.dart' hide TimeOfDay;
import 'package:grc/features/time_management/presentation/providers/shifts_provider.dart';
import 'package:grc/features/workforce_structure/presentation/providers/ent_lookup_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateShiftFormState {
  final int shiftId;
  final String code;
  final String nameEn;
  final String nameAr;
  final String? shiftType;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final String duration;
  final String breakDuration;
  final Color selectedColor;
  final String status;
  final Map<String, String> errors;
  final bool isLoading;
  final ShiftOverview? updatedShift;
  final String? errorMessage;

  UpdateShiftFormState({
    required this.shiftId,
    this.code = '',
    this.nameEn = '',
    this.nameAr = '',
    this.shiftType,
    this.startTime,
    this.endTime,
    this.duration = '',
    this.breakDuration = '',
    Color? selectedColor,
    String? status,
    this.errors = const {},
    this.isLoading = false,
    this.updatedShift,
    this.errorMessage,
  }) : selectedColor = selectedColor ?? ShiftFormConfig.defaultColor,
       status = status ?? ShiftFormConfig.statusOptions.first;

  UpdateShiftFormState copyWith({
    int? shiftId,
    String? code,
    String? nameEn,
    String? nameAr,
    String? shiftType,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    String? duration,
    String? breakDuration,
    Color? selectedColor,
    String? status,
    Map<String, String>? errors,
    bool? isLoading,
    bool clearErrors = false,
    ShiftOverview? updatedShift,
    String? errorMessage,
    bool clearUpdatedShift = false,
    bool clearErrorMessage = false,
  }) {
    return UpdateShiftFormState(
      shiftId: shiftId ?? this.shiftId,
      code: code ?? this.code,
      nameEn: nameEn ?? this.nameEn,
      nameAr: nameAr ?? this.nameAr,
      shiftType: shiftType ?? this.shiftType,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      duration: duration ?? this.duration,
      breakDuration: breakDuration ?? this.breakDuration,
      selectedColor: selectedColor ?? this.selectedColor,
      status: status ?? this.status,
      errors: clearErrors ? {} : (errors ?? this.errors),
      isLoading: isLoading ?? this.isLoading,
      updatedShift: clearUpdatedShift ? null : (updatedShift ?? this.updatedShift),
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }

  bool get isValid {
    return nameEn.isNotEmpty &&
        shiftType != null &&
        startTime != null &&
        endTime != null &&
        duration.isNotEmpty &&
        errors.isEmpty;
  }
}

class UpdateShiftFormNotifier extends StateNotifier<UpdateShiftFormState> {
  final int _enterpriseId;
  final ShiftsNotifier? _shiftsNotifier;

  UpdateShiftFormNotifier({
    required int enterpriseId,
    ShiftsNotifier? shiftsNotifier,
    required ShiftOverview initialShift,
  }) : _enterpriseId = enterpriseId,
       _shiftsNotifier = shiftsNotifier,
       super(_initializeFromShift(initialShift));

  static UpdateShiftFormState _initializeFromShift(ShiftOverview shift) {
    TimeOfDay? parseTime(String timeStr) {
      try {
        final parts = timeStr.split(':');
        if (parts.length == 2) {
          final hour = int.tryParse(parts[0]);
          final minute = int.tryParse(parts[1]);
          if (hour != null && minute != null) {
            return TimeOfDay(hour: hour, minute: minute);
          }
        }
      } catch (_) {}
      return null;
    }

    Color parseColor(String hexColor) {
      try {
        final hex = hexColor.replaceAll('#', '');
        if (hex.length == 6) {
          return Color(int.parse('FF$hex', radix: 16));
        }
      } catch (_) {}
      return ShiftFormConfig.defaultColor;
    }

    String getStatusDisplayName(ShiftStatus status) {
      return status.displayName;
    }

    return UpdateShiftFormState(
      shiftId: shift.id,
      code: shift.code,
      nameEn: shift.name,
      nameAr: shift.nameAr,
      shiftType: shift.shiftTypeRaw,
      startTime: parseTime(shift.startTime),
      endTime: parseTime(shift.endTime),
      duration: DurationFormatter.formatHours(shift.totalHours),
      breakDuration: '1',
      selectedColor: parseColor(shift.colorHex),
      status: getStatusDisplayName(shift.status),
    );
  }

  void updateNameEn(String value) {
    final errors = Map<String, String>.from(state.errors);
    errors.remove('nameEn');
    state = state.copyWith(nameEn: value, errors: errors);
  }

  void updateNameAr(String value) {
    final errors = Map<String, String>.from(state.errors);
    errors.remove('nameAr');
    state = state.copyWith(nameAr: value, errors: errors);
  }

  void updateShiftType(String? value) {
    final errors = Map<String, String>.from(state.errors);
    errors.remove('shiftType');
    state = state.copyWith(shiftType: value, errors: errors);
  }

  void updateStartTime(TimeOfDay? value) {
    final errors = Map<String, String>.from(state.errors);
    errors.remove('startTime');
    state = state.copyWith(startTime: value, errors: errors);
    _recomputeDurationAndBreak();
  }

  void updateEndTime(TimeOfDay? value) {
    final errors = Map<String, String>.from(state.errors);
    errors.remove('endTime');
    state = state.copyWith(endTime: value, errors: errors);
    _recomputeDurationAndBreak();
  }

  void _recomputeDurationAndBreak() {
    final start = state.startTime;
    final end = state.endTime;
    if (start == null || end == null) return;

    final startMinutes = _timeOfDayToMinutes(start);
    final endMinutes = _timeOfDayToMinutes(end);
    if (endMinutes <= startMinutes) return;

    final spanHours = (endMinutes - startMinutes) / 60.0;
    const breakHours = 1.0;
    final durationHours = (spanHours - breakHours).clamp(0.0, 24.0);
    state = state.copyWith(duration: DurationFormatter.formatHours(durationHours), breakDuration: '1');
  }

  void updateColor(Color value) {
    state = state.copyWith(selectedColor: value);
  }

  void updateStatus(String value) {
    state = state.copyWith(status: value);
  }

  bool validate() {
    final errors = <String, String>{};

    if (state.nameEn.isEmpty) {
      errors['nameEn'] = 'Shift Name (English) is required';
    }

    if (state.shiftType == null) {
      errors['shiftType'] = 'Shift Type is required';
    }

    if (state.startTime == null) {
      errors['startTime'] = 'Start Time is required';
    }

    if (state.endTime == null) {
      errors['endTime'] = 'End Time is required';
    }

    if (state.duration.isEmpty) {
      errors['duration'] = 'Duration is required';
    }

    state = state.copyWith(errors: errors);
    return errors.isEmpty;
  }

  void reset() {
    state = UpdateShiftFormState(shiftId: state.shiftId, code: state.code);
  }

  int _timeOfDayToMinutes(TimeOfDay time) {
    return time.hour * 60 + time.minute;
  }

  String _colorToHex(Color color) {
    final r = ((color.r * 255.0).round() & 0xff).toRadixString(16).padLeft(2, '0');
    final g = ((color.g * 255.0).round() & 0xff).toRadixString(16).padLeft(2, '0');
    final b = ((color.b * 255.0).round() & 0xff).toRadixString(16).padLeft(2, '0');
    return '#$r$g$b'.toUpperCase();
  }

  Future<ShiftOverview?> updateShift() async {
    if (_shiftsNotifier == null) {
      state = state.copyWith(errorMessage: 'Shifts notifier not available', isLoading: false);
      return null;
    }

    if (!validate()) {
      state = state.copyWith(isLoading: false);
      return null;
    }

    state = state.copyWith(isLoading: true, errorMessage: null, clearErrorMessage: true, clearUpdatedShift: true);

    try {
      final durationValue = double.tryParse(state.duration) ?? 0.0;
      final breakDurationValue = state.breakDuration.isEmpty ? 0.0 : (double.tryParse(state.breakDuration) ?? 0.0);

      final shiftTypeApiValue = state.shiftType ?? 'DAY';

      final shiftData = <String, dynamic>{
        'tenant_id': _enterpriseId,
        'shift_name_en': state.nameEn.trim(),
        'shift_name_ar': state.nameAr.trim(),
        'shift_type': shiftTypeApiValue,
        'start_minutes': _timeOfDayToMinutes(state.startTime!),
        'end_minutes': _timeOfDayToMinutes(state.endTime!),
        'duration_hours': durationValue,
        'break_hours': breakDurationValue.round(),
        'color_hex': _colorToHex(state.selectedColor),
        'status': state.status.toUpperCase(),
      };

      final updatedShift = await _shiftsNotifier.updateShift(shiftId: state.shiftId, shiftData: shiftData);

      state = state.copyWith(isLoading: false, updatedShift: updatedShift, errorMessage: null, clearErrorMessage: true);

      return updatedShift;
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString(), clearUpdatedShift: true);
      return null;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to update shift: ${e.toString()}',
        clearUpdatedShift: true,
      );
      return null;
    }
  }
}

final updateShiftFormProvider = StateNotifierProvider.autoDispose
    .family<UpdateShiftFormNotifier, UpdateShiftFormState, ({ShiftOverview shift, int enterpriseId})>((ref, params) {
      return UpdateShiftFormNotifier(
        enterpriseId: params.enterpriseId,
        shiftsNotifier: ref.read(shiftsNotifierProvider(params.enterpriseId).notifier),
        initialShift: params.shift,
      );
    });

EmplLookupValue? _updateShiftTypeValueByCode(String? code, List<EmplLookupValue> values) {
  if (code == null || code.isEmpty) return null;
  try {
    return values.firstWhere((v) => v.lookupCode == code);
  } catch (_) {
    return null;
  }
}

class UpdateShiftFormViewState {
  const UpdateShiftFormViewState({
    required this.formState,
    required this.formNotifier,
    required this.shiftTypeValues,
    required this.isLoadingShiftTypes,
    required this.selectedShiftType,
  });

  final UpdateShiftFormState formState;
  final UpdateShiftFormNotifier formNotifier;
  final List<EmplLookupValue> shiftTypeValues;
  final bool isLoadingShiftTypes;
  final EmplLookupValue? selectedShiftType;
}

final updateShiftFormViewProvider = Provider.autoDispose
    .family<UpdateShiftFormViewState, ({ShiftOverview shift, int enterpriseId})>((ref, params) {
      final formState = ref.watch(updateShiftFormProvider(params));
      final formNotifier = ref.read(updateShiftFormProvider(params).notifier);
      final lookupAsync = ref.watch(
        entLookupValuesForTypeProvider((enterpriseId: params.enterpriseId, typeCode: shiftTypeLookupCode)),
      );
      final shiftTypeValues = lookupAsync.valueOrNull ?? [];
      final selectedShiftType =
          _updateShiftTypeValueByCode(formState.shiftType, shiftTypeValues) ??
          _updateShiftTypeValueByCode(params.shift.shiftTypeRaw, shiftTypeValues);
      return UpdateShiftFormViewState(
        formState: formState,
        formNotifier: formNotifier,
        shiftTypeValues: shiftTypeValues,
        isLoadingShiftTypes: lookupAsync.isLoading,
        selectedShiftType: selectedShiftType,
      );
    });
