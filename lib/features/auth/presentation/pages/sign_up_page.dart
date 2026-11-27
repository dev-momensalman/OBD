import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:obd_vision/core/constants/app_routes.dart';
import 'package:obd_vision/core/utils/app_actions.dart';
import 'package:obd_vision/core/utils/l10n_extensions.dart';
import 'package:obd_vision/injection_container.dart' as di;
import '../bloc/auth_cubit.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/terms_agreement_checkbox.dart';

/// Authentic Sign Up Page matching Figma Node 77:249 & `AUTH_API.md` §2.
class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    try {
      context.read<AuthCubit>();
      return const _SignUpView();
    } catch (_) {
      return BlocProvider<AuthCubit>(
        create: (_) => di.sl<AuthCubit>(),
        child: const _SignUpView(),
      );
    }
  }
}

class _SignUpView extends StatefulWidget {
  const _SignUpView();

  @override
  State<_SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<_SignUpView> {
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _hasAgreedToTerms = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onSignUpPressed() {
    FocusScope.of(context).unfocus();
    context.read<AuthCubit>().signUpWithEmail(
          fullName: _fullNameController.text,
          email: _emailController.text,
          password: _passwordController.text,
          confirmPassword: _confirmPasswordController.text,
          phone: _phoneController.text,
          agreedToTerms: _hasAgreedToTerms,
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              AppRoutes.home,
              (route) => false,
            );
          } else if (state is AuthConfirmationRequired) {
            Navigator.of(context).pushNamed(
              AppRoutes.otpVerification,
              arguments: state.email,
            );
          } else if (state is AuthError) {
            AppActions.showSnack(context, state.message, isError: true);
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;
          final errorMessage = state is AuthError ? state.message : null;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                AuthHeader(title: l10n.createAccountTitle),
                Transform.translate(
                  offset: const Offset(0, -20),
                  child: Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x14000000),
                          blurRadius: 16,
                          offset: Offset(0, -4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Full Name (Required by AUTH_API.md §2)
                        AuthTextField(
                          label: l10n.fullNameLabel,
                          hintText: l10n.enterFullNameHint,
                          controller: _fullNameController,
                        ),
                        const SizedBox(height: 14),

                        // Phone (Optional per AUTH_API.md §2)
                        AuthTextField(
                          label: l10n.phoneOptionalLabel,
                          hintText: l10n.enterPhoneHint,
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 14),

                        // Email Field
                        AuthTextField(
                          label: l10n.emailAddressCapLabel,
                          hintText: l10n.enterEmailHint,
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 14),

                        // Password Field (min 8 chars per AUTH_API.md §2)
                        AuthTextField(
                          label: l10n.passwordLabel,
                          hintText: l10n.enterPasswordHint,
                          controller: _passwordController,
                          isPassword: true,
                          isPasswordVisible: _isPasswordVisible,
                          onTogglePasswordVisibility: () {
                            setState(
                                () => _isPasswordVisible = !_isPasswordVisible);
                          },
                        ),
                        const SizedBox(height: 14),

                        // Confirm Password Field
                        AuthTextField(
                          label: l10n.confirmPasswordLabel,
                          hintText: l10n.enterConfirmPasswordHint,
                          controller: _confirmPasswordController,
                          isPassword: true,
                          isPasswordVisible: _isConfirmPasswordVisible,
                          onTogglePasswordVisibility: () {
                            setState(() => _isConfirmPasswordVisible =
                                !_isConfirmPasswordVisible);
                          },
                        ),
                        const SizedBox(height: 18),

                        // Terms Agreement Checkbox
                        TermsAgreementCheckbox(
                          isAgreed: _hasAgreedToTerms,
                          onChanged: (val) {
                            setState(() => _hasAgreedToTerms = val);
                          },
                          onUserAgreementTap: () => AppActions.showLegalSheet(
                            context,
                            isPrivacyPolicy: false,
                          ),
                          onPrivacyPolicyTap: () => AppActions.showLegalSheet(
                            context,
                            isPrivacyPolicy: true,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Error Banner
                        if (errorMessage != null) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEE2E2),
                              borderRadius: BorderRadius.circular(8),
                              border:
                                  Border.all(color: const Color(0xFFFCA5A5)),
                            ),
                            child: Text(
                              errorMessage,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFFDC2626),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],

                        // Primary Sign Up Button
                        ElevatedButton(
                          onPressed: isLoading ? null : _onSignUpPressed,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF003FB8),
                            foregroundColor: Colors.white,
                            minimumSize: const Size.fromHeight(52),
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
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : Text(
                                  l10n.signUpButton,
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                        const SizedBox(height: 24),

                        // Already have an account? Sign in
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              l10n.alreadyHaveAccountPrefix,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: const Color(0xFF757575),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .pushReplacementNamed(AppRoutes.signIn);
                              },
                              child: Text(
                                l10n.signInButton,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF003FB8),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
