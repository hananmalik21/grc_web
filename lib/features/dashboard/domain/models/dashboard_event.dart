import 'package:flutter/material.dart';

enum EventCategory { meeting, payroll, holiday }

class DashboardEvent {
  final String id;
  final String title;
  final String time;
  final String month;
  final String day;
  final EventCategory category;
  final Color? bgColor;
  final Color? textColor;

  DashboardEvent({
    required this.id,
    required this.title,
    required this.time,
    required this.month,
    required this.day,
    required this.category,
    this.bgColor,
    this.textColor,
  });

  DashboardEvent copyWith({
    String? id,
    String? title,
    String? time,
    String? month,
    String? day,
    EventCategory? category,
    Color? bgColor,
    Color? textColor,
  }) {
    return DashboardEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      time: time ?? this.time,
      month: month ?? this.month,
      day: day ?? this.day,
      category: category ?? this.category,
      bgColor: bgColor ?? this.bgColor,
      textColor: textColor ?? this.textColor,
    );
  }
}
