import 'dart:convert';
import 'dart:io' show File;
import 'dart:typed_data' show Uint8List;

import 'package:grc/core/models/document_attachment_input.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

/// Builds multipart form-data for POST /rec/requisitions per API contract.
class CreateRequisitionMultipartFormService {
  const CreateRequisitionMultipartFormService();

  static const String defaultInterviewPanelRole = 'INTERVIEWER';

  Future<FormData> build({
    required Map<String, dynamic> fields,
    DocumentAttachmentInput? attachment,
  }) async {
    final allFields = Map<String, dynamic>.from(fields);

    if (attachment == null) {
      allFields['file_name'] = null;
      allFields['mime_type'] = null;
      allFields['file_size'] = null;
    }

    final formData = FormData();

    for (final entry in allFields.entries) {
      final value = entry.value;
      if (value == null) continue;
      formData.fields.add(MapEntry(entry.key, _fieldValueToString(value)));
    }

    if (attachment != null) {
      await _appendFilePart(formData, attachment);
    }

    return formData;
  }

  String _fieldValueToString(Object value) {
    if (value is String) return value;
    if (value is num || value is bool) return value.toString();
    if (value is List || value is Map) return jsonEncode(value);
    return value.toString();
  }

  Future<void> _appendFilePart(FormData formData, DocumentAttachmentInput doc) async {
    Uint8List? bytes = doc.bytes;
    if ((bytes == null || bytes.isEmpty) && !kIsWeb && doc.path.trim().isNotEmpty) {
      try {
        bytes = await File(doc.path).readAsBytes();
      } catch (_) {
        bytes = null;
      }
    }

    final fileSize = doc.size > 0 ? doc.size : (bytes?.length ?? 0);
    formData.fields.add(MapEntry('file_name', doc.name));
    formData.fields.add(MapEntry('mime_type', _mimeType(doc)));
    if (fileSize > 0) {
      formData.fields.add(MapEntry('file_size', fileSize.toString()));
    }

    if (bytes != null && bytes.isNotEmpty) {
      formData.files.add(MapEntry('file', MultipartFile.fromBytes(bytes, filename: doc.name)));
    } else if (!kIsWeb && doc.path.trim().isNotEmpty) {
      try {
        final multipartFile = await MultipartFile.fromFile(doc.path, filename: doc.name);
        formData.files.add(MapEntry('file', multipartFile));
      } catch (_) {}
    }
  }

  String _mimeType(DocumentAttachmentInput doc) {
    final ext = doc.extension?.toLowerCase() ?? doc.name.split('.').last.toLowerCase();
    return switch (ext) {
      'pdf' => 'application/pdf',
      'doc' => 'application/msword',
      'docx' => 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
      'xls' => 'application/vnd.ms-excel',
      'xlsx' => 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      'jpg' || 'jpeg' => 'image/jpeg',
      'png' => 'image/png',
      _ => 'application/octet-stream',
    };
  }
}
