import 'package:grc/features/cyber_security/sub_modules/ai_soc_copilot/data/datasources/ai_copilot_remote_data_source.dart';
import 'package:grc/features/cyber_security/sub_modules/ai_soc_copilot/data/models/ai_copilot_dto.dart';

abstract class AiCopilotRepository {
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

class AiCopilotRepositoryImpl implements AiCopilotRepository {
  const AiCopilotRepositoryImpl({
    required AiCopilotRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final AiCopilotRemoteDataSource _remoteDataSource;

  @override
  Future<AiConversationDto> createConversation({
    required String title,
    String contextType = 'GENERAL',
  }) => _remoteDataSource.createConversation(
    title: title,
    contextType: contextType,
  );

  @override
  Future<List<AiConversationDto>> listConversations({
    int page = 1,
    int pageSize = 25,
  }) => _remoteDataSource.listConversations(page: page, pageSize: pageSize);

  @override
  Future<AiConversationDto> getConversation(String id) =>
      _remoteDataSource.getConversation(id);

  @override
  Future<AiMessageResponseDto> sendMessage(
    String conversationId,
    String content,
  ) => _remoteDataSource.sendMessage(conversationId, content);

  @override
  Future<List<AiMessageDto>> listMessages(
    String conversationId, {
    int page = 1,
    int pageSize = 100,
  }) => _remoteDataSource.listMessages(
    conversationId,
    page: page,
    pageSize: pageSize,
  );
}
