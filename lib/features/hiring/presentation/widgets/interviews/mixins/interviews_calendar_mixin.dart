import 'package:flutter_riverpod/flutter_riverpod.dart';

mixin InterviewsCalendarMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  late DateTime focusedMonth;
  late DateTime selectedDay;

  void initCalendarState() {
    final now = DateTime.now();
    focusedMonth = DateTime(now.year, now.month, 1);
    selectedDay = DateTime(now.year, now.month, now.day);
  }

  List<DateTime> generateCalendarDays() {
    final firstDayOfMonth = DateTime(focusedMonth.year, focusedMonth.month, 1);
    final daysBefore = firstDayOfMonth.weekday % 7;
    final startDate = firstDayOfMonth.subtract(Duration(days: daysBefore));
    return List.generate(42, (index) => startDate.add(Duration(days: index)));
  }

  void onPrevMonthPressed() {
    setState(() {
      focusedMonth = DateTime(focusedMonth.year, focusedMonth.month - 1, 1);
    });
  }

  void onNextMonthPressed() {
    setState(() {
      focusedMonth = DateTime(focusedMonth.year, focusedMonth.month + 1, 1);
    });
  }

  void onTodayPressed() {
    final now = DateTime.now();
    setState(() {
      focusedMonth = DateTime(now.year, now.month, 1);
      selectedDay = DateTime(now.year, now.month, now.day);
    });
  }

  void onSelectDay(DateTime day) {
    setState(() {
      selectedDay = day;
    });
  }
}
