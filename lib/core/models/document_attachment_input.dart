import 'dart:typed_data' show Uint8List;

class DocumentAttachmentInput {
  const DocumentAttachmentInput({
    required this.name,
    required this.path,
    required this.size,
    this.bytes,
    this.extension,
  });

  final String name;
  final String path;
  final int size;
  final Uint8List? bytes;
  final String? extension;
}
