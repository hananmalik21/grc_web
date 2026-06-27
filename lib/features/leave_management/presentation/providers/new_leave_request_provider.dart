import 'package:grc/features/leave_management/data/mappers/leave_type_mapper.dart';
import 'package:grc/features/leave_management/domain/models/document.dart';
import 'package:grc/features/leave_management/domain/repositories/leave_requests_repository.dart';
import 'package:grc/features/leave_management/presentation/config/leave_request_config.dart';
import 'package:grc/features/leave_management/presentation/providers/leave_management_enterprise_provider.dart';
import 'package:grc/features/leave_management/presentation/providers/leave_requests_provider.dart';
import 'package:grc/features/time_management/domain/models/time_off_request.dart';
import 'package:grc/features/workforce_structure/domain/models/employee.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LeaveRequestActionResult {
  const LeaveRequestActionResult._(this.isSuccess, this.errorMessage);
  final bool isSuccess;
  final String? errorMessage;
  factory LeaveRequestActionResult.success() => const LeaveRequestActionResult._(true, null);
  factory LeaveRequestActionResult.failure(String message) => LeaveRequestActionResult._(false, message);
}

enum LeaveRequestStep { leaveDetails, contactNotes, documentsReview }

class NewLeaveRequestState {
  final LeaveRequestStep currentStep;
  final Employee? selectedEmployee;
  final TimeOffType? leaveType;
  final int? leaveTypeId;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? startTime;
  final String? endTime;
  final String? reason;
  final int? delegatedToEmployeeId;
  final String? delegatedToEmployeeName;
  final String? addressDuringLeave;
  final String? contactPhoneNumber;
  final String? emergencyContactName;
  final String? emergencyContactPhone;
  final String? additionalNotes;
  final List<Document> documents;
  final bool isSubmitting;
  final bool isSavingDraft;
  final bool isLoadingDraft;
  final String? editingRequestGuid;
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;

  const NewLeaveRequestState({
    this.currentStep = LeaveRequestStep.leaveDetails,
    this.selectedEmployee,
    this.leaveType,
    this.leaveTypeId,
    this.startDate,
    this.endDate,
    this.startTime,
    this.endTime,
    this.reason,
    this.delegatedToEmployeeId,
    this.delegatedToEmployeeName,
    this.addressDuringLeave,
    this.contactPhoneNumber,
    this.emergencyContactName,
    this.emergencyContactPhone,
    this.additionalNotes,
    this.documents = const [],
    this.isSubmitting = false,
    this.isSavingDraft = false,
    this.isLoadingDraft = false,
    this.editingRequestGuid,
    this.initialStartDate,
    this.initialEndDate,
  });

  NewLeaveRequestState copyWith({
    LeaveRequestStep? currentStep,
    Employee? selectedEmployee,
    TimeOffType? leaveType,
    int? leaveTypeId,
    DateTime? startDate,
    DateTime? endDate,
    String? startTime,
    String? endTime,
    String? reason,
    int? delegatedToEmployeeId,
    String? delegatedToEmployeeName,
    String? addressDuringLeave,
    String? contactPhoneNumber,
    String? emergencyContactName,
    String? emergencyContactPhone,
    String? additionalNotes,
    List<Document>? documents,
    bool? isSubmitting,
    bool? isSavingDraft,
    bool? isLoadingDraft,
    String? editingRequestGuid,
    DateTime? initialStartDate,
    DateTime? initialEndDate,
    bool clearEmployee = false,
    bool clearDelegatedTo = false,
  }) {
    return NewLeaveRequestState(
      currentStep: currentStep ?? this.currentStep,
      selectedEmployee: clearEmployee ? null : (selectedEmployee ?? this.selectedEmployee),
      leaveType: leaveType ?? this.leaveType,
      leaveTypeId: leaveTypeId ?? this.leaveTypeId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      reason: reason ?? this.reason,
      delegatedToEmployeeId: clearDelegatedTo ? null : (delegatedToEmployeeId ?? this.delegatedToEmployeeId),
      delegatedToEmployeeName: clearDelegatedTo ? null : (delegatedToEmployeeName ?? this.delegatedToEmployeeName),
      addressDuringLeave: addressDuringLeave ?? this.addressDuringLeave,
      contactPhoneNumber: contactPhoneNumber ?? this.contactPhoneNumber,
      emergencyContactName: emergencyContactName ?? this.emergencyContactName,
      emergencyContactPhone: emergencyContactPhone ?? this.emergencyContactPhone,
      additionalNotes: additionalNotes ?? this.additionalNotes,
      documents: documents ?? this.documents,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSavingDraft: isSavingDraft ?? this.isSavingDraft,
      isLoadingDraft: isLoadingDraft ?? this.isLoadingDraft,
      editingRequestGuid: editingRequestGuid ?? this.editingRequestGuid,
      initialStartDate: initialStartDate ?? this.initialStartDate,
      initialEndDate: initialEndDate ?? this.initialEndDate,
    );
  }

