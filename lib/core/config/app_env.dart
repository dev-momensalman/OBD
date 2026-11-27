/// Centralized Runtime Environment Configuration for OBD Vision.
///
/// Only public/publishable client credentials belong here (never service-role secrets).
class AppEnv {
  AppEnv._();

  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://euekmlrxktgywjdzclvl.supabase.co',
  );

  static const String supabasePublishableKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'sb_publishable_hC8BINxgraccDlWXRIEtFg_ZZXXPTim',
  );

  static const String aiEngineBaseUrl = String.fromEnvironment(
    'AI_ENGINE_BASE_URL',
    defaultValue: 'https://obd-ai-engine.vercel.app',
  );

  static const String resetPasswordRedirectUrl = 'obdvision://reset-password';

  static const String loginCallbackUrl = 'obdvision://login-callback';

  static const bool useRealAuth = bool.fromEnvironment(
    'USE_REAL_AUTH',
    defaultValue: true,
  );

  static const bool useRealAi = bool.fromEnvironment(
    'USE_REAL_AI',
    defaultValue: true,
  );
}
