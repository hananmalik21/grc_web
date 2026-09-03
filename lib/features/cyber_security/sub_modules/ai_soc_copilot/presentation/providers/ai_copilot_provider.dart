import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/features/auth/presentation/providers/auth_provider.dart';
import 'package:grc/features/cyber_security/sub_modules/ai_soc_copilot/data/datasources/ai_copilot_remote_data_source.dart';
import 'package:grc/features/cyber_security/sub_modules/ai_soc_copilot/data/models/ai_copilot_dto.dart';
import 'package:grc/features/cyber_security/sub_modules/ai_soc_copilot/data/repositories/ai_copilot_repository.dart';

final aiCopilotApiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(
    baseUrl: ApiConfig.baseUrl,
    authStorage: ref.watch(authLocalStorageProvider),
  );
});

final aiCopilotRemoteDataSourceProvider = Provider<AiCopilotRemoteDataSource>((
  ref,
) {
  return DioAiCopilotRemoteDataSource(
    apiClient: ref.watch(aiCopilotApiClientProvider),
  );
});

final aiCopilotRepositoryProvider = Provider<AiCopilotRepository>((ref) {
  return AiCopilotRepositoryImpl(
    remoteDataSource: ref.watch(aiCopilotRemoteDataSourceProvider),
  );
});

class AiCopilotState {
  final bool isLoading;
  final bool isSending;
  final String? conversationId;
  final List<AiMessageDto> messages;
  final String? error;

  const AiCopilotState({
    this.isLoading = true,
    this.isSending = false,
    this.conversationId,
    this.messages = const [],
    this.error,
  });

  AiCopilotState copyWith({
    bool? isLoading,
    bool? isSending,
    Object? conversationId = _unset,
    List<AiMessageDto>? messages,
    Object? error = _unset,
  }) {
    return AiCopilotState(
      isLoading: isLoading ?? this.isLoading,
      isSending: isSending ?? this.isSending,
      conversationId: identical(conversationId, _unset)
          ? this.conversationId
          : conversationId as String?,
      messages: messages ?? this.messages,
      error: identical(error, _unset) ? this.error : error as String?,
    );
  }
}

const _unset = Object();

class AiCopilotNotifier extends StateNotifier<AiCopilotState> {
  AiCopilotNotifier(this._repository) : super(const AiCopilotState()) {
    initialize();
  }

  final AiCopilotRepository _repository;

  Future<void> initialize() async {
    try {
      final conversations = await _repository.listConversations(pageSize: 1);
      final conversation = conversations.isNotEmpty
          ? conversations.first
          : await _repository.createConversation(
              title: 'Security Investigation',
            );
      final messages = await _repository.listMessages(conversation.id);
      state = state.copyWith(
        isLoading: false,
        conversationId: conversation.id,
        messages: messages,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> sendMessage(String content) async {
    final conversationId = state.conversationId;
    if (conversationId == null || state.isSending) return;

    final userMessage = AiMessageDto(
      id: 'local-${DateTime.now().microsecondsSinceEpoch}',
      conversationId: conversationId,
      role: 'USER',
      content: content,
      createdAt: DateTime.now(),
    );
    state = state.copyWith(
      isSending: true,
      messages: [...state.messages, userMessage],
      error: null,
    );

    try {
      final response = await _repository.sendMessage(conversationId, content);
      state = state.copyWith(
        isSending: false,
        messages: [...state.messages, response.message],
      );
    } catch (e) {
      state = state.copyWith(isSending: false, error: e.toString());
    }
  }
}

final aiCopilotProvider =
    StateNotifierProvider<AiCopilotNotifier, AiCopilotState>((ref) {
      return AiCopilotNotifier(ref.watch(aiCopilotRepositoryProvider));
    });
