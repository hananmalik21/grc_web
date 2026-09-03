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

  @override
  void dispose() {
    _nameController.dispose();
    _regionController.dispose();
    _accessKeyController.dispose();
    _secretKeyController.dispose();
    _orgUrlController.dispose();
    _apiTokenController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    final connectors = ref.watch(cloudConnectorsProvider);

    return CyberScreenLayout(
      title: 'Cloud Connectors',
      subtitle: 'Connect AWS or Okta to pull live identity posture data',
      actions: [
        IconButton(
          tooltip: 'Refresh connectors',
          onPressed: () => ref.invalidate(cloudConnectorsProvider),
          icon: const Icon(Icons.refresh, color: AppColors.dashCyberSecurity),
        ),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 980;
          final form = _buildConnectorForm();
          final list = _buildConnectorList(connectors);
          return isWide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: form),
                    const Gap(20),
                    Expanded(child: list),
                  ],
                )
              : Column(children: [form, const Gap(20), list]);
        },
      ),
    );
  }

  Widget _buildConnectorForm() {
    return _panel(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _panelTitle(
              'Add cloud connector',
              'Credentials are encrypted at rest.',
            ),
            const Gap(18),
            DropdownButtonFormField<String>(
              value: _provider,
              decoration: _decoration('Provider'),
              items: const [
                DropdownMenuItem(
                  value: 'AWS',
                  child: Text('Amazon Web Services'),
                ),
                DropdownMenuItem(value: 'OKTA', child: Text('Okta')),
              ],
              onChanged: (value) => setState(() => _provider = value ?? 'AWS'),
            ),
            const Gap(12),
            _field(_nameController, 'Connection name', Icons.label_outline),
            const Gap(12),
            if (_provider == 'AWS') ...[
              _field(_regionController, 'AWS region', Icons.public),
              const Gap(12),
              _field(_accessKeyController, 'Access key ID', Icons.key_outlined),
              const Gap(12),
              _secretField(_secretKeyController, 'Secret access key'),
            ] else ...[
              _field(
                _orgUrlController,
                'Okta organization URL',
                Icons.language,
              ),
              const Gap(12),
              _secretField(_apiTokenController, 'Okta API token'),
            ],
            const Gap(18),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                label:
                    'Connect ${_provider == 'AWS' ? 'AWS account' : 'Okta organization'}',
                type: AppButtonType.primary,
                onPressed: _isSubmitting ? null : _submit,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectorList(
    AsyncValue<List<CloudCoverageConnectorDto>> connectors,
  ) {
    return _panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _panelTitle(
            'Connected accounts',
            'Live connections available to IAM sync.',
          ),
          const Gap(16),
          connectors.when(
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 28),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, stack) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text('Unable to load connectors: $error'),
            ),
            data: (items) => items.isEmpty
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 28),
                    child: Center(
                      child: Text('No cloud connectors connected yet.'),
                    ),
                  )
                : Column(
                    children: items
                        .map(
                          (connector) => ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(
                              backgroundColor: AppColors.cyberLiveGreen
                                  .withValues(alpha: 0.14),
                              child: Icon(
                                connector.provider.toUpperCase() == 'AWS'
                                    ? Icons.cloud_outlined
                                    : Icons.verified_user_outlined,
                                color: AppColors.cyberLiveGreen,
                              ),
                            ),
                            title: Text(connector.name),
                            subtitle: Text(
                              '${connector.provider}  •  ${connector.status}',
                            ),
                            trailing: TextButton.icon(
                              onPressed: _syncingConnectorId == connector.id
                                  ? null
                                  : () => _syncConnector(connector),
                              icon: _syncingConnectorId == connector.id
                                  ? const SizedBox(
                                      width: 14,
                                      height: 14,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(Icons.sync, size: 16),
                              label: const Text('Sync'),
                            ),
                          ),
                        )
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _panel({required Widget child}) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.cardBackgroundDark,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.cardBorderDark),
      ),
      child: child,
    );
  }

  Widget _panelTitle(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Gap(4),
        Text(
          subtitle,
          style: TextStyle(color: AppColors.textTertiaryDark, fontSize: 12.sp),
        ),
      ],
    );
  }

  Widget _field(TextEditingController controller, String label, IconData icon) {
    return TextFormField(
      controller: controller,
      decoration: _decoration(label, icon),
      validator: (value) =>
          value == null || value.trim().isEmpty ? 'Required' : null,
    );
  }

  Widget _secretField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      obscureText: _obscureSecret,
      decoration: _decoration(label, Icons.lock_outline).copyWith(
        suffixIcon: IconButton(
          tooltip: _obscureSecret ? 'Show value' : 'Hide value',
          icon: Icon(_obscureSecret ? Icons.visibility : Icons.visibility_off),
          onPressed: () => setState(() => _obscureSecret = !_obscureSecret),
        ),
      ),
      validator: (value) =>
          value == null || value.trim().isEmpty ? 'Required' : null,
    );
  }

  InputDecoration _decoration(String label, [IconData? icon]) {
    return InputDecoration(
      labelText: label,
      prefixIcon: icon == null ? null : Icon(icon),
      filled: true,
      fillColor: const Color(0xFF111827),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(6.r)),
    );
  }
}
