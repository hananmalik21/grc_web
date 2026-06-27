import 'package:flutter_screenutil/flutter_screenutil.dart';

class PersonResultTaskDetailMessagesColumnWidths {
  const PersonResultTaskDetailMessagesColumnWidths({this.multiplier = 1.0});

  final double multiplier;

  double get messageText => 480.w * multiplier;
  double get status => 140.w * multiplier;
  double get taskName => 160.w * multiplier;
  double get details => 100.w * multiplier;

  double get total => messageText + status + taskName + details;

  static double get horizontalPadding => 40.w;

  double get totalWithPadding => total + horizontalPadding;

  static const PersonResultTaskDetailMessagesColumnWidths base = PersonResultTaskDetailMessagesColumnWidths();
}
