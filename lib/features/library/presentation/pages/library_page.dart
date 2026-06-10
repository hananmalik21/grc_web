import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grc_web/core/errors/failure.dart';
import 'package:grc_web/core/localization/app_localizations_ext.dart';
import 'package:grc_web/core/theme/app_colors.dart';
import 'package:grc_web/core/services/responsive_service.dart';
import 'package:grc_web/core/widgets/app_button.dart';
import 'package:grc_web/core/widgets/app_error_view.dart';
import 'package:grc_web/core/widgets/app_horizontal_scroll_row.dart';
import 'package:grc_web/core/widgets/app_loading_indicator.dart';
import 'package:grc_web/core/widgets/app_select_field.dart';
import 'package:grc_web/core/widgets/app_text_field.dart';
import 'package:grc_web/core/widgets/app_text_metrics.dart';
import 'package:grc_web/features/library/application/providers/library_providers.dart';
import 'package:grc_web/features/library/domain/entities/library_entities.dart';
import 'package:grc_web/features/library/presentation/widgets/edit_question_dialog.dart';
import 'package:grc_web/features/library/presentation/widgets/manage_categories_dialog.dart';

class LibraryPage extends ConsumerWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final dataAsync = ref.watch(libraryProvider);

    return dataAsync.when(
      loading: () => const Center(child: AppLoadingIndicator()),
      error: (error, stackTrace) => Center(
        child: AppErrorView(
          message: error is Failure ? error.message : l10n.errorGeneric,
          onRetry: () => ref.invalidate(libraryProvider),
        ),
      ),
      data: (data) => _LibraryView(data: data),
    );
  }
}

class _LibraryView extends StatelessWidget {
  const _LibraryView({required this.data});

  final LibraryData data;

  static const _textHeight = AppTextMetrics.textHeight;

  @override
  Widget build(BuildContext context) {
    final layout = context.screenLayout;
    final compact = layout.isCompact;
    final isTabletSmall = layout.isTabletSmall;
    final sectionGap = compact
        ? (isTabletSmall
              ? 20.h
              : ResponsiveHelper.getTabSectionSpacing(context))
        : 24.h;
    final blockGap = layout.isMobile ? 20.h : sectionGap;

    return SingleChildScrollView(
      padding: compact
          ? ResponsiveHelper.getDetailScreenPadding(context)
          : EdgeInsets.all(24.w),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: compact ? context.responsiveMaxContentWidth : 1512.w,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _LibraryTitleBar(data: data),
            SizedBox(height: blockGap),
            _FrameworkSelector(data: data),
            SizedBox(height: blockGap),
            _LibraryStatsRow(data: data),
            SizedBox(height: blockGap),
            const _SearchAndCategoryRow(),
            SizedBox(height: blockGap),
            _SectionsList(sections: data.sections),
            SizedBox(height: blockGap),
            const _EditModeBanner(),
          ],
        ),
      ),
    );
  }
}

class _LibraryTitleBar extends ConsumerWidget {
  const _LibraryTitleBar({required this.data});
  final LibraryData data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;
    final layout = context.screenLayout;
    final compact = layout.isCompact;
    final isMobile = layout.isMobile;

    final isTabletSmall = layout.isTabletSmall;

    final actionItems =
        <
          ({
            String label,
            String iconAsset,
            AppButtonVariant variant,
            VoidCallback onPressed,
          })
        >[
          (
            label: l10n.manageCategories,
            iconAsset: 'assets/figma/library/svg/manage_categories.svg',
            variant: AppButtonVariant.primary,
            onPressed: () =>
                showManageCategoriesDialog(context: context, data: data),
          ),
          (
            label: l10n.exitEditMode,
            iconAsset: 'assets/figma/library/svg/exit_edit_mode.svg',
            variant: AppButtonVariant.secondary,
            onPressed: () {},
          ),
          (
            label: l10n.exportLibrary,
            iconAsset: 'assets/figma/library/svg/export_library.svg',
            variant: AppButtonVariant.outlined,
            onPressed: () {},
          ),
        ];

