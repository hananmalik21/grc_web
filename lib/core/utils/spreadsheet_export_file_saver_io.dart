import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

Future<bool> saveSpreadsheetExportBytes({required Uint8List bytes, required String fileName}) async {
  final path = await FilePicker.saveFile(fileName: fileName, bytes: bytes);
  return path != null;
}
