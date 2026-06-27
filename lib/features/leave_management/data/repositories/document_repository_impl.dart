import 'dart:io' show File;
import 'dart:typed_data' show Uint8List;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:grc/features/leave_management/domain/models/document.dart';
import 'package:grc/features/leave_management/domain/repositories/document_repository.dart';

class DocumentRepositoryImpl implements DocumentRepository {
  static const int maxFileSizeBytes = 10 * 1024 * 1024;
  static const List<String> allowedExtensions = ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'];

  @override
  Future<Document?> pickFile({List<String>? allowedExtensions, int? maxSizeInBytes}) async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedExtensions ?? DocumentRepositoryImpl.allowedExtensions,
        withData: kIsWeb,
      );

      if (result == null || result.files.isEmpty) {
        return null;
      }

      final platformFile = result.files.first;

      int fileSize;
      String filePath;

      if (kIsWeb) {
        if (platformFile.bytes == null) {
          return null;
        }
        fileSize = platformFile.bytes!.length;
        filePath = platformFile.name;
        final maxSize = maxSizeInBytes ?? maxFileSizeBytes;
        if (fileSize > maxSize) {
          throw Exception('File size exceeds the maximum allowed size of ${maxSize ~/ (1024 * 1024)} MB');
        }
        return Document(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: platformFile.name,
          path: filePath,
          size: fileSize,
          extension: platformFile.extension?.toLowerCase(),
          uploadedAt: DateTime.now(),
          bytes: Uint8List.fromList(platformFile.bytes!),
        );
      } else {
        if (platformFile.path == null) {
          return null;
        }
        try {
          final file = File(platformFile.path!);
          fileSize = await file.length();
        } catch (e) {
          fileSize = platformFile.size;
        }
        filePath = platformFile.path!;
      }

      final maxSize = maxSizeInBytes ?? maxFileSizeBytes;
      if (fileSize > maxSize) {
        throw Exception('File size exceeds the maximum allowed size of ${maxSize ~/ (1024 * 1024)} MB');
      }

      final extension = platformFile.extension?.toLowerCase();

      return Document(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: platformFile.name,
        path: filePath,
        size: fileSize,
        extension: extension,
        uploadedAt: DateTime.now(),
      );
    } catch (e) {
      throw Exception('Failed to pick file: $e');
    }
  }

  @override
  Future<List<Document>> pickFiles({List<String>? allowedExtensions, int? maxSizeInBytes}) async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedExtensions ?? DocumentRepositoryImpl.allowedExtensions,
        allowMultiple: true,
        withData: kIsWeb,
      );

      if (result == null || result.files.isEmpty) {
        return [];
      }

      final maxSize = maxSizeInBytes ?? maxFileSizeBytes;
      final documents = <Document>[];

      for (final platformFile in result.files) {
        int fileSize;
        String filePath;

        if (kIsWeb) {
          if (platformFile.bytes == null) continue;
          fileSize = platformFile.bytes!.length;
          filePath = platformFile.name;
        } else {
          if (platformFile.path == null) continue;
          try {
            final file = File(platformFile.path!);
            fileSize = await file.length();
          } catch (e) {
            fileSize = platformFile.size;
          }
          filePath = platformFile.path!;
        }

        if (fileSize > maxSize) {
          continue;
        }

        final extension = platformFile.extension?.toLowerCase();

        documents.add(
          Document(
            id: '${DateTime.now().millisecondsSinceEpoch}_${documents.length}',
            name: platformFile.name,
            path: filePath,
            size: fileSize,
            extension: extension,
            uploadedAt: DateTime.now(),
            bytes: kIsWeb ? Uint8List.fromList(platformFile.bytes!) : null,
          ),
        );
      }

      return documents;
    } catch (e) {
      throw Exception('Failed to pick files: $e');
    }
  }

  @override
  Future<void> removeDocument(String path) async {
    try {
      if (kIsWeb) {
        return;
      }
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      throw Exception('Failed to remove document: $e');
    }
  }
}
