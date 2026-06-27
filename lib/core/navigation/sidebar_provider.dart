import 'package:flutter_riverpod/flutter_riverpod.dart';

class SidebarNotifier extends StateNotifier<bool> {
  SidebarNotifier() : super(false);

  void toggle() {
    state = !state;
  }

  void expand() {
    state = true;
  }

  void collapse() {
    state = false;
  }
}

final sidebarProvider = StateNotifierProvider<SidebarNotifier, bool>((ref) {
  return SidebarNotifier();
});

