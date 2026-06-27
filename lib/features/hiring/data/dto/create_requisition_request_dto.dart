import 'package:grc/core/models/document_attachment_input.dart';

class CreateRequisitionRequestDto {
  const CreateRequisitionRequestDto({required this.fields, this.attachment});

  final Map<String, dynamic> fields;
  final DocumentAttachmentInput? attachment;
}
