class AiCitationDto {
  final String chunkId;
  final String sourceType;
  final String sourceId;
  final double similarity;

  const AiCitationDto({
    required this.chunkId,
    required this.sourceType,
    required this.sourceId,
    required this.similarity,
  });

  factory AiCitationDto.fromJson(Map<String, dynamic> json) => AiCitationDto(
    chunkId: json['chunkId']?.toString() ?? json['chunk_id']?.toString() ?? '',
    sourceType:
        json['sourceType']?.toString() ?? json['source_type']?.toString() ?? '',
    sourceId:
        json['sourceId']?.toString() ?? json['source_id']?.toString() ?? '',
    similarity: (json['similarity'] as num?)?.toDouble() ?? 0,
  );
}

class AiConversationDto {
  final String id;
  final String title;
  final String contextType;
  final String? contextId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const AiConversationDto({
    required this.id,
    required this.title,
    required this.contextType,
    this.contextId,
    this.createdAt,
    this.updatedAt,
  });

  factory AiConversationDto.fromJson(Map<String, dynamic> json) =>
      AiConversationDto(
        id: json['id']?.toString() ?? '',
        title: json['title']?.toString() ?? '',
        contextType:
            json['contextType']?.toString() ??
            json['context_type']?.toString() ??
            'GENERAL',
        contextId:
            json['contextId']?.toString() ?? json['context_id']?.toString(),
        createdAt: _parseDate(json['createdAt'] ?? json['created_at']),
        updatedAt: _parseDate(json['updatedAt'] ?? json['updated_at']),
      );
}

class AiMessageDto {
  final String id;
  final String conversationId;
  final String role;
  final String content;
  final List<AiCitationDto> citations;
  final int tokensUsed;
  final DateTime? createdAt;

  const AiMessageDto({
    required this.id,
    required this.conversationId,
    required this.role,
    required this.content,
    this.citations = const [],
    this.tokensUsed = 0,
    this.createdAt,
  });

  factory AiMessageDto.fromJson(Map<String, dynamic> json) => AiMessageDto(
    id: json['id']?.toString() ?? '',
    conversationId:
        json['conversationId']?.toString() ??
        json['conversation_id']?.toString() ??
        '',
    role: json['role']?.toString() ?? 'ASSISTANT',
    content: json['content']?.toString() ?? '',
    citations:
        (json['citations'] as List<dynamic>?)
            ?.map(
              (item) => AiCitationDto.fromJson(item as Map<String, dynamic>),
            )
            .toList() ??
        const [],
    tokensUsed:
        (json['tokensUsed'] as num?)?.toInt() ??
        (json['tokens_used'] as num?)?.toInt() ??
        0,
    createdAt: _parseDate(json['createdAt'] ?? json['created_at']),
  );
}

class AiMessageResponseDto {
  final AiMessageDto message;
  final List<AiCitationDto> citations;

  const AiMessageResponseDto({required this.message, required this.citations});

  factory AiMessageResponseDto.fromJson(Map<String, dynamic> json) {
    final messageJson = json['message'] as Map<String, dynamic>? ?? json;
    final citations =
        (json['citations'] as List<dynamic>?)
            ?.map(
              (item) => AiCitationDto.fromJson(item as Map<String, dynamic>),
            )
            .toList() ??
        const <AiCitationDto>[];
    return AiMessageResponseDto(
      message: AiMessageDto.fromJson(messageJson),
      citations: citations,
    );
  }
}

DateTime? _parseDate(dynamic value) {
  if (value == null) return null;
  return DateTime.tryParse(value.toString());
}
