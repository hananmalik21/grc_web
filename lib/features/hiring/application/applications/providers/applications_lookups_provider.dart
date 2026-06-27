import 'package:flutter_riverpod/flutter_riverpod.dart';

final applicationStatusLookupProvider = Provider<List<String>>((ref) {
  return ['New', 'Screening', 'Interview', 'Offer', 'Hired', 'Rejected', 'Withdrawn'];
});

final applicationSourceLookupProvider = Provider<List<String>>((ref) {
  return ['Career Site', 'LinkedIn', 'Referral', 'Indeed', 'Direct', 'Agency'];
});
