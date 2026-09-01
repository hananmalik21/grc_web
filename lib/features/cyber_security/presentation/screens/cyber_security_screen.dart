import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/features/cyber_security/presentation/providers/cyber_security_tab_state_provider.dart';
import 'package:grc/features/cyber_security/presentation/screens/cyber_security_dashboard_view.dart';
import 'package:grc/features/cyber_security/presentation/widgets/cyber_sidebar.dart';
import 'package:grc/features/cyber_security/presentation/widgets/cyber_top_bar.dart';
import 'package:grc/features/cyber_security/sub_modules/ai_governance/ai_governance_screen.dart';
import 'package:grc/features/cyber_security/sub_modules/ai_soc_copilot/ai_soc_copilot_screen.dart';
import 'package:grc/features/cyber_security/sub_modules/app_api/app_api_screen.dart';
import 'package:grc/features/cyber_security/sub_modules/cloud_posture/cloud_posture_screen.dart';
import 'package:grc/features/cyber_security/sub_modules/data_security/data_security_screen.dart';
import 'package:grc/features/cyber_security/sub_modules/grc_compliance/grc_compliance_screen.dart';
import 'package:grc/features/cyber_security/sub_modules/identity_access/identity_access_screen.dart';
import 'package:grc/features/cyber_security/sub_modules/incidents/incidents_screen.dart';
import 'package:grc/features/cyber_security/sub_modules/network_security/network_security_screen.dart';
import 'package:grc/features/cyber_security/sub_modules/threat_detection/threat_detection_screen.dart';

class CyberSecurityScreen extends ConsumerStatefulWidget {
  const CyberSecurityScreen({super.key});

  @override
  ConsumerState<CyberSecurityScreen> createState() =>
      _CyberSecurityScreenState();
}

class _CyberSecurityScreenState extends ConsumerState<CyberSecurityScreen> {
  bool _showMobileSidebar = false;

  Widget _buildActiveScreen(int index) {
    switch (index) {
      case 0:
        return const CyberSecurityDashboardView(key: ValueKey('cyber_tab_0'));
      case 1:
        return const CloudPostureScreen(key: ValueKey('cyber_tab_1'));
      case 2:
        return const IdentityAccessScreen(key: ValueKey('cyber_tab_2'));
      case 3:
        return const NetworkSecurityScreen(key: ValueKey('cyber_tab_3'));
      case 4:
        return const AppApiScreen(key: ValueKey('cyber_tab_4'));
      case 5:
        return const DataSecurityScreen(key: ValueKey('cyber_tab_5'));
      case 6:
        return const AiSocCopilotScreen(key: ValueKey('cyber_tab_6'));
      case 7:
        return const ThreatDetectionScreen(key: ValueKey('cyber_tab_7'));
      case 8:
        return const IncidentsScreen(key: ValueKey('cyber_tab_8'));
      case 9:
        return const GrcComplianceScreen(key: ValueKey('cyber_tab_9'));
      case 10:
        return const AiGovernanceScreen(key: ValueKey('cyber_tab_10'));
      default:
        return const CyberSecurityDashboardView(key: ValueKey('cyber_tab_default'));
    }
  }

  @override
  Widget build(BuildContext context) {
    final tabIndex = ref.watch(cyberSecurityTabStateProvider).currentTabIndex;

    return Scaffold(
      backgroundColor: AppColors.cyberDarkBg,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 900;

            return Row(
              children: [
                // Desktop Cyber Sidebar
                if (isDesktop) const CyberSidebar(),

                // Main Content Area with Top Bar
                Expanded(
                  child: Column(
                    children: [
                      // Cyber Top Bar
                      CyberTopBar(
                        onToggleSidebar: isDesktop
                            ? null
                            : () {
                                setState(() {
                                  _showMobileSidebar = !_showMobileSidebar;
                                });
                              },
                      ),

                      // Fast Direct Content View
                      Expanded(
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: _buildActiveScreen(tabIndex),
                            ),

                            // Mobile/Tablet Drawer Overlay
                            if (!isDesktop && _showMobileSidebar)
                              Positioned.fill(
                                child: Row(
                                  children: [
                                    const CyberSidebar(),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _showMobileSidebar = false;
                                          });
                                        },
                                        child: Container(
                                          color: Colors.black.withValues(alpha: 0.6),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
