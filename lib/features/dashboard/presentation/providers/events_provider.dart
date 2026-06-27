import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/dashboard_event.dart';

class EventsNotifier extends Notifier<List<DashboardEvent>> {
  @override
  List<DashboardEvent> build() {
    return [
      DashboardEvent(
        id: '1',
        title: 'Team Meeting',
        time: '10:00 AM - 11:00 AM',
        month: 'DEC',
        day: '15',
        category: EventCategory.meeting,
      ),
      DashboardEvent(
        id: '2',
        title: 'Payroll Processing',
        time: 'All Day',
        month: 'DEC',
        day: '20',
        category: EventCategory.payroll,
      ),
    ];
  }
}

final eventsProvider = NotifierProvider<EventsNotifier, List<DashboardEvent>>(EventsNotifier.new);
