import 'dart:typed_data';

import 'spreadsheet_export_file_saver_stub.dart'
    if (dart.library.html) 'spreadsheet_export_file_saver_web.dart'
    if (dart.library.io) 'spreadsheet_export_file_saver_io.dart'
    as saver;

Future<bool> saveSpreadsheetExportFile({required Uint8List bytes, required String fileName}) {
  return saver.saveSpreadsheetExportBytes(bytes: bytes, fileName: fileName);
}
