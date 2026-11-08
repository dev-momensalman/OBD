/// Declarative Application Route Names for OBD Vision
class AppRoutes {
  AppRoutes._();

  // Splash & Onboarding
  static const String splash = '/';
  static const String onboarding = '/onboarding';

  // Authentication Flow
  static const String signIn = '/sign-in';
  static const String signUp = '/sign-up';
  static const String forgotPassword = '/forgot-password';
  static const String otpVerification = '/otp-verification';
  static const String authSuccess = '/auth-success';

  // Permissions Flow
  static const String permissions = '/permissions';

  // Home & Navigation
  static const String home = '/home';
  static const String activity = '/activity';

  // OBD Diagnostics Flow
  static const String preCheck = '/pre-check';
  static const String scan = '/scan';
  static const String scanResult = '/scan-result';
  static const String reportSummary = '/report-summary';
  static const String reportCauses = '/report-causes';
  static const String liveData = '/live-data';

  // Vehicle Management
  static const String myVehicle = '/my-vehicle';
  static const String addVehicle = '/add-vehicle';
  static const String editVehicle = '/edit-vehicle';

  // Service Centers & Appointments
  static const String serviceCentersList = '/service-centers-list';
  static const String serviceCentersMap = '/service-centers-map';
  static const String centerDetails = '/center-details';
  static const String bookAppointment = '/book-appointment';
  static const String bookingConfirm = '/booking-confirm';

  // Profile & Settings
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String myDevice = '/my-device';
  static const String notifications = '/notifications';
  static const String helpSupport = '/help-support';
  static const String privacyData = '/privacy-data';
  static const String languageUnits = '/language-units';
}
