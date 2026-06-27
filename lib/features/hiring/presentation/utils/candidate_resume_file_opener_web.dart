import 'dart:js_interop';
import 'dart:typed_data';
import 'package:web/web.dart' as web;

Future<bool> openResumeBytes({required Uint8List bytes, required String fileName, required String mimeType}) async {
  final data = bytes.buffer.toJS;
  final blob = web.Blob([data].toJS, web.BlobPropertyBag(type: mimeType));
  final url = web.URL.createObjectURL(blob);
  web.window.open(url, '_blank');
  web.URL.revokeObjectURL(url);
  return true;
}
