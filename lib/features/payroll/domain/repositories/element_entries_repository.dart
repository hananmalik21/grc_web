import 'package:grc/features/payroll/data/dto/create_element_entry_request_dto.dart';

abstract class ElementEntriesRepository {
  Future<void> createElementEntry(CreateElementEntryRequestDto request);
}
