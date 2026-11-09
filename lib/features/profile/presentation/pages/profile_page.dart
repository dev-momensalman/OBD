import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../injection_container.dart' as di;
import '../../domain/entities/user_profile_entity.dart';
import '../bloc/profile_cubit.dart';
import '../bloc/profile_state.dart';

/// Authentic Profile Page matching Figma Node 325:1927
/// Connected via Clean Architecture (Cubit -> UseCase -> Repository -> DataSource)
class ProfilePage extends StatelessWidget {
  final VoidCallback? onBack;

  const ProfilePage({super.key, this.onBack});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<ProfileCubit>()..fetchProfile(),
      child: _ProfileView(onBack: onBack),
    );
  }
}

class _ProfileView extends StatelessWidget {
  final VoidCallback? onBack;

  const _ProfileView({this.onBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          UserProfileEntity? profile;
          if (state is ProfileLoaded) {
            profile = state.profile;
          }

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                // 1. Rich Curved Dark Blue Profile Header (Figma Node 325:1927)
                _buildProfileHeader(context, profile,
                    isLoading: state is ProfileLoading),

                // 2. Profile Options List (Figma Node 325:1929)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildMenuItem(
                        icon: Icons.directions_car_rounded,
                        title: 'My vehicle',
                        subtitle: profile?.vehicleName,
                        onTap: () =>
                            Navigator.of(context).pushNamed(AppRoutes.myVehicle),
                      ),
                      const Divider(height: 1, color: Color(0xFFF1F5F9)),
                      _buildMenuItem(
                        icon: Icons.developer_board_rounded,
                        title: 'My device',
                        subtitle: profile?.deviceSerial,
                        onTap: () =>
                            Navigator.of(context).pushNamed(AppRoutes.myDevice),
                      ),
                      const Divider(height: 1, color: Color(0xFFF1F5F9)),
                      _buildMenuItem(
                        icon: Icons.notifications_outlined,
                        title: 'Notifications',
                        onTap: () => Navigator.of(context)
                            .pushNamed(AppRoutes.notifications),
                      ),
                      const Divider(height: 1, color: Color(0xFFF1F5F9)),
                      _buildMenuItem(
                        icon: Icons.help_outline_rounded,
                        title: 'Help & Support',
                        onTap: () => Navigator.of(context)
                            .pushNamed(AppRoutes.helpSupport),
                      ),
                      const Divider(height: 1, color: Color(0xFFF1F5F9)),
                      _buildMenuItem(
                        icon: Icons.privacy_tip_outlined,
                        title: 'Privacy & data',
                        onTap: () => Navigator.of(context)
                            .pushNamed(AppRoutes.privacyData),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // 3. Settings Section Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Setting',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // 4. Settings Card (Language & Log out)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildMenuItem(
                        icon: Icons.language_rounded,
                        title: 'Language & units',
                        subtitle: profile?.preferredLanguage,
                        onTap: () => Navigator.of(context)
                            .pushNamed(AppRoutes.languageUnits),
                      ),
                      const Divider(height: 1, color: Color(0xFFF1F5F9)),
                      _buildMenuItem(
                        icon: Icons.logout_rounded,
                        title: 'Log out',
                        isDestructive: true,
                        onTap: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            AppRoutes.signIn,
                            (route) => false,
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 120),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, UserProfileEntity? profile,
      {bool isLoading = false}) {
    final username =
        profile?.username ?? (isLoading ? 'Loading...' : 'youssefgad_26');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 50, bottom: 28, left: 20, right: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF003FB8), // Royal Blue
            Color(0xFF001C52), // Marine Navy
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Profile',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // User Info Row (Avatar + Handle + Edit Pill)
          Row(
            children: [
              // Avatar with Edit badge (Figma Node 325:1927)
              Stack(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.2),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.person_rounded,
                      size: 38,
                      color: Colors.white,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.edit_rounded,
                        size: 12,
                        color: Color(0xFF003FB8),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username,
                      style: GoogleFonts.inter(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(AppRoutes.editProfile);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.edit_outlined,
                                size: 12, color: Color(0xFF003FB8)),
                            const SizedBox(width: 4),
                            Text(
                              'Edit profile',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF003FB8),
                              ),
                            ),
                            const Icon(Icons.chevron_right_rounded,
                                size: 14, color: Color(0xFF003FB8)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final color =
        isDestructive ? const Color(0xFFDC2626) : const Color(0xFF0F172A);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 22, color: color),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                  if (subtitle != null && subtitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: isDestructive
                  ? const Color(0xFFDC2626)
                  : const Color(0xFF94A3B8),
            ),
          ],
        ),
      ),
    );
  }
}