  int get totalDays {
    if (startDate == null || endDate == null) return 0;
    return endDate!.difference(startDate!).inDays + 1;
  }

  bool get isSameDay {
    if (startDate == null || endDate == null) return true;
    return startDate!.year == endDate!.year && startDate!.month == endDate!.month && startDate!.day == endDate!.day;
  }

  List<Map<String, String>> get availableStartTimeOptions {
    final allOptions = LeaveRequestConfig.leaveTimeOptions;
    if (isSameDay) return allOptions;
    return allOptions.where((opt) => opt['code'] == 'FULL').toList();
  }

  List<Map<String, String>> get availableEndTimeOptions {
    final allOptions = LeaveRequestConfig.leaveTimeOptions;
    if (!isSameDay) return allOptions.where((opt) => opt['code'] == 'FULL').toList();

    if (startTime == 'HALF_PM') {
      return allOptions.where((opt) => opt['code'] != 'HALF_AM').toList();
    }
    if (startTime == 'FULL') {
      return allOptions.where((opt) => opt['code'] == 'FULL').toList();
    }
    return allOptions;
  }

  bool get shouldShowTimeFields {
    if (editingRequestGuid == null) return true;
    if (startDate == null || endDate == null) return false;
    return startDate != initialStartDate || endDate != initialEndDate;
  }
}

class NewLeaveRequestNotifier extends StateNotifier<NewLeaveRequestState> {
  final LeaveRequestsRepository? _repository;
  final Ref? _ref;

  NewLeaveRequestNotifier({LeaveRequestsRepository? repository, Ref? ref})
    : _repository = repository,
      _ref = ref,
      super(const NewLeaveRequestState());

  void setStep(LeaveRequestStep step) {
    state = state.copyWith(currentStep: step);
  }

  String? validateStep(LeaveRequestStep step) {
    switch (step) {
      case LeaveRequestStep.leaveDetails:
        if (state.selectedEmployee == null) return 'Please select an employee';
        if (state.leaveType == null) return 'Please select a leave type';
        if (state.startDate == null) return 'Please select a start date';
        if (state.startTime == null) return 'Please select a start time';
        if (state.endDate == null) return 'Please select an end date';
        if (state.endTime == null) return 'Please select an end time';
        if (state.endDate!.isBefore(state.startDate!)) return 'End date cannot be before start date';
        return null;
      case LeaveRequestStep.contactNotes:
        if (state.reason == null || state.reason!.trim().isEmpty) return 'Please provide a reason for leave';
        if (state.addressDuringLeave == null || state.addressDuringLeave!.trim().isEmpty) {
          return 'Please provide an address during leave';
        }
        if (state.contactPhoneNumber == null || state.contactPhoneNumber!.trim().isEmpty) {
          return 'Please provide a contact phone number';
        }
        if (state.emergencyContactName == null || state.emergencyContactName!.trim().isEmpty) {
          return 'Please provide an emergency contact name';
        }
        if (state.emergencyContactPhone == null || state.emergencyContactPhone!.trim().isEmpty) {
          return 'Please provide an emergency contact phone number';
        }
        return null;
      case LeaveRequestStep.documentsReview:
        return null;
    }
  }

