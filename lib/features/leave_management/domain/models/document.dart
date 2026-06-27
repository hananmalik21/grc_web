import 'dart:typed_data' show Uint8List;

class Document {
  final String id;
  final String name;
  final String path;
  final int size;
  final String? extension;
  final DateTime uploadedAt;

  final Uint8List? bytes;

  const Document({
    required this.id,
    required this.name,
    required this.path,
    required this.size,
    this.extension,
    required this.uploadedAt,
    this.bytes,
  });

  String get formattedSize {
    if (size < 1024) {
      return '$size B';
    } else if (size < 1024 * 1024) {
      return '${(size / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(size / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }

  Document copyWith({
    String? id,
    String? name,
    String? path,
    int? size,
    String? extension,
    DateTime? uploadedAt,
    Uint8List? bytes,
  }) {
    return Document(
      id: id ?? this.id,
      name: name ?? this.name,
      path: path ?? this.path,
      size: size ?? this.size,
      extension: extension ?? this.extension,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      bytes: bytes ?? this.bytes,
    );
  }
}
