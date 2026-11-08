/// Application Asset Constants
/// Contains paths to all isolated inner illustrations, artwork, and icons extracted from the Figma Design System.
class AppAssets {
  AppAssets._();

  // Base paths
  static const String _imagesPath = 'assets/images';
  static const String _iconsPath = 'assets/icons';
  static const String _soundsPath = 'assets/sounds';

  // Audio / Sound FX
  static const String carStartupSound = '$_soundsPath/car_startup.mp3';

  // Splash & Brand Assets
  static const String appIcon = '$_imagesPath/app_icon.png';
  static const String appIconForeground = '$_imagesPath/app_icon_foreground.png';
  static const String splashLogoFull = '$_imagesPath/splash_logo_full.png';
  static const String appLogoMark = '$_imagesPath/app_logo_mark.png';
  static const String carSilhouette = '$_imagesPath/car_silhouette.png';

  // Onboarding Illustrations
  static const String onboarding1Illustration = '$_imagesPath/onboarding_1_illustration.png';
  static const String onboarding2Illustration = '$_imagesPath/onboarding_2_illustration.png';
  static const String onboarding3Illustration = '$_imagesPath/onboarding_3_illustration.png';
  static const String onboarding5Illustration = '$_imagesPath/onboarding_5_illustration.png';

  // Auth & Verification Illustrations
  static const String verificationSuccess = '$_imagesPath/verification_success_illustration.png';
  static const String otpIllustration = '$_imagesPath/otp_verification_illustration.png';
  static const String signinIllustration = '$_imagesPath/signin_raw1.png';

  // Permissions Illustrations
  static const String permissionLocation = '$_imagesPath/permission_location.png';
  static const String permissionBluetooth = '$_imagesPath/permission_bluetooth.png';
  static const String permissionNotification = '$_imagesPath/permission_notification.png';
  static const String permissionStorage = '$_imagesPath/permission_storage.png';

  // Booking & Service Centers Images
  static const String bookingSuccessSparkles = '$_imagesPath/booking_success_sparkles.png';
  static const String serviceCenter1 = '$_imagesPath/service_center_raw1.jpeg';
  static const String serviceCenter2 = '$_imagesPath/service_center_raw2.jpeg';
  static const String serviceCenter3 = '$_imagesPath/service_center_raw3.jpeg';

  // Dashboard & Vehicle
  static const String vehicleModel = '$_imagesPath/home_raw1.png';

  // Vector Icons (SVGs)
  static const String splashLogoSvg = '$_iconsPath/splash_asset_4.svg';
  static const String splashIconSvg = '$_iconsPath/splash_asset_5.svg';
  static const String homeIconSvg = '$_iconsPath/home_icon_1.svg';
  static const String obdScanIconSvg = '$_iconsPath/home_icon_6.svg';
  static const String diagnosticsIconSvg = '$_iconsPath/home_icon_8.svg';
  static const String serviceCenterIconSvg = '$_iconsPath/service_icon_1.svg';
}
