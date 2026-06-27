import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/app_loading_indicator.dart';
import 'package:grc/core/widgets/common/digify_checkbox.dart';
import 'package:grc/core/widgets/common/digify_error_state.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/core/widgets/feedback/app_dialog.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/hiring/application/talent_pools/add_talent_pool_args.dart';
import 'package:grc/features/hiring/application/talent_pools/providers/add_talent_pool_provider.dart';
import 'package:grc/features/hiring/application/talent_pools/states/add_talent_pool_state.dart';
import 'package:grc/features/hiring/domain/models/talent_pools/talent_pool.dart';
import 'package:grc/features/hiring/presentation/models/candidate_data.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class AddTalentPoolDialog extends ConsumerStatefulWidget {
  final CandidateData candidate;

  const AddTalentPoolDialog({super.key, required this.candidate});

  static Future<void> show(BuildContext context, CandidateData candidate) {
    return showDialog(
      context: context,
      builder: (context) => AddTalentPoolDialog(candidate: candidate),
    );
  }

  @override
  ConsumerState<AddTalentPoolDialog> createState() => _AddTalentPoolDialogState();
}

class _AddTalentPoolDialogState extends ConsumerState<AddTalentPoolDialog> {
  AddTalentPoolArgs get _providerArgs => AddTalentPoolArgs(
    candidateGuid: widget.candidate.id,
    initialSelectedPoolGuids: widget.candidate.assignedTalentPoolGuids,
  );
  final TextEditingController _newPoolNameController = TextEditingController();

  @override
  void dispose() {
    _newPoolNameController.dispose();
    super.dispose();
  }

  Future<void> _onCreatePoolPressed() async {
    final notifier = ref.read(addTalentPoolProvider(_providerArgs).notifier);
    final success = await notifier.createPool();

    if (!mounted) return;

    final latestState = ref.read(addTalentPoolProvider(_providerArgs));

    if (success) {
      _newPoolNameController.clear();
      ToastService.success(context, 'Talent pool created successfully');
      return;
    }

    final error = latestState.createPoolError;
    if ((error ?? '').isNotEmpty) {
      ToastService.error(context, error!);
    }
  }

  Future<void> _onAddToPoolsPressed() async {
    final notifier = ref.read(addTalentPoolProvider(_providerArgs).notifier);
    final success = await notifier.addCandidateToSelectedPools();

    if (!mounted) return;

    final latestState = ref.read(addTalentPoolProvider(_providerArgs));
    if (success) {
      ToastService.success(context, 'Candidate added to selected talent pools');
      context.pop();
      return;
    }

    final error = latestState.assignPoolsError;
    if ((error ?? '').isNotEmpty) {
      ToastService.error(context, error!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final state = ref.watch(addTalentPoolProvider(_providerArgs));
    final notifier = ref.read(addTalentPoolProvider(_providerArgs).notifier);

    return AppDialog(
      title: 'Add to Talent Pool',
      width: 650.w,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(minHeight: 420.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _CandidateBanner(candidateName: widget.candidate.name, isDark: isDark),
                Gap(24.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Select Talent Pools',
                      style: context.textTheme.headlineSmall?.copyWith(
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                Gap(16.h),
                _CreatePoolSection(
                  state: state,
                  controller: _newPoolNameController,
                  onNameChanged: notifier.setNewPoolName,
                  onCreate: _onCreatePoolPressed,
                ),
                Gap(16.h),
                _PoolsContent(
                  state: state,
                  isDark: isDark,
                  onRetry: () => notifier.loadPools(),
                  onToggle: notifier.togglePoolSelection,
                ),
              ],
            ),
          ),
          Gap(16.h),
          PaginationControls(
            currentPage: state.currentPage,
            totalPages: state.totalPages,
            totalItems: state.totalItems,
            pageSize: state.pageSize,
            hasNext: state.hasNext,
            hasPrevious: state.hasPrevious,
            isLoading: false,
            onPrevious: state.hasPrevious && !state.isLoading ? notifier.previousPage : null,
            onNext: state.hasNext && !state.isLoading ? notifier.nextPage : null,
          ),
        ],
      ),
      actions: [
        AppButton.outline(label: 'Cancel', onPressed: () => context.pop()),
        SizedBox(width: 12.w),
        AppButton.primary(
          label: 'Add to ${state.selectedPoolGuids.length} Pools',
          isLoading: state.isAssigningPools,
          onPressed: state.selectedPoolGuids.isEmpty ? null : _onAddToPoolsPressed,
        ),
      ],
    );
  }
}

