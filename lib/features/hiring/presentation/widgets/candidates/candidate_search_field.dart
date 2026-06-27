import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/debouncer.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/app_loading_indicator.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/hiring/presentation/models/candidate_data.dart';
import 'package:grc/features/hiring/presentation/providers/candidates/candidates_api_providers.dart';
import 'package:grc/features/hiring/presentation/providers/candidates/candidates_tab_enterprise_provider.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CandidateSearchField extends ConsumerStatefulWidget {
  final String label;
  final bool isRequired;
  final CandidateData? selectedCandidate;
  final ValueChanged<CandidateData> onCandidateSelected;
  final String? hintText;
  final Color? fillColor;

  const CandidateSearchField({
    super.key,
    required this.label,
    required this.onCandidateSelected,
    this.isRequired = false,
    this.selectedCandidate,
    this.hintText,
    this.fillColor,
  });

  @override
  ConsumerState<CandidateSearchField> createState() => _CandidateSearchFieldState();
}

class _CandidateSearchFieldState extends ConsumerState<CandidateSearchField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  final LayerLink _layerLink = LayerLink();
  final Debouncer _debouncer = Debouncer(delay: const Duration(milliseconds: 300));
  OverlayEntry? _overlayEntry;
  bool _showSuggestions = false;
  List<CandidateData> _suggestions = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.selectedCandidate?.name ?? '');
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(CandidateSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedCandidate != oldWidget.selectedCandidate) {
      _controller.text = widget.selectedCandidate?.name ?? '';
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _controller.dispose();
    _focusNode.dispose();
    _debouncer.dispose();
    _removeOverlay(updateState: false);
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      _performSearch(_controller.text);
      _showOverlay();
    } else {
      Future.delayed(const Duration(milliseconds: 200), () {
        if (!_focusNode.hasFocus) {
          _removeOverlay();
        }
      });
    }
  }

  void _handleSearch(String query) {
    _debouncer.run(() {
      _performSearch(query);
    });
  }

  Future<void> _performSearch(String query) async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final useCase = ref.read(getCandidatesUseCaseProvider);
      final enterpriseId = ref.read(candidatesTabEnterpriseIdProvider) ?? 1;

      final result = await useCase(enterpriseId: enterpriseId, page: 1, pageSize: 50);

      if (!mounted) return;

      final uiCandidates = result.items.map((item) => item.toCandidateData()).toList();
      final trimmedQuery = query.trim().toLowerCase();
      if (trimmedQuery.isEmpty) {
        _suggestions = uiCandidates.take(5).toList();
      } else {
        _suggestions = uiCandidates
            .where((c) => c.name.toLowerCase().contains(trimmedQuery) || c.email.toLowerCase().contains(trimmedQuery))
            .toList();
      }
    } catch (e) {
      _suggestions = [];
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        if (_showSuggestions) {
          _updateOverlay();
        }
      }
    }
  }

  void _showOverlay() {
    if (_showSuggestions) return;

    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    if (mounted) {
      setState(() {
        _showSuggestions = true;
      });
    }
  }

  void _removeOverlay({bool updateState = true}) {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (updateState && mounted) {
      setState(() {
        _showSuggestions = false;
      });
    }
  }

  void _updateOverlay() {
    _overlayEntry?.markNeedsBuild();
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) {
        final isDark = context.isDark;
        final renderBox = this.context.findRenderObject() as RenderBox;
        final size = renderBox.size;
        final position = renderBox.localToGlobal(Offset.zero);
        final media = MediaQuery.of(context);
        final screenHeight = media.size.height;
        final paddingTop = media.padding.top;
        final paddingBottom = media.padding.bottom;
        final spaceBelow = screenHeight - paddingBottom - (position.dy + size.height + 4.h);
        final spaceAbove = position.dy - paddingTop - 4.h;
        final showAbove = spaceBelow < 150 && spaceAbove > spaceBelow;
        final maxHeight = showAbove ? (300.h).clamp(0.0, spaceAbove) : (300.h).clamp(0.0, spaceBelow);
        final offset = showAbove ? Offset(0, -(maxHeight + 4.h)) : Offset(0, size.height + 4.h);

        return Positioned(
          width: size.width,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: offset,
            child: Material(
              elevation: 0,
              borderRadius: BorderRadius.circular(12.r),
              color: Colors.transparent,
              child: Container(
                constraints: BoxConstraints(maxHeight: maxHeight),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
                  boxShadow: AppShadows.primaryShadow,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: _isLoading
                      ? Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.w),
                            child: AppLoadingIndicator(size: 32.r),
                          ),
                        )
                      : _suggestions.isEmpty
                      ? Padding(
                          padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 16.w),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.search_off_rounded,
                                size: 48.r,
                                color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
                              ),
                              Gap(12.h),
                              Text(
                                'No candidates found',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          itemCount: _suggestions.length,
                          separatorBuilder: (context, index) => Divider(
                            height: 1,
                            thickness: 1,
                            color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
                            indent: 16.w,
                            endIndent: 16.w,
                          ),
                          itemBuilder: (context, index) {
                            final candidate = _suggestions[index];
                            final isSelected = widget.selectedCandidate?.id == candidate.id;
                            return Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  _controller.text = candidate.name;
                                  widget.onCandidateSelected(candidate);
                                  _focusNode.unfocus();
                                  _removeOverlay();
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? (isDark
                                              ? AppColors.primary.withValues(alpha: 0.15)
                                              : AppColors.primary.withValues(alpha: 0.08))
                                        : Colors.transparent,
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 40.w,
                                        height: 40.h,
                                        decoration: BoxDecoration(
                                          color: isDark
                                              ? AppColors.primary.withValues(alpha: 0.2)
                                              : AppColors.primary.withValues(alpha: 0.1),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Text(
                                            candidate.name.isNotEmpty ? candidate.name[0].toUpperCase() : 'C',
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Gap(12.w),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              candidate.name,
                                              style: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w500,
                                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                                              ),
                                            ),
                                            Gap(2.h),
                                            Text(
                                              candidate.email,
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (isSelected)
                                        Icon(Icons.check_circle_rounded, size: 20.r, color: AppColors.primary),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: widget.label,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: isDark ? context.themeTextPrimary : AppColors.inputLabel,
                  fontFamily: 'Inter',
                ),
              ),
              if (widget.isRequired)
                TextSpan(
                  text: ' *',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.error,
                    fontFamily: 'Inter',
                  ),
                ),
            ],
          ),
        ),
        Gap(8.h),
        CompositedTransformTarget(
          link: _layerLink,
          child: DigifyTextField(
            controller: _controller,
            hintText: widget.hintText ?? 'Type to search candidates',
            focusNode: _focusNode,
            prefixIcon: Padding(
              padding: EdgeInsetsDirectional.only(start: 12.w, end: 8.w),
              child: DigifyAsset(
                assetPath: Assets.icons.searchIcon.path,
                width: 20,
                height: 20,
                color: AppColors.textMuted,
              ),
            ),
            textInputAction: TextInputAction.search,
            onChanged: (value) {
              _handleSearch(value);
              if (!_showSuggestions && _focusNode.hasFocus) {
                _showOverlay();
              }
            },
            filled: true,
            fillColor: widget.fillColor ?? Colors.transparent,
          ),
        ),
      ],
    );
  }
}