    if (compact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40.r,
                height: 40.r,
                decoration: BoxDecoration(
                  color: AppColors.primaryTint,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/figma/dashboard/svg/library_icon.svg',
                    width: 20.r,
                    height: 20.r,
                    colorFilter: const ColorFilter.mode(
                      AppColors.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.libraryTitle,
                      style: textTheme.displaySmall?.copyWith(fontSize: 20.sp),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      strutStyle: const StrutStyle(
                        fontSize: 24,
                        height: 32 / 24,
                        forceStrutHeight: true,
                      ),
                      textHeightBehavior: _LibraryView._textHeight,
                    ),
                    Text(
                      l10n.librarySubtitle,
                      style: textTheme.bodyMedium?.copyWith(fontSize: 13.sp),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      strutStyle: const StrutStyle(
                        fontSize: 14,
                        height: 20 / 14,
                        forceStrutHeight: true,
                      ),
                      textHeightBehavior: _LibraryView._textHeight,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          if (isMobile)
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (int i = 0; i < actionItems.length; i++) ...[
                  AppButton(
                    label: actionItems[i].label,
                    iconAsset: actionItems[i].iconAsset,
                    variant: actionItems[i].variant,
                    size: AppButtonSize.md,
                    fullWidth: true,
                    onPressed: actionItems[i].onPressed,
                  ),
                  if (i != actionItems.length - 1) SizedBox(height: 12.h),
                ],
              ],
            )
          else if (isTabletSmall)
            Wrap(
              spacing: 10.w,
              runSpacing: 10.h,
              children: [
                for (final item in actionItems)
                  AppButton(
                    label: item.label,
                    iconAsset: item.iconAsset,
                    variant: item.variant,
                    size: AppButtonSize.md,
                    onPressed: item.onPressed,
                  ),
              ],
            )
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  for (int i = 0; i < actionItems.length; i++) ...[
                    AppButton(
                      label: actionItems[i].label,
                      iconAsset: actionItems[i].iconAsset,
                      variant: actionItems[i].variant,
                      size: AppButtonSize.md,
                      onPressed: actionItems[i].onPressed,
                    ),
                    if (i != actionItems.length - 1) SizedBox(width: 8.w),
                  ],
                ],
              ),
            ),
        ],
      );
    }

    final actions = [
      for (final item in actionItems)
        AppButton(
          label: item.label,
          iconAsset: item.iconAsset,
          variant: item.variant,
          onPressed: item.onPressed,
        ),
    ];

    return Row(
      children: [
        Container(
          width: 48.r,
          height: 48.r,
          decoration: BoxDecoration(
            color: AppColors.primaryTint,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Center(
            child: SvgPicture.asset(
              'assets/figma/dashboard/svg/library_icon.svg',
              width: 24.r,
              height: 24.r,
              colorFilter: const ColorFilter.mode(
                AppColors.primary,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.libraryTitle,
                style: textTheme.displaySmall,
                strutStyle: const StrutStyle(
                  fontSize: 24,
                  height: 32 / 24,
                  forceStrutHeight: true,
                ),
                textHeightBehavior: _LibraryView._textHeight,
              ),
              Text(
                l10n.librarySubtitle,
                style: textTheme.bodyMedium,
                strutStyle: const StrutStyle(
                  fontSize: 14,
                  height: 20 / 14,
                  forceStrutHeight: true,
                ),
                textHeightBehavior: _LibraryView._textHeight,
              ),
            ],
          ),
        ),
        Row(
          children: [
            actions[0],
            SizedBox(width: 12.w),
            actions[1],
            SizedBox(width: 12.w),
            actions[2],
          ],
        ),
      ],
    );
  }
}

class _FrameworkSelector extends StatelessWidget {
  const _FrameworkSelector({required this.data});
  final LibraryData data;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final layout = context.screenLayout;
    final compact = layout.isCompact;

    return Container(
      padding: ResponsiveHelper.libraryCardPadding(context),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.border),
      ),
      child: AppSelectField<String>(
        label: l10n.selectFramework,
        labelSpacing: ResponsiveHelper.fieldLabelSpacing(context),
        value: data.selectedFrameworkId,
        items: data.frameworks.map((f) => f.id).toList(),
        itemLabel: (id) {
          final framework = data.frameworks.firstWhere((f) => f.id == id);
          if (compact) {
            return '${framework.title} (${framework.questionCount})';
          }
          return '${framework.title} - ${framework.questionCount} ${l10n.questionsLower}';
        },
        onChanged: (_) {},
      ),
    );
  }
}

