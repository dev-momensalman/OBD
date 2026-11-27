import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:obd_vision/core/utils/app_actions.dart';
import 'package:obd_vision/core/utils/l10n_extensions.dart';
import 'package:obd_vision/injection_container.dart' as di;
import '../../../../core/constants/app_routes.dart';
import '../bloc/auth_cubit.dart';
import '../bloc/auth_state.dart';

/// OTP Verification Page wired cleanly to Supabase Auth verifyOTP & resend.
class OtpVerificationPage extends StatelessWidget {
  final String email;

  const OtpVerificationPage({
    super.key,
    this.email = 'example123@gmail.com',
  });

  @override
  Widget build(BuildContext context) {
    try {
      context.read<AuthCubit>();
      return _OtpVerificationView(email: email);
    } catch (_) {
      if (di.sl.isRegistered<AuthCubit>()) {
        return BlocProvider<AuthCubit>(
          create: (_) => di.sl<AuthCubit>(),
          child: _OtpVerificationView(email: email),
        );
      }
      return _OtpVerificationView(email: email);
    }
  }
}

class _OtpVerificationView extends StatefulWidget {
  final String email;

  const _OtpVerificationView({required this.email});

  @override
  State<_OtpVerificationView> createState() => _OtpVerificationViewState();
}

class _OtpVerificationViewState extends State<_OtpVerificationView> {
  static const int _otpLength = 6;
  late final List<TextEditingController> _controllers =
      List.generate(_otpLength, (_) => TextEditingController());
  late final List<FocusNode> _focusNodes =
      List.generate(_otpLength, (_) => FocusNode());

  int _resendSeconds = 45;
  Timer? _timer;
  String? _localErrorMessage;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _resendSeconds = 45);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      if (_resendSeconds > 0) {
        setState(() => _resendSeconds--);
      } else {
        t.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _onSubmitPressed() {
    setState(() => _localErrorMessage = null);
    final code = _controllers.map((c) => c.text.trim()).join();

    if (code.length < _otpLength) {
      setState(() => _localErrorMessage = context.l10n.otp6InvalidError);
      return;
    }

    try {
      context.read<AuthCubit>().verifyEmailOtp(
            email: widget.email,
            token: code,
          );
    } catch (_) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.signIn);
    }
  }

  void _onResendPressed() {
    _startTimer();
    try {
      context.read<AuthCubit>().resendSignUpOtp(email: widget.email);
    } catch (_) {}
  }

  Widget _buildScaffold(BuildContext context, {bool isLoading = false, String? remoteError}) {
    final displayError = _localErrorMessage ?? remoteError;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            context.backIcon,
            color: const Color(0xFF0F172A),
            size: 20,
          ),
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
              const SizedBox(height: 16),
              Text(
                context.l10n.otpVerificationTitle,
                style: GoogleFonts.inter(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF242424),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                context.l10n.otp6DigitInstruction,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  height: 1.4,
                  color: const Color(0xFF64748B),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                widget.email,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF003FB8),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 36),
              Directionality(
                textDirection: TextDirection.ltr,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(_otpLength, (index) {
                    return Container(
                      width: 46,
                      height: 58,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _controllers[index].text.isNotEmpty
                              ? const Color(0xFF003FB8)
                              : const Color(0xFFCBD5E1),
                          width: _controllers[index].text.isNotEmpty ? 2 : 1,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: TextField(
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0F172A),
                        ),
                        decoration: const InputDecoration(
                          counterText: '',
                          border: InputBorder.none,
                        ),
                        onChanged: (val) {
                          if (val.isNotEmpty && index < _otpLength - 1) {
                            _focusNodes[index + 1].requestFocus();
                          } else if (val.isEmpty && index > 0) {
                            _focusNodes[index - 1].requestFocus();
                          }
                          setState(() {});
                        },
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 24),
              if (displayError != null) ...[
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEE2E2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFFCA5A5)),
                  ),
                  child: Text(
                    displayError,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFDC2626),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    context.l10n.didNotReceiveOtpPrefix,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  if (_resendSeconds > 0)
                    Text(
                      context.l10n.resendInSeconds(_resendSeconds),
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF003FB8),
                      ),
                    )
                  else
                    GestureDetector(
                      onTap: _onResendPressed,
                      child: Text(
                        context.l10n.resendCodeButton,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF003FB8),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 36),
              ElevatedButton(
                onPressed: isLoading ? null : _onSubmitPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF003FB8),
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        context.l10n.submitButton,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRoutes.signIn,
                    (route) => false,
                  );
                },
                child: Text(
                  context.l10n.alreadyVerifiedSignIn,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF003FB8),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    try {
      context.read<AuthCubit>();
      return BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              AppRoutes.authSuccess,
              (route) => false,
            );
          } else if (state is AuthOtpResent) {
            AppActions.showSnack(
              context,
              context.isArabic
                  ? 'تمت إعادة إرسال رمز التحقق إلى بريدك'
                  : 'Verification code resent to ${state.email}',
            );
          }
        },
        builder: (context, state) {
          return _buildScaffold(
            context,
            isLoading: state is AuthLoading,
            remoteError: state is AuthError ? state.message : null,
          );
        },
      );
    } catch (_) {
      return _buildScaffold(context);
    }
  }
}
