import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/auth/presentation/bloc/auth_cubit.dart';
import '../../features/auth/presentation/pages/auth_success_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/otp_verification_page.dart';
import '../../features/auth/presentation/pages/product_activation_page.dart';
import '../../features/auth/presentation/pages/sign_in_page.dart';
import '../../features/auth/presentation/pages/sign_up_page.dart';
import '../../features/diagnostics/presentation/pages/live_data_page.dart';
import '../../features/diagnostics/presentation/pages/report_causes_page.dart';
import '../../features/diagnostics/presentation/pages/report_summary_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/vehicle/presentation/pages/add_vehicle_page.dart';
import '../../features/profile/presentation/pages/edit_profile_page.dart';
import '../../features/vehicle/presentation/pages/edit_vehicle_page.dart';
import '../../features/profile/presentation/pages/help_support_page.dart';
import '../../features/profile/presentation/pages/language_units_page.dart';
import '../../features/profile/presentation/pages/my_device_page.dart';
import '../../features/vehicle/presentation/pages/my_vehicle_page.dart';
import '../../features/profile/presentation/pages/notifications_page.dart';
import '../../features/profile/presentation/pages/privacy_data_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/workshops/domain/entities/service_center_entity.dart';
import '../../features/workshops/presentation/pages/book_appointment_page.dart';
import '../../features/workshops/presentation/pages/booking_confirm_page.dart';
import '../../features/workshops/presentation/pages/center_details_page.dart';
import '../../injection_container.dart' as di;
import '../services/app_preferences.dart';
import 'app_routes.dart';

/// Centralized Declarative Route Registry for OBD Vision
/// Maps authentic application flows to real Figma pages with zero placeholder screens.
class AppRouter {
  AppRouter._();

  static void navigateAfterSplash(BuildContext context) {
    final hasSeenOnboarding = di.sl.isRegistered<AppPreferences>()
        ? di.sl<AppPreferences>().hasSeenOnboarding
        : false;
    final nextRoute = hasSeenOnboarding ? AppRoutes.signIn : AppRoutes.onboarding;
    Navigator.of(context).pushReplacementNamed(nextRoute);
  }

  static Map<String, WidgetBuilder> get routes => {
        // --- 1. Splash & Onboarding ---
        AppRoutes.splash: (_) => const SplashPage(),
        AppRoutes.onboarding: (_) => OnboardingPage(
              preferences: di.sl.isRegistered<AppPreferences>()
                  ? di.sl<AppPreferences>()
                  : null,
            ),

        // --- 2. Authentication Flow ---
        AppRoutes.signIn: (_) => BlocProvider(
              create: (_) => di.sl<AuthCubit>(),
              child: const SignInPage(),
            ),
        AppRoutes.signUp: (_) => const SignUpPage(),
        AppRoutes.forgotPassword: (_) => const ForgotPasswordPage(),
        AppRoutes.otpVerification: (context) {
          final email = ModalRoute.of(context)?.settings.arguments as String? ??
              'example123@gmail.com';
          return OtpVerificationPage(email: email);
        },
        AppRoutes.authSuccess: (_) => const AuthSuccessPage(),
        AppRoutes.permissions: (_) => const ProductActivationPage(),

        // --- 3. Core Shell & Main Navigation Tabs ---
        AppRoutes.home: (_) => const HomePage(initialIndex: 0),
        AppRoutes.serviceCentersList: (_) => const HomePage(initialIndex: 1),
        AppRoutes.preCheck: (_) => const HomePage(initialIndex: 2),
        AppRoutes.scan: (_) => const HomePage(initialIndex: 2),
        AppRoutes.activity: (_) => const HomePage(initialIndex: 3),
        AppRoutes.profile: (_) => const HomePage(initialIndex: 4),

        // --- 4. Sub-Screens & Dedicated Flow Views ---
        AppRoutes.reportSummary: (_) => const ReportSummaryPage(),
        AppRoutes.reportCauses: (_) => const ReportCausesPage(),
        AppRoutes.liveData: (_) => const LiveDataPage(),

        // --- 5. Workshops Flow ---
        AppRoutes.centerDetails: (context) {
          final center = ModalRoute.of(context)?.settings.arguments as ServiceCenterEntity?;
          return CenterDetailsPage(center: center);
        },
        AppRoutes.bookAppointment: (context) {
          final center = ModalRoute.of(context)?.settings.arguments as ServiceCenterEntity?;
          return BookAppointmentPage(center: center);
        },
        AppRoutes.bookingConfirm: (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
          return BookingConfirmPage(
            center: args?['center'] as ServiceCenterEntity?,
            schedule: args?['schedule'] as String?,
          );
        },
        AppRoutes.serviceCentersMap: (_) => const HomePage(initialIndex: 1),

        // --- 6. Vehicle Management & Profile Sub-screens ---
        AppRoutes.myVehicle: (_) => const MyVehiclePage(),
        AppRoutes.addVehicle: (_) => const AddVehiclePage(),
        AppRoutes.editVehicle: (_) => const EditVehiclePage(),
        AppRoutes.myDevice: (_) => const MyDevicePage(),
        AppRoutes.notifications: (_) => const NotificationsPage(),
        AppRoutes.helpSupport: (_) => const HelpSupportPage(),
        AppRoutes.privacyData: (_) => const PrivacyDataPage(),
        AppRoutes.languageUnits: (_) => const LanguageUnitsPage(),
        AppRoutes.editProfile: (_) => const EditProfilePage(),
      };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    if (settings.name == AppRoutes.splash) {
      return MaterialPageRoute(
        builder: (context) => SplashPage(
          onAnimationComplete: () => navigateAfterSplash(context),
        ),
      );
    }
    if (settings.name == AppRoutes.home && settings.arguments is int) {
      final initialIndex = settings.arguments as int;
      return MaterialPageRoute(
        builder: (_) => HomePage(initialIndex: initialIndex),
      );
    }
    return null;
  }
}
