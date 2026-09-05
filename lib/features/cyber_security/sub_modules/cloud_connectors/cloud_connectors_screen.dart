import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/features/cyber_security/data/models/cloud_posture_dto.dart';
import 'package:grc/features/cyber_security/presentation/providers/cloud_connector_provider.dart';
import 'package:grc/features/cyber_security/presentation/providers/iam_posture_provider.dart';
import 'package:grc/features/cyber_security/presentation/widgets/cyber_screen_layout.dart';
import 'package:grc/core/theme/theme_extensions.dart';

class CloudConnectorsScreen extends ConsumerStatefulWidget {
  const CloudConnectorsScreen({super.key});

  @override
  ConsumerState<CloudConnectorsScreen> createState() =>
      _CloudConnectorsScreenState();
}

class _CloudConnectorsScreenState extends ConsumerState<CloudConnectorsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _regionController = TextEditingController(text: 'us-east-1');
  final _accessKeyController = TextEditingController();
  final _secretKeyController = TextEditingController();
  final _orgUrlController = TextEditingController();
  final _apiTokenController = TextEditingController();
  String _provider = 'AWS';
  bool _obscureSecret = true;
  bool _isSubmitting = false;
  String? _syncingConnectorId;
  Timer? _syncTimer;

  static const Color skyBlue = Color(0xFF00B4D8);

  @override
  void initState() {
    super.initState();
    _syncTimer = Timer.periodic(const Duration(seconds: 60), (_) {
      _syncAll();
    });
  }

  @override
  void dispose() {
    _syncTimer?.cancel();
    _nameController.dispose();
    _regionController.dispose();
    _accessKeyController.dispose();
    _secretKeyController.dispose();
    _orgUrlController.dispose();
    _apiTokenController.dispose();
    super.dispose();
  }

  Future<void> _syncAll() async {
    final connectors = ref.read(cloudConnectorsProvider).valueOrNull;
    if (connectors == null || connectors.isEmpty) return;
    
    ToastService.show(
      context: context,
      message: 'Auto-syncing all connectors...',
      type: ToastType.info,
    );
    
    for (final connector in connectors) {
      if (mounted) {
        await _syncConnector(connector);
      }
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);
    final authConfig = _provider == 'AWS'
        ? {
            'region': _regionController.text.trim(),
            'accessKeyId': _accessKeyController.text.trim(),
            'secretAccessKey': _secretKeyController.text,
          }
        : {
            'orgUrl': _orgUrlController.text.trim(),
            'apiToken': _apiTokenController.text,
          };
    try {
      await ref
          .read(cloudConnectorRepositoryProvider)
          .registerConnector(
            provider: _provider,
            name: _nameController.text.trim(),
            authConfig: authConfig,
          );
      if (!mounted) return;
      _nameController.clear();
      _accessKeyController.clear();
      _secretKeyController.clear();
      _apiTokenController.clear();
      ref.invalidate(cloudConnectorsProvider);
      ToastService.show(
        context: context,
        message: '$_provider connector connected successfully.',
        type: ToastType.success,
      );
    } catch (error) {
      if (!mounted) return;
      ToastService.show(
        context: context,
        message: 'Could not connect account: ${error.toString()}',
        type: ToastType.error,
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _syncConnector(CloudCoverageConnectorDto connector) async {
    setState(() => _syncingConnectorId = connector.id);
    try {
      final synced = await ref
          .read(iamPostureRepositoryProvider)
          .syncConnector(connector.id);
      ref.invalidate(iamPostureProvider);
      if (!mounted) return;
      ToastService.show(
        context: context,
        message:
            '${connector.provider} IAM sync completed: $synced principals.',
        type: ToastType.success,
      );
    } catch (error) {
      if (!mounted) return;
      ToastService.show(
        context: context,
        message: 'IAM sync failed: ${error.toString()}',
        type: ToastType.error,
      );
    } finally {
      if (mounted) setState(() => _syncingConnectorId = null);
    }
  }

  void _openConnectorDialog(String provider, AsyncValue<List<CloudCoverageConnectorDto>> connectorsAsync) {
    setState(() => _provider = provider);
    
    // Reset forms when opening
    _nameController.clear();
    _accessKeyController.clear();
    _secretKeyController.clear();
    _apiTokenController.clear();
    _orgUrlController.clear();
    _regionController.text = 'us-east-1';

    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.3),
      builder: (context) {
        final isDark = context.isDark;
        
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.all(20.w),
            child: Container(
              width: 500.w,
              height: 1000.h,
            padding: EdgeInsets.all(24.r),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
              borderRadius: BorderRadius.circular(28.r),
              boxShadow: isDark
                  ? []
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$provider Configuration',
                        style: TextStyle(
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(Icons.close, color: isDark ? Colors.white : const Color(0xFF0F172A)),
                      ),
                    ],
                  ),
                  const Gap(24),
                  StatefulBuilder(
                    builder: (context, setDialogState) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildConnectorFormInner(isDark, setDialogState),
                          const Gap(32),
                          Divider(color: isDark ? const Color(0xFF333333) : const Color(0xFFE2E8F0)),
                          const Gap(24),
                          _buildConnectorListInner(connectorsAsync, provider, isDark),
                        ],
                      );
                    }
                  ),
                ],
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
    final connectors = ref.watch(cloudConnectorsProvider);
    final isDark = context.isDark;

    return CyberScreenLayout(
      title: 'Cloud Connectors',
      subtitle: 'Connect AWS or Okta to pull live identity posture data',
      actions: [
        IconButton(
          tooltip: 'Refresh connectors',
          onPressed: () => ref.invalidate(cloudConnectorsProvider),
          icon: Icon(Icons.refresh, color: isDark ? Colors.white : const Color(0xFF0F172A)),
        ),
        const Gap(8),
        AppButton(
          label: 'Sync All',
          type: AppButtonType.primary,
          size: AppButtonSize.sm,
          backgroundColor: skyBlue,
          borderColor: skyBlue,
          height: 34.h,
          fontSize: 12.sp,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          onPressed: _syncAll,
          icon: Icons.sync,
          iconColor: Colors.white,
        ),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 240.w),
                  child: _buildMainCard(
                    'AWS', 
                    'Amazon Web Services', 
                    Icons.cloud_outlined, 
                    isDark,
                    connectors,
                  ),
                ),
              ),
              Gap(14.w),
              Flexible(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 240.w),
                  child: _buildMainCard(
                    'OKTA', 
                    'Okta Identity Cloud', 
                    Icons.verified_user_outlined, 
                    isDark,
                    connectors,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMainCard(String providerId, String title, IconData icon, bool isDark, AsyncValue<List<CloudCoverageConnectorDto>> connectors) {
    final activeCount = connectors.valueOrNull?.where((c) => c.provider == providerId).length ?? 0;
    
    return InkWell(
      onTap: () => _openConnectorDialog(providerId, connectors),
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: isDark
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: skyBlue.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: skyBlue, size: 20.r),
                ),
                const Spacer(),
                if (activeCount > 0)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                    decoration: BoxDecoration(
                      color: AppColors.cyberLiveGreen.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 5.r,
                          height: 5.r,
                          decoration: const BoxDecoration(
                            color: AppColors.cyberLiveGreen,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const Gap(4),
                        Text(
                          '$activeCount Active',
                          style: TextStyle(
                            color: AppColors.cyberLiveGreen,
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            Gap(12.h),
            Text(
              title,
              style: TextStyle(
                color: isDark ? Colors.white : const Color(0xFF0F172A),
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            Gap(4.h),
            Text(
              'Manage your $title connection settings and sync identities.',
              style: TextStyle(
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                fontSize: 11.sp,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectorFormInner(bool isDark, StateSetter setDialogState) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add Connection',
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF0F172A),
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Gap(4),
          Text(
            'Credentials are encrypted at rest.',
            style: TextStyle(
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              fontSize: 12.sp,
            ),
          ),
          const Gap(24),
          _buildHelpGuide(isDark),
          const Gap(24),
          if (_provider == 'AWS') ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _field(_nameController, 'Connection name', Icons.label_outline, isDark)),
                const Gap(16),
                Expanded(child: _field(_regionController, 'AWS region', Icons.public, isDark)),
              ],
            ),
            const Gap(16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _field(_accessKeyController, 'Access key ID', Icons.key_outlined, isDark)),
                const Gap(16),
                Expanded(child: _secretField(_secretKeyController, 'Secret access key', isDark, setDialogState)),
              ],
            ),
          ] else ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _field(_nameController, 'Connection name', Icons.label_outline, isDark)),
                const Gap(16),
                Expanded(child: _field(
                  _orgUrlController,
                  'Okta organization URL',
                  Icons.language,
                  isDark,
                )),
              ],
            ),
            const Gap(16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _secretField(_apiTokenController, 'Okta API token', isDark, setDialogState)),
                const Gap(16),
                const Expanded(child: SizedBox()),
              ],
            ),
          ],
          const Gap(24),
          SizedBox(
            width: double.infinity,
            child: AppButton(
              label: 'Connect',
              type: AppButtonType.primary,
              backgroundColor: skyBlue,
              borderColor: skyBlue,
              onPressed: _isSubmitting ? null : () async {
                await _submit();
                setDialogState((){}); 
                setState((){});
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectorListInner(
    AsyncValue<List<CloudCoverageConnectorDto>> connectorsAsync,
    String provider,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Connected Accounts',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF0F172A),
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Gap(4),
        Text(
          'Live connections available to IAM sync.',
          style: TextStyle(
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            fontSize: 12.sp,
          ),
        ),
        const Gap(24),
        connectorsAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 28),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, stack) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              'Unable to load connectors: $error',
              style: TextStyle(color: isDark ? Colors.white : const Color(0xFF0F172A)),
            ),
          ),
          data: (items) {
            final providerItems = items.where((c) => c.provider == provider).toList();
            if (providerItems.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 28),
                child: Center(
                  child: Text(
                    'No $provider connections yet.',
                    style: TextStyle(
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    ),
                  ),
                ),
              );
            }
            return Column(
              children: providerItems.map(
                (connector) => Container(
                  margin: EdgeInsets.only(bottom: 12.h),
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF2D2D2F) : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors.cyberLiveGreen.withValues(alpha: 0.14),
                        child: Icon(
                          connector.provider == 'AWS'
                              ? Icons.cloud_outlined
                              : Icons.verified_user_outlined,
                          color: AppColors.cyberLiveGreen,
                        ),
                      ),
                      Gap(12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              connector.name,
                              style: TextStyle(
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                                fontWeight: FontWeight.w600,
                                fontSize: 14.sp,
                              ),
                            ),
                            Text(
                              connector.status,
                              style: TextStyle(
                                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton.icon(
                        onPressed: _syncingConnectorId == connector.id
                            ? null
                            : () async {
                                await _syncConnector(connector);
                                setState((){}); // Update parent
                              },
                        icon: _syncingConnectorId == connector.id
                            ? SizedBox(
                                width: 14.r,
                                height: 14.r,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Icon(Icons.sync, size: 16.r, color: skyBlue),
                        label: Text('Sync', style: TextStyle(color: skyBlue, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ),
              ).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _field(TextEditingController controller, String label, IconData icon, bool isDark) {
    return TextFormField(
      controller: controller,
      style: TextStyle(color: isDark ? Colors.white : const Color(0xFF0F172A)),
      decoration: _decoration(label, icon, isDark),
      validator: (value) =>
          value == null || value.trim().isEmpty ? 'Required' : null,
    );
  }

  Widget _secretField(TextEditingController controller, String label, bool isDark, StateSetter setDialogState) {
    return TextFormField(
      controller: controller,
      obscureText: _obscureSecret,
      style: TextStyle(color: isDark ? Colors.white : const Color(0xFF0F172A)),
      decoration: _decoration(label, Icons.lock_outline, isDark).copyWith(
        suffixIcon: IconButton(
          tooltip: _obscureSecret ? 'Show value' : 'Hide value',
          icon: Icon(
            _obscureSecret ? Icons.visibility : Icons.visibility_off,
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
          ),
          onPressed: () => setDialogState(() => _obscureSecret = !_obscureSecret),
        ),
      ),
      validator: (value) =>
          value == null || value.trim().isEmpty ? 'Required' : null,
    );
  }

  InputDecoration _decoration(String label, IconData icon, bool isDark) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
      prefixIcon: Icon(icon, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
      filled: true,
      fillColor: isDark ? const Color(0xFF2D2D2F) : const Color(0xFFF1F5F9),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: skyBlue, width: 1.5),
      ),
    );
  }

  Widget _buildHelpGuide(bool isDark) {
    final title = _provider == 'AWS' ? 'How to get AWS Credentials' : 'How to get Okta Credentials';
    final steps = _provider == 'AWS' 
      ? [
          '1. Log in to your AWS Management Console.',
          '2. Go to IAM (Identity and Access Management).',
          '3. Select "Users" and click "Add users".',
          '4. Attach policies with ReadOnlyAccess (or required permissions).',
          '5. Go to "Security credentials" tab and create an Access Key.',
          '6. Copy the Access Key ID and Secret Access Key.'
        ]
      : [
          '1. Log in to your Okta Admin Console.',
          '2. Go to Security > API.',
          '3. Click on the "Tokens" tab.',
          '4. Click "Create Token", name it, and click "Create".',
          '5. Copy the API Token (you won\'t be able to see it again).',
          '6. Your Org URL is typically https://<your-company>.okta.com.'
        ];

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2D2D2F) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.help_outline, color: skyBlue, size: 18.r),
              const Gap(8),
              Text(
                title,
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
          const Gap(12),
          ...steps.map((step) => Padding(
                padding: EdgeInsets.only(bottom: 6.h),
                child: Text(
                  step,
                  style: TextStyle(
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    fontSize: 12.sp,
                    height: 1.4,
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
