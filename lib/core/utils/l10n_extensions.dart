import 'package:flutter/material.dart';
import 'package:obd_vision/l10n/app_localizations.dart';
import 'package:obd_vision/l10n/app_localizations_en.dart';

/// Safe localization and BiDi helpers.
///
/// Falls back to [AppLocalizationsEn] when a widget is pumped in isolation
/// without localization delegates (e.g., standalone widget tests).
extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n =>
      AppLocalizations.of(this) ?? AppLocalizationsEn();

  bool get isArabic => l10n.localeName.startsWith('ar');

  /// Direction-aware back chevron/arrow icon.
  IconData get backIcon => isArabic
      ? Icons.arrow_forward_ios_rounded
      : Icons.arrow_back_ios_new_rounded;

  /// Direction-aware forward chevron icon.
  IconData get forwardChevronIcon =>
      isArabic ? Icons.chevron_left_rounded : Icons.chevron_right_rounded;
}

/// Const-friendly RTL-aware back arrow icon.
class RtlBackIcon extends StatelessWidget {
  final Color? color;
  final double? size;

  const RtlBackIcon({super.key, this.color, this.size});

  @override
  Widget build(BuildContext context) {
    return Icon(context.backIcon, color: color, size: size);
  }
}

/// Const-friendly RTL-aware forward chevron icon.
class RtlForwardChevron extends StatelessWidget {
  final Color? color;
  final double? size;

  const RtlForwardChevron({super.key, this.color, this.size});

  @override
  Widget build(BuildContext context) {
    return Icon(context.forwardChevronIcon, color: color, size: size);
  }
}

/// Detects RTL text direction when server/AI content contains Arabic characters.
TextDirection detectTextDirection(String text) {
  final hasArabic = RegExp(r'[\u0600-\u06FF]').hasMatch(text);
  return hasArabic ? TextDirection.rtl : TextDirection.ltr;
}
