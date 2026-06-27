import 'package:flutter_riverpod/flutter_riverpod.dart';

class FunctionManagementSearchNotifier extends StateNotifier<String> {
  FunctionManagementSearchNotifier() : super('');

  void updateQuery(String value) {
    state = value.trim();
  }
}

final functionManagementSearchQueryProvider =
    StateNotifierProvider.autoDispose<FunctionManagementSearchNotifier, String>(
      (ref) => FunctionManagementSearchNotifier(),
    );
