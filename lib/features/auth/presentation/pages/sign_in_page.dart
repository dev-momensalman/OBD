import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:obd_vision/core/constants/app_assets.dart';
import 'package:obd_vision/core/constants/app_routes.dart';

import '../bloc/auth_cubit.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/social_auth_button.dart';
import '../widgets/terms_agreement_checkbox.dart';

/// Pixel-Perfect Sign In Page strictly adhering to Figma Node 67:8513 (Canvas 390x844).
class SignInPage extends StatefulWidget {
  final VoidCallback? onSignInSuccess;

  const SignInPage({super.key, this.onSignInSuccess});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isPasswordVisible = false;
  bool _isAgreedToTerms = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSignIn() {
    FocusScope.of(context).unfocus();
    context.read<AuthCubit>().signInWithEmail(
          email: _emailController.text,
          password: _passwordController.text,
          agreedToTerms: _isAgreedToTerms,
        );
  }

  void _onGoogleSignIn() {
    FocusScope.of(context).unfocus();
    context.read<AuthCubit>().signInWithGoogle(
          agreedToTerms: _isAgreedToTerms,
        );
  }

  void _onFacebookSignIn() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Facebook Sign-In coming soon!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: const Color(0xFFE53935),
                behavior: SnackBarBehavior.floating,
              ),
            );
          } else if (state is Authenticated) {
            if (widget.onSignInSuccess != null) {
              widget.onSignInSuccess!();
            } else {
              Navigator.of(context).pushReplacementNamed(AppRoutes.home);
            }
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              children: [
                // 1. Top Ambient Aura & Logo Header (246px)
                const AuthHeader(title: 'Sign in to your Account'),

                // 2. White Card Container (Main Frame: top corner radius 48)
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(48),
                      topRight: Radius.circular(48),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 16,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 28),

                          // Email Field (Figma Node 497:3239)
                          AuthTextField(
                            label: 'Email address',
                            hintText: 'Enter your email address',
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 16),

                          // Password Field (Figma Node 497:3256)
                          AuthTextField(
                            label: 'Password',
                            hintText: 'Enter your password',
                            controller: _passwordController,
                            isPassword: true,
                            isPasswordVisible: _isPasswordVisible,
                            onTogglePasswordVisibility: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                          const SizedBox(height: 10),

                          // "Forgot password?" Action (Figma Node 492:2964)
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed(AppRoutes.forgotPassword);
                              },
                              child: Text(
                                'Forgot password?',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF757575),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),

                          // Terms & Privacy Agreement Checkbox (Figma Node 77:235)
                          TermsAgreementCheckbox(
                            isAgreed: _isAgreedToTerms,
                            onChanged: (val) {
                              setState(() {
                                _isAgreedToTerms = val;
                              });
                            },
                            onUserAgreementTap: () {},
                            onPrivacyPolicyTap: () {},
                          ),
                          const SizedBox(height: 24),

                          // "Sign in" Primary Button (Figma Node 492:3010)
                          SizedBox(
                            height: 48,
                            child: ElevatedButton(
                              onPressed: isLoading ? null : _onSignIn,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF003FB8),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
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
                                      'Sign in',
                                      style: GoogleFonts.inter(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // "other way to sign in" (Figma Node 77:238)
                          Center(
                            child: Text(
                              'other way to sign in',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                                color: const Color(0xFF757575),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Social Logins (Google & Facebook / Figma Node 492:2990 & 492:2984)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SocialAuthButton(
                                onTap: _onGoogleSignIn,
                                icon: Image.asset(
                                  AppAssets.signinIllustration,
                                  width: 26,
                                  height: 26,
                                ),
                              ),
                              const SizedBox(width: 20),
                              SocialAuthButton(
                                onTap: _onFacebookSignIn,
                                icon: SvgPicture.asset(
                                  'assets/icons/signin_icon_9.svg',
                                  width: 12,
                                  height: 22,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // "Don't have an account? Create Account" (Figma Node 77:247 & 492:3015)
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Don’t have an account? ',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                    color: const Color(0xFF757575),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context)
                                        .pushNamed(AppRoutes.signUp);
                                  },
                                  child: Text(
                                    'Create Account',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF002264),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 36),
                        ],
                      ),
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
