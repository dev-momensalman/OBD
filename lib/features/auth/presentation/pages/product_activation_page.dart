import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:obd_vision/core/services/app_preferences.dart';
import 'package:obd_vision/core/utils/l10n_extensions.dart';
import 'package:obd_vision/injection_container.dart' as di;
import '../../../../core/constants/app_routes.dart';

/// Authentic Product Activation Page matching Figma Node 118:74
class ProductActivationPage extends StatefulWidget {
  const ProductActivationPage({super.key});

  @override
  State<ProductActivationPage> createState() => _ProductActivationPageState();
}

class _ProductActivationPageState extends State<ProductActivationPage>
    with SingleTickerProviderStateMixin {
  final _serialController = TextEditingController();
  late AnimationController _laserController;
  late Animation<double> _laserAnimation;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _laserController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _laserAnimation = Tween<double>(begin: 0.1, end: 0.9).animate(
      CurvedAnimation(parent: _laserController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _serialController.dispose();
    _laserController.dispose();
    super.dispose();
  }

  void _onActivate() {
    setState(() => _errorMessage = null);
    final serial = _serialController.text.trim();

    if (serial.isEmpty || serial.replaceAll(' ', '').length < 8) {
      setState(() => _errorMessage = context.l10n.serialNumberInvalidError);
      return;
    }

    if (di.sl.isRegistered<AppPreferences>()) {
      di.sl<AppPreferences>().setActivatedSerial(serial);
    }

    // Success -> Navigate to home
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.home,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(context.backIcon,
              color: const Color(0xFF0F172A), size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Headline
              Center(
                child: Text(
                  context.l10n.activateProductTitle,
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF242424),
                  ),
                ),
              ),
              const SizedBox(height: 6),

              Center(
                child: Text(
                  context.l10n.letsGetStarted,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF003FB8),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 2. Stepper Indicator: 1 ── 2 ── 3 (SETUP - 1 OF 3)
              Text(
                context.l10n.setupStep1,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: const Color(0xFF94A3B8),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStepCircle('1', isActive: true),
                  _buildStepLine(isActive: false),
                  _buildStepCircle('2', isActive: false),
                  _buildStepLine(isActive: false),
                  _buildStepCircle('3', isActive: false),
                ],
              ),
              const SizedBox(height: 20),

              // 3. Instruction
              Text(
                context.l10n.scanQrInstruction,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  height: 1.4,
                  color: const Color(0xFF575555),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // 4. Scanner View with Corner Brackets & Laser Line
              Center(
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Stack(
                    children: [
                      // Target QR Icon in Center
                      const Center(
                        child: Icon(
                          Icons.qr_code_2_rounded,
                          size: 100,
                          color: Color(0xFF1E293B),
                        ),
                      ),

                      // Animated Laser Scan Line
                      AnimatedBuilder(
                        animation: _laserAnimation,
                        builder: (context, _) {
                          return Positioned(
                            top: 200 * _laserAnimation.value,
                            left: 16,
                            right: 16,
                            child: Container(
                              height: 2,
                              decoration: BoxDecoration(
                                color: const Color(0xFF003FB8),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF003FB8)
                                        .withValues(alpha: 0.8),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                      // Corner Targeting Brackets
                      _buildCorner(top: 8, left: 8, isTop: true, isLeft: true),
                      _buildCorner(top: 8, right: 8, isTop: true, isLeft: false),
                      _buildCorner(bottom: 8, left: 8, isTop: false, isLeft: true),
                      _buildCorner(bottom: 8, right: 8, isTop: false, isLeft: false),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              Center(
                child: Text(
                  context.l10n.positionQrInsideFrame,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF575555),
                  ),
                ),
              ),
              Center(
                child: Text(
                  context.l10n.scanningAutomatically,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 5. Divider "Or enter manually"
              Row(
                children: [
                  const Expanded(child: Divider(color: Color(0xFFE2E8F0))),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      context.l10n.orEnterManually,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: const Color(0xFF94A3B8),
                      ),
                    ),
                  ),
                  const Expanded(child: Divider(color: Color(0xFFE2E8F0))),
                ],
              ),
              const SizedBox(height: 16),

              // 6. 14-Digit Serial Number Input
              Text(
                context.l10n.fourteenDigitSerialLabel,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF575555),
                ),
              ),
              const SizedBox(height: 6),
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFCBD5E1)),
                ),
                child: TextField(
                  controller: _serialController,
                  keyboardType: TextInputType.text,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.5,
                  ),
                  decoration: InputDecoration(
                    hintText: '0000 0000 0000 00',
                    hintStyle: GoogleFonts.inter(
                      fontSize: 13,
                      color: const Color(0xFF94A3B8),
                      letterSpacing: 1.5,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Error Banner
              if (_errorMessage != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEE2E2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFFCA5A5)),
                  ),
                  child: Text(
                    _errorMessage!,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFDC2626),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 12),
              ],

              // 7. Activate Button
              ElevatedButton(
                onPressed: _onActivate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF003FB8),
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 2,
                ),
                child: Text(
                  context.l10n.activateWithSerialButton,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 8. Guest Bypass
              Center(
                child: GestureDetector(
                  onTap: () {
                    if (di.sl.isRegistered<AppPreferences>()) {
                      di.sl<AppPreferences>().setGuestSession(true);
                    }
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRoutes.home,
                      (route) => false,
                    );
                  },
                  child: RichText(
                    text: TextSpan(
                      text: context.l10n.noProductNearbyPrefix,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF64748B),
                      ),
                      children: [
                        TextSpan(
                          text: context.l10n.continueAsGuest,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF003FB8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepCircle(String number, {required bool isActive}) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? const Color(0xFF003FB8) : const Color(0xFFE2E8F0),
      ),
      alignment: Alignment.center,
      child: Text(
        number,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: isActive ? Colors.white : const Color(0xFF64748B),
        ),
      ),
    );
  }

  Widget _buildStepLine({required bool isActive}) {
    return Container(
      width: 48,
      height: 2,
      color: isActive ? const Color(0xFF003FB8) : const Color(0xFFE2E8F0),
    );
  }

  Widget _buildCorner({
    double? top,
    double? bottom,
    double? left,
    double? right,
    required bool isTop,
    required bool isLeft,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          border: Border(
            top: isTop
                ? const BorderSide(color: Color(0xFF003FB8), width: 3)
                : BorderSide.none,
            bottom: !isTop
                ? const BorderSide(color: Color(0xFF003FB8), width: 3)
                : BorderSide.none,
            left: isLeft
                ? const BorderSide(color: Color(0xFF003FB8), width: 3)
                : BorderSide.none,
            right: !isLeft
                ? const BorderSide(color: Color(0xFF003FB8), width: 3)
                : BorderSide.none,
          ),
        ),
      ),
    );
  }
}
