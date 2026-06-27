class AddApplicationNoteInput {
  const AddApplicationNoteInput({
    required this.applicationGuid,
    required this.enterpriseId,
    required this.noteTypeCode,
    required this.noteText,
    required this.isPrivate,
    required this.createdBy,
  });

  final String applicationGuid;
  final int enterpriseId;
  final String noteTypeCode;
  final String noteText;
  final bool isPrivate;
  final String createdBy;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'enterprise_id': enterpriseId,
      'note_type_code': noteTypeCode.trim().toUpperCase(),
      'note_text': noteText.trim(),
      'private_flag': isPrivate ? 'Y' : 'N',
      'created_by': createdBy.trim().isEmpty ? 'ADMIN' : createdBy.trim(),
    };
  }
}
