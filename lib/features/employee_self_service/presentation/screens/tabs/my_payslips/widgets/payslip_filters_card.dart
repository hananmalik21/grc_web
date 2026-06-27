import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/widgets/forms/digify_select_field.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/employee_self_service/presentation/widgets/ess_surface_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class PayslipFiltersCard extends StatefulWidget {
  final String searchQuery;
  final int selectedYear;
  final List<int> availableYears;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<int> onYearSelected;

  const PayslipFiltersCard({
    super.key,
    required this.searchQuery,
    required this.selectedYear,
    required this.availableYears,
    required this.onSearchChanged,
    required this.onYearSelected,
  });

  @override
  State<PayslipFiltersCard> createState() => _PayslipFiltersCardState();
}

class _PayslipFiltersCardState extends State<PayslipFiltersCard> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.searchQuery);
  }

  @override
  void didUpdateWidget(covariant PayslipFiltersCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchQuery != widget.searchQuery && _controller.text != widget.searchQuery) {
      _controller.text = widget.searchQuery;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EssSurfaceCard(
      padding: EdgeInsets.all(14.5.w),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isStacked = constraints.maxWidth < 760;
          final searchField = Expanded(
            child: DigifyTextField.search(
              controller: _controller,
              hintText: 'Search by month or period...',
              onChanged: widget.onSearchChanged,
              borderColor: AppColors.inputBorder,
            ),
          );
          final yearSelector = _YearSelector(
            selectedYear: widget.selectedYear,
            availableYears: widget.availableYears,
            onSelected: widget.onYearSelected,
          );

          if (isStacked) {
            return Column(
              children: [
                Row(
                  children: [
                    searchField,
                  ],
                ),
                Gap(12.h),
                Align(alignment: Alignment.centerRight, child: yearSelector),
              ],
            );
          }

          return Row(
            children: [
              searchField,
              Gap(12.w),
              yearSelector,
            ],
          );
        },
      ),
    );
  }
}

class _YearSelector extends StatelessWidget {
  final int selectedYear;
  final List<int> availableYears;
  final ValueChanged<int> onSelected;

  const _YearSelector({
    required this.selectedYear,
    required this.availableYears,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 132.w,
      child: DigifySelectField<int>(
        value: selectedYear,
        items: availableYears,
        itemLabelBuilder: (year) => year.toString(),
        onChanged: (year) {
          if (year != null) onSelected(year);
        },
        fillColor: Colors.transparent,
      ),
    );
  }
}