class _LibraryStatsRow extends StatefulWidget {
  const _LibraryStatsRow({required this.data});
  final LibraryData data;

  @override
  State<_LibraryStatsRow> createState() => _LibraryStatsRowState();
}

class _LibraryStatsRowState extends State<_LibraryStatsRow> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final compact = context.screenLayout.isCompact;

    final items = <({String value, String label})>[
      (value: '${widget.data.totalQuestions}', label: l10n.totalQuestions),
      (value: '${widget.data.categories}', label: l10n.categories),
      (value: '${widget.data.requireEvidence}', label: l10n.requireEvidence),
      (value: widget.data.version, label: l10n.libraryVersion),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final useScroll =
            compact || ResponsiveHelper.isNarrowWidth(constraints.maxWidth);

        if (useScroll) {
          final isMobile = context.screenLayout.isMobile;
          final spacing = context
              .responsive(mobile: 12.0, tablet: 14.0, desktop: 16.0)
              .w;
          final cardWidth = isMobile
              ? (constraints.maxWidth * 0.88).clamp(
                  260.0,
                  constraints.maxWidth - 48,
                )
              : (constraints.maxWidth * 0.85).clamp(220.0, 320.0);

          return AppHorizontalScrollRow(
            controller: _scrollController,
            spacing: spacing,
            children: [
              for (int i = 0; i < items.length; i++)
                SizedBox(
                  width: cardWidth,
                  child: _LibraryStatCard(
                    value: items[i].value,
                    label: items[i].label,
                  ),
                ),
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (int i = 0; i < items.length; i++) ...[
              Expanded(
                child: _LibraryStatCard(
                  value: items[i].value,
                  label: items[i].label,
                ),
              ),
              if (i != items.length - 1) SizedBox(width: 16.w),
            ],
          ],
        );
      },
    );
  }
}

class _LibraryStatCard extends StatelessWidget {
  const _LibraryStatCard({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final compact = context.screenLayout.isCompact;
    final isTabletSmall = context.screenLayout.isTabletSmall;
    final padding = isTabletSmall ? 14.w : (compact ? 12.w : 17.w);
    final valueFontSize = isTabletSmall ? 22.sp : (compact ? 20.sp : 24.sp);
    final labelFontSize = isTabletSmall ? 13.sp : (compact ? 12.sp : 14.sp);

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: textTheme.headlineSmall?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: valueFontSize,
              height: 32 / 24,
              letterSpacing: 0.072,
            ),
            strutStyle: AppTextMetrics.strut(
              fontSize: valueFontSize,
              lineHeight: 32,
            ),
            textHeightBehavior: AppTextMetrics.textHeight,
          ),
          SizedBox(height: compact ? 6.h : 4.h),
          Text(
            label,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.textBody,
              fontWeight: FontWeight.w400,
              fontSize: labelFontSize,
              height: 20 / 14,
              letterSpacing: -0.154,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            strutStyle: AppTextMetrics.strut(
              fontSize: labelFontSize,
              lineHeight: 20,
            ),
            textHeightBehavior: AppTextMetrics.textHeight,
          ),
        ],
      ),
    );
  }
}

class _SearchAndCategoryRow extends StatefulWidget {
  const _SearchAndCategoryRow();

  @override
  State<_SearchAndCategoryRow> createState() => _SearchAndCategoryRowState();
}

class _SearchAndCategoryRowState extends State<_SearchAndCategoryRow> {
  late final TextEditingController _searchController;
  String _selectedCategory = 'all';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildCategoryField() {
    final l10n = context.l10n;
    return AppSelectField<String>(
      value: _selectedCategory,
      items: const ['all'],
      itemLabel: (value) => value == 'all' ? l10n.allCategories : value,
      onChanged: (value) {
        if (value != null) setState(() => _selectedCategory = value);
      },
      prefixIcon: AppSelectField.prefixIconAsset(
        context,
        'assets/figma/library/svg/filter.svg',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final layout = context.screenLayout;
    final isMobile = layout.isMobile;

    return Container(
      padding: ResponsiveHelper.libraryCardPadding(context),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.border),
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppTextField.search(
                  controller: _searchController,
                  hint: l10n.searchQuestionsPlaceholder,
                ),
                SizedBox(height: 16.h),
                _buildCategoryField(),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: AppTextField.search(
                    controller: _searchController,
                    hint: l10n.searchQuestionsPlaceholder,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(child: _buildCategoryField()),
              ],
            ),
    );
  }
}

