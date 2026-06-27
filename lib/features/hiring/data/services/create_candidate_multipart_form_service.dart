import 'dart:convert';
import 'dart:io' show File;
import 'dart:typed_data' show Uint8List;

import 'package:grc/core/models/document_attachment_input.dart';
import 'package:grc/features/hiring/domain/models/candidates/create_candidate_request_input.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class CreateCandidateMultipartFormService {
  const CreateCandidateMultipartFormService();

  Future<FormData> build(CreateCandidateRequestInput input) async {
    final formData = FormData();

    final fields = <String, dynamic>{
      'created_by': input.createdBy,
      'enterprise_id': input.enterpriseId,
      'first_name': input.firstName,
      'last_name': input.lastName,
      'email': input.email,
      'phone': input.phone,
      'source': input.source,
      'education_json': jsonEncode(input.educationEntries.map((e) => e.toApiJson()).toList()),
      'experience_json': jsonEncode(input.workExperienceEntries.map((e) => e.toApiJson()).toList()),
      if (input.middleName != null) 'middle_name': input.middleName,
      if (input.currentTitle != null) 'current_title': input.currentTitle,
      if (input.currentEmployer != null) 'current_employer': input.currentEmployer,
      if (input.yearsExperience != null) 'years_experience': input.yearsExperience,
      if (input.currentLocation != null) 'current_location': input.currentLocation,
      if (input.expectedSalary != null) 'expected_salary': input.expectedSalary,
      if (input.salaryCurrency != null) 'salary_currency': input.salaryCurrency,
      if (input.noticePeriod != null) 'notice_period': input.noticePeriod,
      if (input.linkedinProfile != null) 'linkedin_profile': input.linkedinProfile,
    };

    for (final entry in fields.entries) {
      formData.fields.add(MapEntry(entry.key, _fieldValueToString(entry.value)));
    }

    if (input.resume != null) {
      await _appendResume(formData, input.resume!);
    }

    return formData;
  }

  String _fieldValueToString(Object value) {
    if (value is String) return value;
    if (value is num || value is bool) return value.toString();
    if (value is List || value is Map) return jsonEncode(value);
    return value.toString();
  }

  Future<void> _appendResume(FormData formData, DocumentAttachmentInput doc) async {
    Uint8List? bytes = doc.bytes;
    if ((bytes == null || bytes.isEmpty) && !kIsWeb && doc.path.trim().isNotEmpty) {
      try {
        bytes = await File(doc.path).readAsBytes();
      } catch (_) {
        bytes = null;
      }
    }

    if (bytes != null && bytes.isNotEmpty) {
      formData.files.add(
        MapEntry('resume', MultipartFile.fromBytes(bytes, filename: doc.name, contentType: _resumeContentType(doc))),
      );
      return;
    }

    if (!kIsWeb && doc.path.trim().isNotEmpty) {
      final multipartFile = await MultipartFile.fromFile(
        doc.path,
        filename: doc.name,
        contentType: _resumeContentType(doc),
      );
      formData.files.add(MapEntry('resume', multipartFile));
    }
  }

  DioMediaType? _resumeContentType(DocumentAttachmentInput doc) {
    final ext = doc.extension?.toLowerCase() ?? doc.name.split('.').lastOrNull?.toLowerCase();
    final mime = switch (ext) {
      'pdf' => 'application/pdf',
      'doc' => 'application/msword',
      'docx' => 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
      _ => null,
    };
    if (mime == null) return null;
    return DioMediaType.parse(mime);
  }
}
