import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/constants/app_gradients.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/common/digify_square_capsule.dart';
import 'package:grc/features/leave_management/domain/models/forfeit_policy.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ForfeitPoliciesList extends StatefulWidget {
  final List<ForfeitPolicy> forfeitPolicies;
  final ValueChanged<ForfeitPolicy>? onForfeitPolicySelected;
  final bool isDark;
  final ForfeitPolicy? selectedForfeitPolicy;

  const ForfeitPoliciesList({
    super.key,
    required this.forfeitPolicies,
    this.onForfeitPolicySelected,
    required this.isDark,
    this.selectedForfeitPolicy,
  });

  @override
  State<ForfeitPoliciesList> createState() => _ForfeitPoliciesListState();
}

class _ForfeitPoliciesListState extends State<ForfeitPoliciesList> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void didUpdateWidget(ForfeitPoliciesList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedForfeitPolicy != oldWidget.selectedForfeitPolicy && widget.selectedForfeitPolicy != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToSelectedItem();
      });
    }
  }

  void _scrollToSelectedItem() {
    if (widget.selectedForfeitPolicy == null) return;
    final index = widget.forfeitPolicies.indexWhere((fp) => fp.id == widget.selectedForfeitPolicy!.id);
    if (index != -1 && _scrollController.hasClients) {
      final itemHeight = 100.0;
      final separatorHeight = 1.0;
      final targetOffset = index * (itemHeight + separatorHeight);
      _scrollController.animateTo(
        targetOffset.clamp(0.0, _scrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: widget.isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              gradient: AppGradients.primaryHorizontal,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(10.r), topRight: Radius.circular(10.r)),
            ),
            child: Row(
              children: [
                Text(
                  'Forfeit Policies (${widget.forfeitPolicies.length})',
                  style: context.textTheme.headlineMedium?.copyWith(fontSize: 16.sp, color: AppColors.cardBackground),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              controller: _scrollController,
              itemCount: widget.forfeitPolicies.length,
              separatorBuilder: (context, index) => DigifyDivider.horizontal(),
              itemBuilder: (context, index) {
                final forfeitPolicy = widget.forfeitPolicies[index];
                final isSelected = widget.selectedForfeitPolicy?.id == forfeitPolicy.id;
                return _ForfeitPolicyItem(
                  forfeitPolicy: forfeitPolicy,
                  isDark: widget.isDark,
                  isSelected: isSelected,
                  onTap: () => widget.onForfeitPolicySelected?.call(forfeitPolicy),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ForfeitPolicyItem extends StatelessWidget {
  final ForfeitPolicy forfeitPolicy;
  final bool isDark;
  final bool isSelected;
  final VoidCallback? onTap;

  const _ForfeitPolicyItem({required this.forfeitPolicy, required this.isDark, required this.isSelected, this.onTap});

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isSelected ? AppColors.infoBg : Colors.transparent;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 20.h),
          decoration: BoxDecoration(
            color: backgroundColor,
            border: isSelected
                ? Border(
                    left: BorderSide(color: AppColors.primary, width: 4.w),
                  )
                : null,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 7.h,
                  children: [
                    Text(
                      forfeitPolicy.name,
                      style: context.textTheme.titleSmall?.copyWith(
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      forfeitPolicy.nameArabic,
                      style: context.textTheme.labelSmall?.copyWith(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.tableHeaderText,
                      ),
                    ),
                    if (forfeitPolicy.tags.isNotEmpty) ...[
                      Wrap(
                        spacing: 7.w,
                        runSpacing: 4.h,
                        children: forfeitPolicy.tags.map((tag) {
                          return DigifySquareCapsule(
                            label: tag,
                            backgroundColor: isSelected
                                ? AppColors.jobRoleBg
                                : (isDark ? AppColors.cardBackgroundGreyDark : AppColors.grayBg),
                            textColor: isSelected
                                ? AppColors.primary
                                : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondary),
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
              Gap(12.w),
              if (forfeitPolicy.isActive)
                DigifyAsset(
                  assetPath: Assets.icons.checkIconGreen.path,
                  width: 14.w,
                  height: 14.h,
                  color: AppColors.greenButton,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
