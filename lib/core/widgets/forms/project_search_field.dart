import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/debouncer.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/time_tracking_and_attendance/domain/models/project.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/providers/timesheet/project_providers.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProjectSearchField extends ConsumerStatefulWidget {
  final String label;
  final bool isRequired;
  final Project? selectedProject;
  final ValueChanged<Project> onProjectSelected;
  final String? hintText;
  final int enterpriseId;
  final Color? fillColor;

  const ProjectSearchField({
    super.key,
    required this.label,
    required this.onProjectSelected,
    required this.enterpriseId,
    this.isRequired = false,
    this.selectedProject,
    this.hintText,
    this.fillColor,
  });

  @override
  ConsumerState<ProjectSearchField> createState() => _ProjectSearchFieldState();
}

class _ProjectSearchFieldState extends ConsumerState<ProjectSearchField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  final LayerLink _layerLink = LayerLink();
  final Debouncer _debouncer = Debouncer(delay: const Duration(milliseconds: 500));
  OverlayEntry? _overlayEntry;
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.selectedProject != null ? _projectDisplayName(widget.selectedProject!) : '',
    );
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(ProjectSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedProject != oldWidget.selectedProject) {
      _controller.text = widget.selectedProject != null ? _projectDisplayName(widget.selectedProject!) : '';
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
      ref.read(projectNotifierProvider.notifier).loadProjects(enterpriseId: widget.enterpriseId, search: null, page: 1);
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
    final trimmedQuery = query.trim();
    _debouncer.run(() {
      if (mounted) {
        ref
            .read(projectNotifierProvider.notifier)
            .searchProjects(enterpriseId: widget.enterpriseId, search: trimmedQuery.isEmpty ? null : trimmedQuery);
      }
    });
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
    _overlayEntry?.remove();
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  String _projectDisplayName(Project project) {
    if (project.name.isNotEmpty) {
      return project.name;
    }
    if (project.code.isNotEmpty) {
      return project.code;
    }
    return 'Project #${project.id}';
  }

  OverlayEntry _createOverlayEntry() {
    final isDark = context.isDark;
    final renderBox = context.findRenderObject() as RenderBox;
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

    return OverlayEntry(
      builder: (context) => Consumer(
        builder: (context, ref, child) {
          final projectState = ref.watch(projectNotifierProvider);

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
                    child: projectState.isLoading
                        ? Skeletonizer(
                            enabled: true,
                            child: ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.symmetric(vertical: 8.h),
                              itemCount: 5,
                              itemBuilder: (context, index) {
                                return Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 32.w,
                                        height: 32.h,
                                        decoration: BoxDecoration(color: Colors.grey[300], shape: BoxShape.circle),
                                      ),
                                      Gap(12.w),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              height: 14.h,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius: BorderRadius.circular(4.r),
                                              ),
                                            ),
                                            Gap(6.h),
                                            Container(
                                              width: 150.w,
                                              height: 12.h,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius: BorderRadius.circular(4.r),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          )
                        : projectState.projects.isEmpty
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
                                  'No projects found',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                                  ),
                                ),
                                Gap(4.h),
                                Text(
                                  'Try adjusting your search',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.separated(
                            shrinkWrap: true,
                            padding: EdgeInsets.symmetric(vertical: 8.h),
                            itemCount: projectState.projects.length,
                            separatorBuilder: (context, index) => Divider(
                              height: 1,
                              thickness: 1,
                              color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
                              indent: 16.w,
                              endIndent: 16.w,
                            ),
                            itemBuilder: (context, index) {
                              final project = projectState.projects[index];
                              final isSelected = widget.selectedProject?.id == project.id;
                              return Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    _controller.text = _projectDisplayName(project);
                                    widget.onProjectSelected(project);
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
                                              project.name.isNotEmpty ? project.name[0].toUpperCase() : 'P',
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
                                                _projectDisplayName(project),
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w500,
                                                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                                                ),
                                              ),
                                              if (project.code.isNotEmpty) ...[
                                                Gap(2.h),
                                                Text(
                                                  project.code,
                                                  style: TextStyle(
                                                    fontSize: 12.sp,
                                                    color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ],
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
      ),
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
            hintText: widget.hintText ?? 'Type to search projects',
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
              } else if (_showSuggestions) {
                _updateOverlay();
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
