import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/hiring/domain/configs/hiring_config.dart';
import 'package:grc/features/hiring/presentation/models/candidate_data.dart';
import 'package:grc/features/hiring/presentation/widgets/candidate_detail/tabs/notes/add_note_card.dart';
import 'package:grc/features/hiring/presentation/widgets/candidate_detail/tabs/notes/note_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CandidateNotesTab extends StatefulWidget {
  const CandidateNotesTab({super.key, required this.candidate, required this.isDark});

  final CandidateData candidate;
  final bool isDark;

  @override
  State<CandidateNotesTab> createState() => _CandidateNotesTabState();
}

class _CandidateNotesTabState extends State<CandidateNotesTab> {
  late List<CandidateNote> _notes;
  final _notesController = TextEditingController();
  bool _isPrivate = true;

  @override
  void initState() {
    super.initState();
    _notes = List.from(HiringConfig.buildCandidateNotes(widget.candidate.id, widget.candidate.name));
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobileLayout;
    final outerPadding = isMobile ? 16.w : 24.w;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: outerPadding, vertical: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AddNoteCard(
            isDark: widget.isDark,
            notesController: _notesController,
            isPrivate: _isPrivate,
            onPrivateChanged: (value) {
              setState(() {
                _isPrivate = value;
              });
            },
            onAddNote: () {},
          ),
          Gap(16.h),
          _buildTimelineList(),
        ],
      ),
    );
  }

  Widget _buildTimelineList() {
    if (_notes.isEmpty) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 48.h),
        decoration: BoxDecoration(
          color: widget.isDark ? AppColors.cardBackgroundDark : Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: widget.isDark ? AppColors.cardBorderDark : const Color(0xFFE5E7EB)),
        ),
        child: Column(
          children: [
            Icon(
              Icons.notes_rounded,
              color: widget.isDark ? AppColors.textPlaceholderDark : AppColors.textPlaceholder,
              size: 40.r,
            ),
            Gap(12.h),
            Text(
              'No notes recorded',
              style: context.textTheme.titleMedium?.copyWith(
                color: widget.isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _notes.length,
      separatorBuilder: (context, index) => Gap(16.h),
      itemBuilder: (context, index) {
        final note = _notes[index];
        return NoteCard(isDark: widget.isDark, note: note);
      },
    );
  }
}
