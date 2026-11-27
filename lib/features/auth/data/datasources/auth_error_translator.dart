/// Exception carrying explicit localized English & Arabic messages.
class LocalizedAuthException implements Exception {
  final String en;
  final String ar;

  const LocalizedAuthException({required this.en, required this.ar});

  String messageFor({required bool isArabic}) => isArabic ? ar : en;

  @override
  String toString() => en;
}

/// Signals an external browser OAuth flow was launched and awaits deep-link return.
class OAuthPendingException extends LocalizedAuthException {
  const OAuthPendingException()
      : super(
          en: 'Complete sign-in in your browser to return automatically.',
          ar: 'أكمل تسجيل الدخول في المتصفح للعودة للتطبيق تلقائياً.',
        );
}

/// Translates Supabase AuthException messages into clean user-facing strings
/// matching backend `AUTH_API.md` §7 guidelines in both Arabic and English.
String translateAuthErrorMessage(String rawMessage, {required bool isArabic}) {
  final msg = rawMessage.toLowerCase();

  if (msg.contains('invalid') && msg.contains('credential')) {
    return isArabic ? 'بيانات الدخول غير صحيحة' : 'Invalid email or password.';
  }
  if (msg.contains('user already registered')) {
    return isArabic
        ? 'البريد الإلكتروني مسجل من قبل'
        : 'This email is already registered.';
  }
  if (msg.contains('email not confirmed')) {
    return isArabic
        ? 'لازم تأكد الإيميل الأول'
        : 'Please confirm your email address first.';
  }
  if (msg.contains('password') && msg.contains('at least')) {
    return isArabic
        ? 'الباسوورد لازم يكون 8 حروف على الأقل'
        : 'Password must be at least 8 characters.';
  }
  if (msg.contains('signup') && msg.contains('disabled')) {
    return isArabic
        ? 'التسجيل متوقف مؤقتاً'
        : 'Sign-ups are temporarily disabled.';
  }
  if (msg.contains('rate limit') || msg.contains('too many')) {
    return isArabic
        ? 'حاولت كتير قوي، استنى دقيقة وجرّب تاني'
        : 'Too many attempts. Please wait a minute and try again.';
  }
  if (msg.contains('banned') || msg.contains('disabled')) {
    return isArabic
        ? 'الحساب موقوف، كلم الدعم'
        : 'This account is suspended. Please contact support.';
  }
  if (msg.contains('network') ||
      msg.contains('fetch') ||
      msg.contains('socket') ||
      msg.contains('connection')) {
    return isArabic
        ? 'مشكلة في الإنترنت، جرّب تاني'
        : 'Network error. Check your connection and try again.';
  }
  if (msg.contains('same_password') || msg.contains('different from the old')) {
    return isArabic
        ? 'اختر كلمة مرور جديدة مختلفة عن الحالية'
        : 'Please choose a new password different from the old one.';
  }
  if (msg.contains('session') && msg.contains('missing')) {
    return isArabic
        ? 'انتهت صلاحية الرابط، اطلب رابط استعادة جديد'
        : 'Reset link expired or invalid. Please request a new one.';
  }

  return isArabic
      ? 'حصل خلل مؤقت، جرّب تاني بعد شوية'
      : 'Something went wrong temporarily. Please try again shortly.';
}