class _SectionsList extends StatelessWidget {
  const _SectionsList({required this.sections});

  final List<LibrarySection> sections;

  @override
  Widget build(BuildContext context) {
    final compact = context.screenLayout.isCompact;
    final gap = compact ? ResponsiveHelper.getTabSectionSpacing(context) : 24.h;

    return Column(
      children: [
        for (int i = 0; i < sections.length; i++) ...[
          _SectionCard(section: sections[i]),
          if (i != sections.length - 1) SizedBox(height: gap),
        ],
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.section});

  final LibrarySection section;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.none,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.sectionBorder),
      ),
      child: Column(
        children: [
          _SectionHeader(section: section),
          for (final q in section.questions) _QuestionRow(question: q),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.section});
  final LibrarySection section;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;
    final layout = context.screenLayout;
    final compact = layout.isCompact;
    final isMobile = layout.isMobile;
    final padding = isMobile
        ? EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 18.h)
        : compact
        ? EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 17.h)
        : EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 25.h);

    return Container(
      padding: padding,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.sectionBorder)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final stackHeader =
              compact || ResponsiveHelper.isNarrowWidth(constraints.maxWidth);

          if (stackHeader) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  section.title,
                  style: textTheme.titleMedium?.copyWith(
                    fontSize: compact ? 16.sp : null,
                  ),
                  strutStyle: const StrutStyle(
                    fontSize: 18,
                    height: 28 / 18,
                    forceStrutHeight: true,
                  ),
                  textHeightBehavior: _LibraryView._textHeight,
                ),
                SizedBox(height: 4.h),
                Text(
                  section.subtitle,
                  style: textTheme.bodyMedium?.copyWith(
                    fontSize: compact ? 13.sp : null,
                  ),
                  strutStyle: const StrutStyle(
                    fontSize: 14,
                    height: 20 / 14,
                    forceStrutHeight: true,
                  ),
                  textHeightBehavior: _LibraryView._textHeight,
                ),
                SizedBox(height: isMobile ? 14.h : 12.h),
                AppButton(
                  label: l10n.addQuestion,
                  iconAsset: 'assets/figma/library/svg/add_question.svg',
                  variant: AppButtonVariant.primary,
                  size: isMobile ? AppButtonSize.sm : AppButtonSize.md,
                  iconColor: Colors.white,
                  fullWidth: true,
                  onPressed: () =>
                      showAddQuestionDialog(context: context, section: section),
                ),
                SizedBox(height: isMobile ? 12.h : 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${section.questionCount} ${l10n.questionsLower}',
                      style: textTheme.bodyLarge?.copyWith(
                        fontSize: compact ? 13.sp : null,
                      ),
                      strutStyle: const StrutStyle(
                        fontSize: 14,
                        height: 20 / 14,
                        forceStrutHeight: true,
                      ),
                      textHeightBehavior: _LibraryView._textHeight,
                    ),
                    Text(
                      'Weight: ${section.weightPercent}%',
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w400,
                        fontSize: compact ? 11.sp : null,
                      ),
                      strutStyle: const StrutStyle(
                        fontSize: 12,
                        height: 16 / 12,
                        forceStrutHeight: true,
                      ),
                      textHeightBehavior: _LibraryView._textHeight,
                    ),
                  ],
                ),
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      section.title,
                      style: textTheme.titleMedium,
                      strutStyle: const StrutStyle(
                        fontSize: 18,
                        height: 28 / 18,
                        forceStrutHeight: true,
                      ),
                      textHeightBehavior: _LibraryView._textHeight,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      section.subtitle,
                      style: textTheme.bodyMedium,
                      strutStyle: const StrutStyle(
                        fontSize: 14,
                        height: 20 / 14,
                        forceStrutHeight: true,
                      ),
                      textHeightBehavior: _LibraryView._textHeight,
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: AppButton(
                        label: l10n.addQuestion,
                        iconAsset: 'assets/figma/library/svg/add_question.svg',
                        variant: AppButtonVariant.primary,
                        size: AppButtonSize.md,
                        iconColor: Colors.white,
                        onPressed: () => showAddQuestionDialog(
                          context: context,
                          section: section,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${section.questionCount} ${l10n.questionsLower}',
                          style: textTheme.bodyLarge,
                          strutStyle: const StrutStyle(
                            fontSize: 14,
                            height: 20 / 14,
                            forceStrutHeight: true,
                          ),
                          textHeightBehavior: _LibraryView._textHeight,
                        ),
                        Text(
                          'Weight: ${section.weightPercent}%',
                          style: textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w400,
                          ),
                          strutStyle: const StrutStyle(
                            fontSize: 12,
                            height: 16 / 12,
                            forceStrutHeight: true,
                          ),
                          textHeightBehavior: _LibraryView._textHeight,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _QuestionRow extends StatelessWidget {
  const _QuestionRow({required this.question});
  final LibraryQuestion question;

  Widget _actionButton({
    required String asset,
    required Color borderColor,
    required VoidCallback onTap,
    double padding = 10,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: AppColors.primaryLightBg,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(10),
        ),
        child: SvgPicture.asset(asset),
      ),
    );
  }

  Widget _weightBadge(TextTheme textTheme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.primaryTint,
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Text(
        'Weight: ${question.weight}',
        style: textTheme.bodySmall?.copyWith(
          color: AppColors.weightBadgeFg,
          fontWeight: FontWeight.w500,
        ),
        strutStyle: const StrutStyle(
          fontSize: 12,
          height: 16 / 12,
          forceStrutHeight: true,
        ),
        textHeightBehavior: _LibraryView._textHeight,
      ),
    );
  }

  Widget _questionHeader(
    BuildContext context,
    TextTheme textTheme, {
    required bool compact,
  }) {
    final isMobile = context.screenLayout.isMobile;
    final maxChipWidth = MediaQuery.sizeOf(context).width - 64;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8.w,
          runSpacing: 4.h,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              question.code,
              style: textTheme.bodySmall?.copyWith(
                fontFamily: 'Menlo',
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w400,
              ),
              strutStyle: const StrutStyle(
                fontSize: 12,
                height: 16 / 12,
                forceStrutHeight: true,
              ),
              textHeightBehavior: _LibraryView._textHeight,
            ),
            if (question.requiresEvidence)
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: compact ? maxChipWidth : 280,
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: AppColors.statusHighBg,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        'assets/figma/library/svg/evidence.svg',
                        width: 16.r,
                        height: 16.r,
                        colorFilter: const ColorFilter.mode(
                          AppColors.statusHighFg,
                          BlendMode.srcIn,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Flexible(
                        child: Text(
                          context.l10n.evidenceRequired,
                          style: textTheme.bodySmall?.copyWith(
                            color: AppColors.statusHighFg,
                            fontWeight: FontWeight.w400,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          strutStyle: const StrutStyle(
                            fontSize: 12,
                            height: 16 / 12,
                            forceStrutHeight: true,
                          ),
                          textHeightBehavior: _LibraryView._textHeight,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: isMobile ? 8.h : 6.h),
        Text(
          question.title,
          style: textTheme.titleSmall?.copyWith(
            fontSize: compact ? 15.sp : 16.sp,
          ),
          strutStyle: const StrutStyle(
            fontSize: 16,
            height: 24 / 16,
            forceStrutHeight: true,
          ),
          textHeightBehavior: _LibraryView._textHeight,
        ),
        if (question.description.isNotEmpty) ...[
          SizedBox(height: isMobile ? 6.h : 4.h),
          Text(
            question.description,
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w400,
              fontSize: compact ? 13.sp : 14.sp,
            ),
            strutStyle: const StrutStyle(
              fontSize: 14,
              height: 20 / 14,
              forceStrutHeight: true,
            ),
            textHeightBehavior: _LibraryView._textHeight,
          ),
        ],
        if (compact) ...[
          SizedBox(height: isMobile ? 10.h : 8.h),
          _weightBadge(textTheme),
        ],
      ],
    );
  }

  Widget _questionDetails(
    BuildContext context,
    TextTheme textTheme, {
    required bool compact,
  }) {
    final isMobile = context.screenLayout.isMobile;
    final maxChipWidth = MediaQuery.sizeOf(context).width - 64;
    final chipRunSpacing = isMobile ? 8.h : 4.h;
    final sectionSpacing = isMobile ? 18.h : 16.h;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: 8.w,
          runSpacing: chipRunSpacing,
          children: [
            _Chip(
              bg: AppColors.chipNeutralBg,
              fg: AppColors.textLabel,
              text: question.typeChip,
              maxWidth: compact ? maxChipWidth : null,
            ),
            for (final c in question.categoryChips)
              _Chip(
                bg: AppColors.primaryLightBg,
                fg: AppColors.primary,
                text: c,
                maxWidth: compact ? maxChipWidth : null,
              ),
          ],
        ),
        if (question.tags.isNotEmpty) ...[
          SizedBox(height: isMobile ? 12.h : 8.h),
          Wrap(
            spacing: 6.w,
            runSpacing: chipRunSpacing,
            children: [
              for (final t in question.tags)
                _Chip(
                  bg: AppColors.chipTagBg,
                  fg: AppColors.textBody,
                  text: t,
                  dense: true,
                ),
            ],
          ),
        ],
        if (question.evaluationCriteria.isNotEmpty) ...[
          SizedBox(height: sectionSpacing),
          Text(
            context.l10n.evaluationCriteria,
            style: textTheme.bodySmall?.copyWith(
              color: AppColors.textLabel,
              fontWeight: FontWeight.w500,
            ),
            strutStyle: const StrutStyle(
              fontSize: 12,
              height: 16 / 12,
              forceStrutHeight: true,
            ),
            textHeightBehavior: _LibraryView._textHeight,
          ),
          SizedBox(height: isMobile ? 10.h : 8.h),
          AppHorizontalScrollRow(
            spacing: 10,
            children: [
              for (final c in question.evaluationCriteria)
                _CriterionChip(c: c, compact: compact),
            ],
          ),
        ],
        if (question.relatedControls.isNotEmpty) ...[
          SizedBox(height: isMobile ? 16.h : 12.h),
          Text(
            context.l10n.relatedControls,
            style: textTheme.bodySmall?.copyWith(
              color: AppColors.textLabel,
              fontWeight: FontWeight.w500,
            ),
            strutStyle: const StrutStyle(
              fontSize: 12,
              height: 16 / 12,
              forceStrutHeight: true,
            ),
            textHeightBehavior: _LibraryView._textHeight,
          ),
          SizedBox(height: isMobile ? 10.h : 6.h),
          Wrap(
            spacing: 6.w,
            runSpacing: chipRunSpacing,
            children: [
              for (final rc in question.relatedControls)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: AppColors.relatedControlBg,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    rc,
                    style: textTheme.bodySmall?.copyWith(
                      fontFamily: 'Menlo',
                      color: AppColors.primary,
                      fontWeight: FontWeight.w400,
                    ),
                    strutStyle: const StrutStyle(
                      fontSize: 12,
                      height: 16 / 12,
                      forceStrutHeight: true,
                    ),
                    textHeightBehavior: _LibraryView._textHeight,
                  ),
                ),
            ],
          ),
        ],
        SizedBox(height: isMobile ? 16.h : 12.h),
        AppButton(
          label: context.l10n.showGuidance,
          variant: AppButtonVariant.ghost,
          size: AppButtonSize.sm,
          onPressed: () {},
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final compact = context.screenLayout.isCompact;
    final isMobile = context.screenLayout.isMobile;
    final padding = isMobile
        ? EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 18.h)
        : compact
        ? EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 17.h)
        : EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 25.h);

    return Container(
      clipBehavior: Clip.none,
      padding: padding,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.sectionBorder)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final useCompactLayout =
              compact || ResponsiveHelper.isNarrowWidth(constraints.maxWidth);

          if (useCompactLayout && isMobile) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _questionHeader(context, textTheme, compact: true),
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _actionButton(
                      asset: 'assets/figma/library/svg/edit_question.svg',
                      borderColor: AppColors.editBorderBlue,
                      onTap: () => showEditQuestionDialog(
                        context: context,
                        question: question,
                      ),
                      padding: 10,
                    ),
                    SizedBox(width: 10.w),
                    _actionButton(
                      asset: 'assets/figma/library/svg/delete_question.svg',
                      borderColor: AppColors.deleteBorderRed,
                      onTap: () => showEditQuestionDialog(
                        context: context,
                        question: question,
                      ),
                      padding: 10,
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                _questionDetails(context, textTheme, compact: true),
              ],
            );
          }

          if (useCompactLayout) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _questionHeader(context, textTheme, compact: true),
                    ),
                    SizedBox(width: 12.w),
                    Row(
                      children: [
                        _actionButton(
                          asset: 'assets/figma/library/svg/edit_question.svg',
                          borderColor: AppColors.editBorderBlue,
                          onTap: () => showEditQuestionDialog(
                            context: context,
                            question: question,
                          ),
                          padding: 8,
                        ),
                        SizedBox(width: 10.w),
                        _actionButton(
                          asset: 'assets/figma/library/svg/delete_question.svg',
                          borderColor: AppColors.deleteBorderRed,
                          onTap: () => showEditQuestionDialog(
                            context: context,
                            question: question,
                          ),
                          padding: 8,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                _questionDetails(context, textTheme, compact: true),
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  _actionButton(
                    asset: 'assets/figma/library/svg/edit_question.svg',
                    borderColor: AppColors.editBorderBlue,
                    onTap: () => showEditQuestionDialog(
                      context: context,
                      question: question,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  _actionButton(
                    asset: 'assets/figma/library/svg/delete_question.svg',
                    borderColor: AppColors.deleteBorderRed,
                    onTap: () => showEditQuestionDialog(
                      context: context,
                      question: question,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _questionHeader(
                            context,
                            textTheme,
                            compact: false,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        _weightBadge(textTheme),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    _questionDetails(context, textTheme, compact: false),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.bg,
    required this.fg,
    required this.text,
    this.dense = false,
    this.maxWidth,
  });

  final Color bg;
  final Color fg;
  final String text;
  final bool dense;
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final chip = Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8.w,
        vertical: dense ? 2.h : 4.h,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        text,
        style: textTheme.bodySmall?.copyWith(
          color: fg,
          fontWeight: FontWeight.w400,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        strutStyle: const StrutStyle(
          fontSize: 12,
          height: 16 / 12,
          forceStrutHeight: true,
        ),
        textHeightBehavior: _LibraryView._textHeight,
      ),
    );

    if (maxWidth == null) return chip;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth!),
      child: chip,
    );
  }
}

class _CriterionChip extends StatelessWidget {
  const _CriterionChip({required this.c, this.compact = false});

  final EvaluationCriterion c;
  final bool compact;

  Color get _textColor {
    if (c.title == 'Documentation') return AppColors.primaryDark;
    return AppColors.primary;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final color = _textColor;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 10.w : 12.w,
        vertical: compact ? 5.h : 6.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryLightBg,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            c.iconAsset,
            width: compact ? 14.r : 16.r,
            height: compact ? 14.r : 16.r,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          ),
          SizedBox(width: 6.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                c.title,
                style: textTheme.bodySmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w500,
                  fontSize: compact ? 11.sp : 12.sp,
                ),
                strutStyle: const StrutStyle(
                  fontSize: 12,
                  height: 16 / 12,
                  forceStrutHeight: true,
                ),
                textHeightBehavior: _LibraryView._textHeight,
              ),
              Opacity(
                opacity: 0.75,
                child: Text(
                  'Weight: ${c.weightPercent}%',
                  style: textTheme.bodySmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w400,
                    fontSize: compact ? 10.sp : 12.sp,
                  ),
                  strutStyle: const StrutStyle(
                    fontSize: 12,
                    height: 16 / 12,
                    forceStrutHeight: true,
                  ),
                  textHeightBehavior: _LibraryView._textHeight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EditModeBanner extends StatelessWidget {
  const _EditModeBanner();

  Widget _buildActionItem(
    BuildContext context,
    TextTheme textTheme, {
    required String icon,
    required String label,
    required double iconSize,
    required double fontSize,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 1.h),
          child: SvgPicture.asset(icon, width: iconSize, height: iconSize),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Text(
            label,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.textLabel,
              fontWeight: FontWeight.w400,
              letterSpacing: -0.154,
              fontSize: fontSize,
            ),
            strutStyle: StrutStyle(
              fontSize: fontSize,
              height: 20 / 14,
              forceStrutHeight: true,
            ),
            textHeightBehavior: _LibraryView._textHeight,
          ),
        ),
      ],
    );
  }

  Widget _buildActions(
    BuildContext context,
    TextTheme textTheme,
    List<({String icon, String label})> actions,
    double maxWidth,
  ) {
    final layout = context.screenLayout;
    final isMobile = layout.isMobile;
    final iconSize = isMobile ? 20.r : (layout.isCompact ? 22.r : 24.r);
    final fontSize = isMobile ? 13.sp : (layout.isCompact ? 13.sp : 14.sp);

    Widget item(({String icon, String label}) action) => _buildActionItem(
      context,
      textTheme,
      icon: action.icon,
      label: action.label,
      iconSize: iconSize,
      fontSize: fontSize,
    );

    if (isMobile || maxWidth < 640) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (int i = 0; i < actions.length; i++) ...[
            item(actions[i]),
            if (i != actions.length - 1) SizedBox(height: 12.h),
          ],
        ],
      );
    }

    if (maxWidth < ResponsiveHelper.narrowContentWidth) {
      final itemWidth = (maxWidth - 12.w) / 2;
      return Wrap(
        spacing: 12.w,
        runSpacing: 12.h,
        children: [
          for (final action in actions)
            SizedBox(width: itemWidth, child: item(action)),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < actions.length; i++) ...[
          Expanded(child: item(actions[i])),
          if (i < actions.length - 1) SizedBox(width: 16.w),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;
    final layout = context.screenLayout;
    final compact = layout.isCompact;
    final isMobile = layout.isMobile;

    final actions = <({String icon, String label})>[
      (
        icon: 'assets/figma/library/svg/action_manage_categories.svg',
        label: l10n.manageCategoriesAndWeights,
      ),
      (
        icon: 'assets/figma/library/svg/action_add_question.svg',
        label: l10n.addNewQuestionsToCategories,
      ),
      (
        icon: 'assets/figma/library/svg/action_edit_question.svg',
        label: l10n.editExistingQuestions,
      ),
      (
        icon: 'assets/figma/library/svg/action_delete_question.svg',
        label: l10n.deleteQuestions,
      ),
    ];

    final headerIconBox = isMobile ? 44.r : (compact ? 44.r : 52.r);
    final headerIconSize = isMobile ? 22.r : (compact ? 22.r : 28.r);

    return Container(
      padding: EdgeInsets.all(compact ? 16.w : 25.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryLightBg, AppColors.bannerGradientEnd],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.bannerBorder),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: headerIconBox,
                    height: headerIconBox,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/figma/library/svg/edit_mode_banner_icon.svg',
                        width: headerIconSize,
                        height: headerIconSize,
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: compact ? 12.w : 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.editModeActive,
                          style: textTheme.titleMedium?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.45,
                            fontSize: compact ? 16.sp : null,
                          ),
                          strutStyle: const StrutStyle(
                            fontSize: 18,
                            height: 28 / 18,
                            forceStrutHeight: true,
                          ),
                          textHeightBehavior: _LibraryView._textHeight,
                        ),
                        SizedBox(height: compact ? 6.h : 8.h),
                        Text(
                          l10n.editModeDescription,
                          style: textTheme.bodyMedium?.copyWith(
                            color: AppColors.textLabel,
                            fontWeight: FontWeight.w400,
                            letterSpacing: -0.154,
                            fontSize: compact ? 13.sp : 14.sp,
                          ),
                          strutStyle: const StrutStyle(
                            fontSize: 14,
                            height: 20 / 14,
                            forceStrutHeight: true,
                          ),
                          textHeightBehavior: _LibraryView._textHeight,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: compact ? 12.h : 16.h),
              _buildActions(context, textTheme, actions, constraints.maxWidth),
            ],
          );
        },
      ),
    );
  }
}
