import 'package:flutter/widgets.dart';
import 'package:obd_vision/core/utils/l10n_extensions.dart';

/// Translates mock/seed [ServiceCenterEntity] strings into Arabic when [context.isArabic]
/// is true, keeping domain/datasource fixtures untouched for existing unit tests.
class ServiceCenterL10n {
  ServiceCenterL10n._();

  static const Map<String, String> _centerNamesAr = {
    'Al-Nour Service Center': 'مركز النور للصيانة',
    'Speed Auto Care': 'سبيد للعناية بالسيارات',
    'Delta Garage': 'جراج الدلتا',
    'Precision Tune Auto Care': 'بريسيجن تيون لصيانة السيارات',
  };

  static const Map<String, String> _workingHoursAr = {
    'Open until 8 PM': 'مفتوح حتى 8 مساءً',
    'Open until 6 PM': 'مفتوح حتى 6 مساءً',
    'Open until 7 PM': 'مفتوح حتى 7 مساءً',
    'Closed, opens 9 AM': 'مغلق · يفتح 9 صباحاً',
  };

  static const Map<String, String> _addressesAr = {
    'Plot 14, Auto District, Cairo': 'قطعة 14، الحي الترفيهي للسيارات، القاهرة',
    'Ring Road Exit 8, Giza': 'مخرج 8 الطريق الدائري، الجيزة',
    'Nasr City, Zone 6': 'مدينة نصر، الحي السادس',
    'Sheraton Heliopolis': 'شيراتون مصر الجديدة',
    'Cairo': 'القاهرة',
  };

  static String name(BuildContext context, String raw) {
    if (!context.isArabic) return raw;
    return _centerNamesAr[raw] ?? raw;
  }

  static String workingHours(BuildContext context, String raw) {
    final l10n = context.l10n;
    if (raw == 'Open now') return l10n.openNowStatus;
    if (raw == 'Open now · Closes 8:00 PM') return l10n.openNowCloses8Pm;
    if (!context.isArabic) return raw;
    return _workingHoursAr[raw] ?? raw;
  }

  static String address(BuildContext context, String raw) {
    if (!context.isArabic) return raw;
    return _addressesAr[raw] ?? raw;
  }

  static String distance(BuildContext context, String raw) {
    if (!context.isArabic) return raw;
    return raw.replaceAll(' km', ' كم');
  }

  static String tag(BuildContext context, String raw) {
    final l10n = context.l10n;
    if (!context.isArabic) return raw;
    switch (raw) {
      case 'Engine':
        return 'محرك';
      case 'Electrical':
        return l10n.specialtyElectrical;
      case 'Compatible':
        return l10n.compatibleBadge;
      case 'Brakes':
        return l10n.specialtyBrakes;
      case 'AC':
        return 'تكييف';
      case 'Tires':
        return 'إطارات';
      case 'Transmission':
        return 'ناقل حركة';
      case 'Suspension':
        return 'عفشة وتعليق';
      default:
        return raw;
    }
  }
}
