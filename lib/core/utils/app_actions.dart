import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:obd_vision/core/utils/l10n_extensions.dart';

/// Shared interactive helper sheets and clipboard/notification actions so
/// buttons across Auth, Diagnostics, Workshops, and Profile perform real work.
class AppActions {
  AppActions._();

  static void showSnack(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.inter()),
        backgroundColor:
            isError ? const Color(0xFFDC2626) : const Color(0xFF003FB8),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static Future<void> copyText(
    BuildContext context,
    String text, {
    String? feedback,
  }) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (!context.mounted) return;
    showSnack(context, feedback ?? context.l10n.copiedToClipboard);
  }

  static Future<void> showLegalSheet(
    BuildContext context, {
    required bool isPrivacyPolicy,
  }) {
    final l10n = context.l10n;
    final arabic = context.isArabic;
    final title = isPrivacyPolicy ? l10n.privacyPolicy : l10n.userAgreement;
    final body = isPrivacyPolicy
        ? (arabic
            ? 'تحترم منصة OBD Vision خصوصية بيانات مركبتك. تُستخدم قراءات الحساسات وأكواد الأعطال حصرياً لتوليد التشخيص الذكي ومشاركتها بموافقتك عند حجز مركز صيانة. لا يتم بيع بياناتك لأي طرف ثالث، ويمكنك تصدير بياناتك أو حذف حسابك في أي وقت من صفحة الخصوصية.'
            : 'OBD Vision encrypts your account and vehicle diagnostic records. ECU telemetry and DTCs are used strictly to generate AI-assisted diagnostics and are shared with service centers only when you choose to book an appointment. You may export or delete your account data anytime from Profile > Privacy & Data.')
        : (arabic
            ? 'باستخدامك لتطبيق OBD Vision فإنك توافق على أن نتائج التشخيص المدعومة بالذكاء الاصطناعي هي إرشادات احتمالية مساعدة ولا تغني عن الفحص الفني المباشر بواسطة فني سيارات معتمد قبل استبدال أي قطعة.'
            : 'By using OBD Vision, you acknowledge that AI diagnostic findings are probabilistic guidance derived from available OBD-II telemetry and must be verified by a certified automotive technician before part replacement.');

    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetCtx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.of(sheetCtx).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  body,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    height: 1.6,
                    color: const Color(0xFF475569),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.of(sheetCtx).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF003FB8),
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(l10n.closeButton),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
