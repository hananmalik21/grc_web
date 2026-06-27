import 'package:grc/core/enums/time_management_enums.dart';
import 'package:grc/features/time_management/domain/models/public_holiday.dart';
import 'package:grc/features/time_management/domain/models/public_holidays_stats.dart';
import 'package:grc/features/time_management/presentation/widgets/public_holidays/components/holiday_card.dart';
import 'package:grc/features/time_management/presentation/widgets/public_holidays/components/monthly_holiday_group.dart';
import 'package:intl/intl.dart';

class PublicHolidayMapper {
  PublicHolidayMapper._();

  static HolidayCardData toCardData(PublicHoliday holiday) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final monthFormat = DateFormat('MMM');
    return HolidayCardData(
      id: holiday.id.toString(),
      day: holiday.date.day,
      month: monthFormat.format(holiday.date),
      nameEn: holiday.nameEn,
      nameAr: holiday.nameAr,
      descriptionEn: holiday.descriptionEn,
      descriptionAr: holiday.descriptionAr,
      type: holiday.type,
      paymentStatus: holiday.paymentStatus,
      date: dateFormat.format(holiday.date),
      appliesTo: holiday.appliesTo,
    );
  }

  static List<MonthlyHolidayGroupData> groupByMonth(List<PublicHoliday> holidays) {
    final Map<String, List<HolidayCardData>> grouped = {};

    for (final holiday in holidays) {
      final monthYear = DateFormat('MMMM yyyy').format(holiday.date);
      final cardData = toCardData(holiday);

      if (grouped.containsKey(monthYear)) {
        grouped[monthYear]!.add(cardData);
      } else {
        grouped[monthYear] = [cardData];
      }
    }

    final sortedKeys = grouped.keys.toList()
      ..sort((a, b) {
        try {
          final dateA = DateFormat('MMMM yyyy').parse(a);
          final dateB = DateFormat('MMMM yyyy').parse(b);
          return dateB.compareTo(dateA);
        } catch (e) {
          return b.compareTo(a);
        }
      });

    return sortedKeys.map((key) {
      final holidays = grouped[key]!;
      holidays.sort((a, b) => a.day.compareTo(b.day));
      return MonthlyHolidayGroupData(monthYear: key, holidays: holidays);
    }).toList();
  }

  static PublicHolidaysStats calculateStats(List<PublicHoliday> holidays) {
    int fixedCount = 0;
    int islamicCount = 0;
    int paidCount = 0;

    for (final holiday in holidays) {
      if (holiday.type == HolidayType.fixed) {
        fixedCount++;
      } else if (holiday.type == HolidayType.islamic) {
        islamicCount++;
      }
      if (holiday.paymentStatus == HolidayPaymentStatus.paid) {
        paidCount++;
      }
    }

    return PublicHolidaysStats(
      totalHolidays: holidays.length,
      fixedHolidays: fixedCount,
      islamicHolidays: islamicCount,
      paidHolidays: paidCount,
    );
  }
}