class _CandidateBanner extends StatelessWidget {
  const _CandidateBanner({required this.candidateName, required this.isDark});

  final String candidateName;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.infoBgDark : AppColors.infoBg,
        border: Border.all(color: isDark ? AppColors.infoBorderDark : AppColors.infoBorder),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Text(
            'Candidate: ',
            style: context.textTheme.labelLarge?.copyWith(
              fontSize: 14.sp,
              color: isDark ? AppColors.textPrimaryDark : AppColors.infoText,
            ),
          ),
          Text(
            candidateName,
            style: context.textTheme.bodyMedium?.copyWith(
              color: isDark ? AppColors.textPrimaryDark : AppColors.infoText,
            ),
          ),
        ],
      ),
    );
  }
}

class _CreatePoolSection extends StatelessWidget {
  const _CreatePoolSection({
    required this.state,
    required this.controller,
    required this.onNameChanged,
    required this.onCreate,
  });

  final AddTalentPoolState state;
  final TextEditingController controller;
  final ValueChanged<String> onNameChanged;
  final Future<void> Function() onCreate;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final canCreate = state.newPoolName.trim().isNotEmpty && !state.isCreatingPool;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.tableHeaderBackground,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'New Pool Name',
            style: context.textTheme.titleSmall?.copyWith(
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            ),
          ),
          Gap(10.h),
          Row(
            children: [
              Expanded(
                child: DigifyTextField(
                  controller: controller,
                  hintText: 'e.g., Future Opportunities',
                  onChanged: onNameChanged,
                ),
              ),
              Gap(12.w),
              AppButton.primary(
                label: 'Create',
                isLoading: state.isCreatingPool,
                onPressed: canCreate ? onCreate : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PoolsContent extends StatelessWidget {
  const _PoolsContent({required this.state, required this.isDark, required this.onRetry, required this.onToggle});

  final AddTalentPoolState state;
  final bool isDark;
  final VoidCallback onRetry;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    if (state.isLoading && state.pools.isEmpty) {
      return SizedBox(
        height: 200.h,
        child: const Center(child: AppLoadingIndicator()),
      );
    }

    if (state.loadError != null && state.pools.isEmpty) {
      return DigifyErrorState(message: state.loadError!, onRetry: onRetry);
    }

    if (state.pools.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 32.h),
        child: Center(
          child: Text(
            'No talent pools found',
            style: context.textTheme.bodyMedium?.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
            ),
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: state.pools.length,
      separatorBuilder: (context, index) => Gap(12.h),
      itemBuilder: (context, index) {
        final pool = state.pools[index];
        final isSelected = state.isPoolSelected(pool.poolGuid);

        return _TalentPoolListTile(
          pool: pool,
          isSelected: isSelected,
          isDark: isDark,
          onToggle: () => onToggle(pool.poolGuid),
        );
      },
    );
  }
}

class _TalentPoolListTile extends StatelessWidget {
  const _TalentPoolListTile({
    required this.pool,
    required this.isSelected,
    required this.isDark,
    required this.onToggle,
  });

  final TalentPool pool;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onToggle,
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.primary : (isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
          ),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 4.h),
              child: DigifyCheckbox(value: isSelected, onChanged: (_) => onToggle()),
            ),
            Gap(12.w),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      pool.poolName,
                      style: context.textTheme.titleMedium?.copyWith(
                        fontSize: 15.sp,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      DigifyAsset(
                        assetPath: Assets.icons.usersIcon.path,
                        width: 14,
                        height: 14,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                      ),
                      Gap(4.w),
                      Text(
                        '${pool.candidateCount} candidates',
                        style: context.textTheme.titleSmall?.copyWith(
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