  void _printStepData(LeaveRequestStep step) {
    debugPrint('--- Leave Request Step Data: ${step.name} ---');
    switch (step) {
      case LeaveRequestStep.leaveDetails:
        debugPrint('Employee: ${state.selectedEmployee?.fullName}');
        debugPrint('Leave Type: ${state.leaveType?.name}');
        debugPrint('Start Date: ${state.startDate}');
        debugPrint('End Date: ${state.endDate}');
        debugPrint('Start Time: ${state.startTime}');
        debugPrint('End Time: ${state.endTime}');
        break;
      case LeaveRequestStep.contactNotes:
        debugPrint('Reason: ${state.reason}');
        debugPrint('Delegated To: ${state.delegatedToEmployeeName}');
        debugPrint('Address: ${state.addressDuringLeave}');
        debugPrint('Phone: ${state.contactPhoneNumber}');
        debugPrint('Emergency Contact: ${state.emergencyContactName} (${state.emergencyContactPhone})');
        debugPrint('Additional Notes: ${state.additionalNotes}');
        break;
      case LeaveRequestStep.documentsReview:
        debugPrint('Documents Count: ${state.documents.length}');
        break;
    }
    debugPrint('----------------------------------------------');
  }

  bool canProceedToNextStep() {
    return validateStep(state.currentStep) == null;
  }

  void nextStep() {
    _printStepData(state.currentStep);
    if (!canProceedToNextStep()) return;

    final steps = LeaveRequestStep.values;
    final currentIndex = steps.indexOf(state.currentStep);
    if (currentIndex < steps.length - 1) {
      state = state.copyWith(currentStep: steps[currentIndex + 1]);
    }
  }

  void previousStep() {
    final steps = LeaveRequestStep.values;
    final currentIndex = steps.indexOf(state.currentStep);
    if (currentIndex > 0) {
      state = state.copyWith(currentStep: steps[currentIndex - 1]);
    }
  }

  void updateEmployee(Employee employee) {
    state = state.copyWith(selectedEmployee: employee);
  }

  void setLeaveType(TimeOffType type) {
    state = state.copyWith(leaveType: type);
  }

  void setLeaveTypeFromApi(int leaveTypeId, String leaveCode) {
    final timeOffType = LeaveTypeMapper.getLeaveTypeFromCode(leaveCode);
    state = state.copyWith(leaveType: timeOffType, leaveTypeId: leaveTypeId);
  }

  bool _isSameDay(DateTime? d1, DateTime? d2) {
    if (d1 == null || d2 == null) return true;
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }

  void setStartDate(DateTime date) {
    final bool isMultiDay = !_isSameDay(date, state.endDate);

    if (state.endDate != null && state.endDate!.isBefore(date)) {
      state = state.copyWith(startDate: date, endDate: null, startTime: null, endTime: null);
    } else if (isMultiDay && state.endDate != null) {
      state = state.copyWith(startDate: date, startTime: 'FULL', endTime: 'FULL');
    } else {
      state = state.copyWith(startDate: date);
    }
  }

  void setEndDate(DateTime date) {
    final bool isMultiDay = !_isSameDay(state.startDate, date);

    if (isMultiDay && state.startDate != null) {
      state = state.copyWith(endDate: date, startTime: 'FULL', endTime: 'FULL');
    } else {
      state = state.copyWith(endDate: date);
    }
  }

  void setStartTime(String time) {
    String? newEndTime = state.endTime;
    if (state.isSameDay) {
      if (time == 'HALF_PM' && state.endTime == 'HALF_AM') {
        newEndTime = 'HALF_PM';
      } else if (time == 'FULL') {
        newEndTime = 'FULL';
      }
    }
    state = state.copyWith(startTime: time, endTime: newEndTime);
  }

  void setEndTime(String time) {
    state = state.copyWith(endTime: time);
  }

  void setReason(String? reason) {
    state = state.copyWith(reason: reason);
  }

  void setDelegatedTo(int id, String name) {
    state = state.copyWith(delegatedToEmployeeId: id, delegatedToEmployeeName: name);
  }

