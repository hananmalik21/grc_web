import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/cyber_security/sub_modules/ai_soc_copilot/data/models/ai_copilot_dto.dart';

abstract class AiCopilotRemoteDataSource {
  Future<AiConversationDto> createConversation({
    required String title,
    String contextType = 'GENERAL',
  });
  Future<List<AiConversationDto>> listConversations({
    int page = 1,
    int pageSize = 25,
  });
  Future<AiConversationDto> getConversation(String id);
  Future<AiMessageResponseDto> sendMessage(
    String conversationId,
    String content,
  );
  Future<List<AiMessageDto>> listMessages(
    String conversationId, {
    int page = 1,
    int pageSize = 100,
  });
}

class DioAiCopilotRemoteDataSource implements AiCopilotRemoteDataSource {
  const DioAiCopilotRemoteDataSource({required ApiClient apiClient})
    : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<AiConversationDto> createConversation({
    required String title,
    String contextType = 'GENERAL',
  }) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.aiConversations,
        body: {'title': title, 'contextType': contextType},
      );
      return AiConversationDto.fromJson(
        response['data'] as Map<String, dynamic>,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to create AI conversation: ${e.toString()}',
        originalError: e,
      );
    }
  }

  @override
  Future<List<AiConversationDto>> listConversations({
    int page = 1,
    int pageSize = 25,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.aiConversations,
        queryParameters: {'page': '$page', 'pageSize': '$pageSize'},
      );
      return _listFrom(
        response['data'],
      ).map(AiConversationDto.fromJson).toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to load AI conversations: ${e.toString()}',
        originalError: e,
      );
    }
  }

  @override
  Future<AiConversationDto> getConversation(String id) async {
    try {
      final response = await _apiClient.get(ApiEndpoints.aiConversation(id));
      return AiConversationDto.fromJson(
        response['data'] as Map<String, dynamic>,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to load AI conversation: ${e.toString()}',
        originalError: e,
      );
    }
  }

  @override
  Future<AiMessageResponseDto> sendMessage(
    String conversationId,
    String content,
  ) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.aiConversationMessages(conversationId),
        body: {'content': content},
      );
      return AiMessageResponseDto.fromJson(
        response['data'] as Map<String, dynamic>,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to send AI message: ${e.toString()}',
        originalError: e,
      );
    }
  }

  @override
  Future<List<AiMessageDto>> listMessages(
    String conversationId, {
    int page = 1,
    int pageSize = 100,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.aiConversationMessages(conversationId),
        queryParameters: {'page': '$page', 'pageSize': '$pageSize'},
      );
      return _listFrom(response['data']).map(AiMessageDto.fromJson).toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to load AI messages: ${e.toString()}',
        originalError: e,
      );
    }
  }

  List<Map<String, dynamic>> _listFrom(dynamic value) {
    if (value is! List) return const [];
    return value.whereType<Map<String, dynamic>>().toList();
  }
}
