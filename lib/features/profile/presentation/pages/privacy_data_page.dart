import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:obd_vision/core/constants/app_routes.dart';
import 'package:obd_vision/core/services/app_preferences.dart';
import 'package:obd_vision/core/utils/app_actions.dart';
import 'package:obd_vision/core/utils/l10n_extensions.dart';
import 'package:obd_vision/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:obd_vision/features/diagnostics/presentation/bloc/dashboard_cubit.dart';
import 'package:obd_vision/features/history/presentation/bloc/history_cubit.dart';
import 'package:obd_vision/features/profile/presentation/bloc/profile_cubit.dart';
import 'package:obd_vision/features/vehicle/presentation/bloc/vehicle_cubit.dart';
import 'package:obd_vision/injection_container.dart' as di;

/// Privacy & Data Policy Screen (Figma Node 325:3324)
/// Provides links to Privacy Policy, Terms of Use, Data Export, and Account Deletion,
/// with GDPR & End-to-end encryption trust credentials.
class PrivacyDataPage extends StatelessWidget {
  const PrivacyDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 1. Curved Header
          Container(
            height: 124,
            width: double.infinity,
            padding: const EdgeInsets.only(top: 44, left: 16, right: 16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF000C24),
                  Color(0xFF002F8A),
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const RtlBackIcon(
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    context.l10n.privacyAndData,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 40),
              ],
            ),
          ),

          // 2. Options Card
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFD9E2F0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildRow(
                          icon: Icons.policy_rounded,
                          title: context.l10n.privacyPolicyItem,
                          onTap: () => AppActions.showLegalSheet(
                            context,
                            isPrivacyPolicy: true,
                          ),
                        ),
                        const Divider(height: 1, color: Color(0xFFE8EEFF)),
                        _buildRow(
                          icon: Icons.article_rounded,
                          title: context.l10n.termsOfUseItem,
                          onTap: () => AppActions.showLegalSheet(
                            context,
                            isPrivacyPolicy: false,
                          ),
                        ),
                        const Divider(height: 1, color: Color(0xFFE8EEFF)),
                        _buildRow(
                          icon: Icons.download_rounded,
                          title: context.l10n.downloadMyData,
                          onTap: () {
                            final prefs = di.sl.isRegistered<AppPreferences>()
                                ? di.sl<AppPreferences>()
                                : null;
                            final payload = jsonEncode({
                              'language': prefs?.languageCode ?? 'en',
                              'distanceUnit': prefs?.distanceUnit ?? 'km',
                              'tempUnit': prefs?.tempUnit ?? '°C',
                              'profile': prefs?.savedProfileJson,
                              'vehicles': prefs?.savedVehiclesJson,
                              'historyLogs': prefs?.savedHistoryLogsJson,
                            });
                            AppActions.copyText(
                              context,
                              payload,
                              feedback: context.l10n.dataExportedMsg,
                            );
                          },
                        ),
                        const Divider(height: 1, color: Color(0xFFE8EEFF)),
                        _buildRow(
                          icon: Icons.delete_forever_rounded,
                          title: context.l10n.deleteAccountItem,
                          isDestructive: true,
                          badge: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFB3748)
                                  .withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(9999),
                            ),
                            child: Text(
                              context.l10n.permanentBadge,
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFFD00416),
                              ),
                            ),
                          ),
                          onTap: () {
                            showDialog<void>(
                              context: context,
                              builder: (dlgCtx) => AlertDialog(
                                title: Text(context.l10n.confirmDeleteAccountTitle),
                                content: Text(context.l10n.confirmDeleteAccountBody),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(dlgCtx).pop(),
                                    child: Text(context.l10n.cancelButton),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFDC2626),
                                      foregroundColor: Colors.white,
                                    ),
                                    onPressed: () async {
                                      Navigator.of(dlgCtx).pop();
                                      if (di.sl.isRegistered<IAuthRepository>()) {
                                        await di.sl<IAuthRepository>().signOut();
                                      }
                                      if (di.sl.isRegistered<AppPreferences>()) {
                                        await di.sl<AppPreferences>()
                                            .clearUserSessionData();
                                      }
                                      if (!context.mounted) return;
                                      try {
                                        context.read<ProfileCubit>().clearSession();
                                      } catch (_) {}
                                      try {
                                        context.read<VehicleCubit>().resetForLogout();
                                      } catch (_) {}
                                      try {
                                        context.read<HistoryCubit>().clearSession();
                                      } catch (_) {}
                                      try {
                                        context.read<DashboardCubit>().clearSession();
                                      } catch (_) {}
                                      Navigator.of(context).pushNamedAndRemoveUntil(
                                        AppRoutes.signIn,
                                        (route) => false,
                                      );
                                    },
                                    child: Text(context.l10n.confirmButton),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Reassurance & Trust Metric Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF84EBB4).withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.verified_user_rounded,
                          size: 16,
                          color: Color(0xFF1FC16B),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            context.l10n.gdprEncryptedBadge,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1FC16B),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow({
    required IconData icon,
    required String title,
    bool isDestructive = false,
    Widget? badge,
    required VoidCallback onTap,
  }) {
    final color =
        isDestructive ? const Color(0xFFD00416) : const Color(0xFF1F2A44);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isDestructive
                    ? const Color(0xFFFB3748).withValues(alpha: 0.1)
                    : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isDestructive
                    ? const Color(0xFFD00416)
                    : const Color(0xFF003FB8),
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
            if (badge != null) ...[
              badge,
              const SizedBox(width: 8),
            ],
            RtlForwardChevron(
              color: isDestructive
                  ? const Color(0xFFD00416)
                  : const Color(0xFF94A3B8),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
