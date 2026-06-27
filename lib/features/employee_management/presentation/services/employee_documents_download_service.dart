import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/core/network/url_bytes_fetcher.dart';
import 'package:grc/features/employee_management/domain/models/employee_full_details.dart';
import 'package:file_picker/file_picker.dart';

class EmployeeDocumentsDownloadService {
  EmployeeDocumentsDownloadService({required UrlBytesFetcher urlBytesFetcher}) : _urlBytesFetcher = urlBytesFetcher;

  final UrlBytesFetcher _urlBytesFetcher;
  final String _baseUrl = ApiConfig.baseUrl;

  Future<bool> downloadAllAsZip({required List<DocumentItem> documents, required String fileNamePrefix}) async {
    final urls = <String, String>{};
    for (final doc in documents) {
      final url = doc.fullAccessUrl(_baseUrl);
      if (url == null || url.isEmpty) continue;
      final name = _safeFileName(doc.fileName, doc.documentTypeCode, doc.documentId);
      urls[url] = name;
    }
    if (urls.isEmpty) return false;

    final archive = Archive();
    var index = 0;
    for (final entry in urls.entries) {
      try {
        final bytes = await _urlBytesFetcher.getBytes(entry.key);
        if (bytes.isEmpty) continue;
        final name = urls.length > 1 ? _dedupeFileName(entry.value, index) : entry.value;
        archive.addFile(ArchiveFile(name, bytes.length, bytes));
      } catch (_) {
        // skip failed document
      }
      index++;
    }
    if (archive.files.isEmpty) return false;

    final zipBytes = ZipEncoder().encode(archive);

    final suggestedName = '${fileNamePrefix}_documents.zip'.replaceAll(RegExp(r'[^\w\-\. ]'), '_');
    await FilePicker.saveFile(fileName: suggestedName, bytes: Uint8List.fromList(zipBytes));
    return true;
  }

  String _safeFileName(String? fileName, String? typeCode, int docId) {
    if (fileName != null && fileName.trim().isNotEmpty) {
      final base = fileName.trim().replaceAll(RegExp(r'[^\w\-\. ]'), '_');
      return base.length > 80 ? '${base.substring(0, 80)}_$docId' : base;
    }
    final type = (typeCode ?? 'document').replaceAll(RegExp(r'[^\w\-]'), '_');
    return '${type}_$docId';
  }

  String _dedupeFileName(String base, int index) {
    final ext = base.contains('.') ? base.substring(base.lastIndexOf('.')) : '';
    final name = base.contains('.') ? base.substring(0, base.lastIndexOf('.')) : base;
    return '${name}_$index$ext';
  }
}