  void setAddressDuringLeave(String? address) {
    state = state.copyWith(addressDuringLeave: address);
  }

  void setContactPhoneNumber(String? phone) {
    state = state.copyWith(contactPhoneNumber: phone);
  }

  void setEmergencyContactName(String? name) {
    state = state.copyWith(emergencyContactName: name);
  }

  void setEmergencyContactPhone(String? phone) {
    state = state.copyWith(emergencyContactPhone: phone);
  }

  void setAdditionalNotes(String? notes) {
    state = state.copyWith(additionalNotes: notes);
  }

  void addDocument(Document document) {
    final updatedDocuments = [...state.documents, document];
    state = state.copyWith(documents: updatedDocuments);
  }

  void addDocuments(List<Document> documents) {
    final updatedDocuments = [...state.documents, ...documents];
    state = state.copyWith(documents: updatedDocuments);
  }

  void removeDocument(String documentId) {
    final updatedDocuments = state.documents.where((doc) => doc.id != documentId).toList();
    state = state.copyWith(documents: updatedDocuments);
  }

  void clearDocuments() {
    state = state.copyWith(documents: []);
  }

  void setLoadingDraft(bool isLoading) {
    state = state.copyWith(isLoadingDraft: isLoading);
  }

  void reset() {
    state = const NewLeaveRequestState();
  }

  Future<void> loadDraftData(Map<String, dynamic> responseData, {TimeOffRequest? originalRequest}) async {
    final data = responseData['data'] as List<dynamic>?;
    if (data == null || data.isEmpty) {
      throw Exception('Invalid response data');
    }

    final item = data[0] as Map<String, dynamic>;
    final leaveDetails = item['leave_details'] as Map<String, dynamic>?;
    final leaveContactInfo = item['leave_contact_info'] as Map<String, dynamic>?;
    final leaveDocumentInfo = item['leave_document_info'] as Map<String, dynamic>?;

    if (leaveDetails == null) {
      throw Exception('Leave details not found');
    }

    final employeeInfo = leaveDetails['employee_info'] as Map<String, dynamic>?;
    final leaveTypeInfo = leaveDetails['leave_type_info'] as Map<String, dynamic>?;

    Employee? employee;
    if (employeeInfo != null) {
      employee = Employee(
        id: (employeeInfo['employee_id'] as num?)?.toInt() ?? 0,
        guid: employeeInfo['employee_guid'] as String? ?? '',
        enterpriseId: (leaveDetails['tenant_id'] as num?)?.toInt() ?? 0,
        firstName: employeeInfo['first_name'] as String? ?? '',
        lastName: employeeInfo['last_name'] as String? ?? '',
        email: employeeInfo['email'] as String? ?? '',
        status: '',
        isActive: true,
        createdAt: DateTime.now(),
      );
    } else if (originalRequest != null) {
      final names = originalRequest.employeeName.split(' ');
      employee = Employee(
        id: originalRequest.employeeId,
        guid: originalRequest.employeeGuid ?? '',
        enterpriseId: (leaveDetails['tenant_id'] as num?)?.toInt() ?? 0,
        firstName: names.isNotEmpty ? names.first : '',
        lastName: names.length > 1 ? names.last : '',
        email: '',
        status: '',
        isActive: true,
        createdAt: DateTime.now(),
      );
    }

    TimeOffType? leaveType;
    if (leaveTypeInfo != null) {
      final leaveCode = leaveTypeInfo['leave_code'] as String?;
      leaveType = LeaveTypeMapper.getLeaveTypeFromCode(leaveCode);
    } else if (originalRequest != null && originalRequest.leaveTypeInfo != null) {
      leaveType = LeaveTypeMapper.getLeaveTypeFromCode(originalRequest.leaveTypeInfo!.leaveCode);
    }

    DateTime parseDateTime(dynamic value) {
      if (value == null) return DateTime.now();
      if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
      return DateTime.now();
    }

    String mapPortionToTime(String? portion) {
      if (portion == null) return 'FULL';
      switch (portion.toUpperCase()) {
        case 'FULL_DAY':
        case 'FULL':
          return 'FULL';
        case 'HALF_AM':
          return 'HALF_AM';
        case 'HALF_PM':
          return 'HALF_PM';
        default:
          return 'FULL';
      }
    }

    final start = parseDateTime(leaveDetails['start_date']);
    final end = parseDateTime(leaveDetails['end_date']);

    state = state.copyWith(
      editingRequestGuid: leaveDetails['leave_request_guid'] as String?,
      initialStartDate: start,
      initialEndDate: end,
      selectedEmployee: employee,
      leaveType: leaveType,
      leaveTypeId: (leaveDetails['leave_type_id'] as num?)?.toInt(),
      startDate: start,
      endDate: end,
      startTime: mapPortionToTime(leaveDetails['start_portion'] as String?),
      endTime: mapPortionToTime(leaveDetails['end_portion'] as String?),
      reason: leaveContactInfo?['reason_for_leave'] as String?,
      delegatedToEmployeeId: (leaveContactInfo?['delegated_employee_id'] as num?)?.toInt(),
      addressDuringLeave: leaveContactInfo?['address_during_leave'] as String?,
      contactPhoneNumber: leaveContactInfo?['contact_phone'] as String?,
      emergencyContactName: leaveContactInfo?['emergency_contact_name'] as String?,
      emergencyContactPhone: leaveContactInfo?['emergency_contact_phone'] as String?,
      additionalNotes: leaveContactInfo?['additional_notes'] as String?,
      documents: leaveDocumentInfo != null
          ? [
              Document(
                id: leaveDocumentInfo['document_guid'] as String? ?? '',
                name: leaveDocumentInfo['file_name'] as String? ?? 'Attachment',
                path: '',
                size: 0,
                uploadedAt: parseDateTime(leaveDocumentInfo['creation_date']),
              ),
            ]
          : [],
    );
  }

