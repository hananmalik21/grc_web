import 'package:flutter_riverpod/flutter_riverpod.dart';

final deleteCandidateLoadingProvider = StateProvider.autoDispose.family<bool, String>((ref, candidateGuid) => false);
