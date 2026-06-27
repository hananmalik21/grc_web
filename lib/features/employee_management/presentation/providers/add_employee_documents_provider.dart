import 'package:grc/features/employee_management/domain/models/employee_full_details.dart';
import 'package:grc/features/leave_management/domain/models/document.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PendingDocOp {
  const PendingDocOp.add({required this.documentTypeCode, required this.file}) : replaceDocumentId = null;
  const PendingDocOp.replace({required int this.replaceDocumentId, required this.documentTypeCode, required this.file});

  final int? replaceDocumentId;
  final String documentTypeCode;
  final Document file;

  bool get isAdd => replaceDocumentId == null;
  bool get isReplace => replaceDocumentId != null;
}

class AddEmployeeDocumentsState {
  final DateTime? civilIdExpiry;
  final DateTime? passportExpiry;
  final String? visaNumber;
  final DateTime? visaExpiry;
  final String? workPermitNumber;
  final DateTime? workPermitExpiry;
  final Document? document;
  final String? documentTypeCode;
  final String? existingDocumentFileName;
  final List<DocumentItem> existingDocuments;
  final PendingDocOp? pendingDocOp;

  const AddEmployeeDocumentsState({
    this.civilIdExpiry,
    this.passportExpiry,
    this.visaNumber,
    this.visaExpiry,
    this.workPermitNumber,
    this.workPermitExpiry,
    this.document,
    this.documentTypeCode,
    this.existingDocumentFileName,
    this.existingDocuments = const [],
    this.pendingDocOp,
  });

  static bool _isFilled(String? value) {
    final t = value?.trim();
    return t != null && t.isNotEmpty;
  }

  bool get isStepValid =>
      civilIdExpiry != null &&
      passportExpiry != null &&
      _isFilled(visaNumber) &&
      visaExpiry != null &&
      _isFilled(workPermitNumber) &&
      workPermitExpiry != null;

  AddEmployeeDocumentsState copyWith({
    DateTime? civilIdExpiry,
    DateTime? passportExpiry,
    String? visaNumber,
    DateTime? visaExpiry,
    String? workPermitNumber,
    DateTime? workPermitExpiry,
    Document? document,
    String? documentTypeCode,
    String? existingDocumentFileName,
    List<DocumentItem>? existingDocuments,
    PendingDocOp? pendingDocOp,
    bool clearCivilIdExpiry = false,
    bool clearPassportExpiry = false,
    bool clearVisaNumber = false,
    bool clearVisaExpiry = false,
    bool clearWorkPermitNumber = false,
    bool clearWorkPermitExpiry = false,
    bool clearDocument = false,
    bool clearDocumentTypeCode = false,
    bool clearExistingDocumentFileName = false,
    bool clearPendingDocOp = false,
  }) {
    return AddEmployeeDocumentsState(
      civilIdExpiry: clearCivilIdExpiry ? null : (civilIdExpiry ?? this.civilIdExpiry),
      passportExpiry: clearPassportExpiry ? null : (passportExpiry ?? this.passportExpiry),
      visaNumber: clearVisaNumber ? null : (visaNumber ?? this.visaNumber),
      visaExpiry: clearVisaExpiry ? null : (visaExpiry ?? this.visaExpiry),
      workPermitNumber: clearWorkPermitNumber ? null : (workPermitNumber ?? this.workPermitNumber),
      workPermitExpiry: clearWorkPermitExpiry ? null : (workPermitExpiry ?? this.workPermitExpiry),
      document: clearDocument ? null : (document ?? this.document),
      documentTypeCode: clearDocumentTypeCode ? null : (documentTypeCode ?? this.documentTypeCode),
      existingDocumentFileName: clearExistingDocumentFileName
          ? null
          : (existingDocumentFileName ?? this.existingDocumentFileName),
      existingDocuments: existingDocuments ?? this.existingDocuments,
      pendingDocOp: clearPendingDocOp ? null : (pendingDocOp ?? this.pendingDocOp),
    );
  }
}

class AddEmployeeDocumentsNotifier extends StateNotifier<AddEmployeeDocumentsState> {
  AddEmployeeDocumentsNotifier() : super(const AddEmployeeDocumentsState());

  void setCivilIdExpiry(DateTime? value) {
    state = state.copyWith(civilIdExpiry: value, clearCivilIdExpiry: value == null);
  }

  void setPassportExpiry(DateTime? value) {
    state = state.copyWith(passportExpiry: value, clearPassportExpiry: value == null);
  }

  void setVisaNumber(String? value) {
    state = state.copyWith(visaNumber: value, clearVisaNumber: value == null || value.isEmpty);
  }

  void setVisaExpiry(DateTime? value) {
    state = state.copyWith(visaExpiry: value, clearVisaExpiry: value == null);
  }

  void setWorkPermitNumber(String? value) {
    state = state.copyWith(workPermitNumber: value, clearWorkPermitNumber: value == null || value.isEmpty);
  }

  void setWorkPermitExpiry(DateTime? value) {
    state = state.copyWith(workPermitExpiry: value, clearWorkPermitExpiry: value == null);
  }

  void setDocument(Document? value) {
    state = state.copyWith(
      document: value,
      clearDocument: value == null,
      clearDocumentTypeCode: value == null,
      clearExistingDocumentFileName: value != null,
    );
  }

  void setDocumentTypeCode(String? value) {
    state = state.copyWith(documentTypeCode: value, clearDocumentTypeCode: value == null || value.isEmpty);
  }

  void setFromFullDetails({
    DateTime? civilIdExpiry,
    DateTime? passportExpiry,
    String? visaNumber,
    DateTime? visaExpiry,
    String? workPermitNumber,
    DateTime? workPermitExpiry,
    String? documentTypeCode,
    String? existingDocumentFileName,
    List<DocumentItem>? documents,
  }) {
    state = state.copyWith(
      civilIdExpiry: civilIdExpiry ?? state.civilIdExpiry,
      passportExpiry: passportExpiry ?? state.passportExpiry,
      visaNumber: visaNumber ?? state.visaNumber,
      visaExpiry: visaExpiry ?? state.visaExpiry,
      workPermitNumber: workPermitNumber ?? state.workPermitNumber,
      workPermitExpiry: workPermitExpiry ?? state.workPermitExpiry,
      documentTypeCode: documentTypeCode ?? state.documentTypeCode,
      existingDocumentFileName: existingDocumentFileName ?? state.existingDocumentFileName,
      existingDocuments: documents ?? state.existingDocuments,
    );
  }

  void setPendingAdd({required String documentTypeCode, required Document file}) {
    state = state.copyWith(
      pendingDocOp: PendingDocOp.add(documentTypeCode: documentTypeCode, file: file),
      clearPendingDocOp: false,
    );
  }

  void setPendingReplace({required int replaceDocumentId, required String documentTypeCode, required Document file}) {
    state = state.copyWith(
      pendingDocOp: PendingDocOp.replace(
        replaceDocumentId: replaceDocumentId,
        documentTypeCode: documentTypeCode,
        file: file,
      ),
      clearPendingDocOp: false,
    );
  }

  void clearPendingDocOp() {
    state = state.copyWith(clearPendingDocOp: true);
  }

  void reset() {
    state = const AddEmployeeDocumentsState();
  }
}

final addEmployeeDocumentsProvider = StateNotifierProvider<AddEmployeeDocumentsNotifier, AddEmployeeDocumentsState>((
  ref,
) {
  return AddEmployeeDocumentsNotifier();
});
