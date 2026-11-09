import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Terms Agreement Checkbox matching Figma Node 77:235:
/// "I’ve read and agreed to User Agreement and Privacy Policy"
class TermsAgreementCheckbox extends StatelessWidget {
  final bool isAgreed;
  final ValueChanged<bool> onChanged;
  final VoidCallback? onUserAgreementTap;
  final VoidCallback? onPrivacyPolicyTap;

  const TermsAgreementCheckbox({
    super.key,
    required this.isAgreed,
    required this.onChanged,
    this.onUserAgreementTap,
    this.onPrivacyPolicyTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Custom 24x24 circular checkbox matching Figma Node 77:236
        GestureDetector(
          key: const ValueKey('terms_checkbox'),
          onTap: () => onChanged(!isAgreed),
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isAgreed ? const Color(0xFF003FB8) : Colors.white,
              border: Border.all(
                color: isAgreed ? const Color(0xFF003FB8) : const Color(0xFFBEBEBE),
                width: 1.5,
              ),
            ),
            child: isAgreed
                ? const Icon(
                    Icons.check,
                    size: 16,
                    color: Colors.white,
                  )
                : null,
          ),
        ),
        const SizedBox(width: 10),

        // Rich Text Agreement
        Expanded(
          child: Text.rich(
            TextSpan(
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF757575),
                height: 1.35,
              ),
              children: [
                const TextSpan(text: 'I’ve read and agreed to '),
                WidgetSpan(
                  child: GestureDetector(
                    onTap: onUserAgreementTap,
                    child: Text(
                      'User Agreement',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF002264),
                        decoration: TextDecoration.underline,
                        decorationColor: const Color(0xFF002264),
                      ),
                    ),
                  ),
                ),
                const TextSpan(text: ' and '),
                WidgetSpan(
                  child: GestureDetector(
                    onTap: onPrivacyPolicyTap,
                    child: Text(
                      'Privacy Policy',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF002264),
                        decoration: TextDecoration.underline,
                        decorationColor: const Color(0xFF002264),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