  Future<LeaveRequestActionResult> submit() async {
    if (_repository == null || _ref == null) {
      return LeaveRequestActionResult.failure('Repository not provided');
    }
    final tenantId = _ref.read(leaveManagementEnterpriseIdProvider);
    state = state.copyWith(isSubmitting: true);
    try {
      if (state.editingRequestGuid != null) {
        await _repository.updateLeaveRequest(state.editingRequestGuid!, state, true, tenantId: tenantId);
      } else {
        await _repository.createLeaveRequest(state, true, tenantId: tenantId);
      }
      state = state.copyWith(isSubmitting: false);
      final leaveRequestsNotifier = _ref.read(leaveRequestsNotifierProvider.notifier);
      leaveRequestsNotifier.refresh();
      return LeaveRequestActionResult.success();
    } catch (e) {
      state = state.copyWith(isSubmitting: false);
      return LeaveRequestActionResult.failure(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<LeaveRequestActionResult> saveAsDraft() async {
    if (_repository == null || _ref == null) {
      return LeaveRequestActionResult.failure('Repository not provided');
    }
    final tenantId = _ref.read(leaveManagementEnterpriseIdProvider);
    state = state.copyWith(isSavingDraft: true);
    try {
      if (state.editingRequestGuid != null) {
        await _repository.updateLeaveRequest(state.editingRequestGuid!, state, false, tenantId: tenantId);
      } else {
        await _repository.createLeaveRequest(state, false, tenantId: tenantId);
      }
      state = state.copyWith(isSavingDraft: false);
      final leaveRequestsNotifier = _ref.read(leaveRequestsNotifierProvider.notifier);
      leaveRequestsNotifier.refresh();
      return LeaveRequestActionResult.success();
    } catch (e) {
      state = state.copyWith(isSavingDraft: false);
      return LeaveRequestActionResult.failure(e.toString().replaceFirst('Exception: ', ''));
    }
  }
}

final newLeaveRequestProvider = StateNotifierProvider.autoDispose<NewLeaveRequestNotifier, NewLeaveRequestState>((ref) {
  final repository = ref.watch(leaveRequestsRepositoryProvider);
  return NewLeaveRequestNotifier(repository: repository, ref: ref);
});
