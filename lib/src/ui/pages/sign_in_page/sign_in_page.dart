import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shortflix/core/utils/base_state.dart';
import 'package:shortflix/gen/colors.gen.dart';
import 'package:shortflix/l10n/app_localizations.dart';
import 'package:shortflix/src/services/navigation.dart';
import 'package:shortflix/src/services/routes.dart';
import 'package:shortflix/src/ui/pages/sign_in_page/sign_in_bloc.dart';
import 'package:shortflix/src/ui/pages/sign_in_page/sign_in_event.dart';
import 'package:shortflix/src/ui/pages/sign_in_page/sign_in_state.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _emailCtrl    = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscure = true;

  // ── Regex ────────────────────────────────────────────────────
  static final _emailRegex = RegExp(r'^[\w.+-]+@[\w-]+\.[a-zA-Z]{2,}$');
  static final _passwordRegex = RegExp(r'^.{6,}$'); // min 6 chars

  // ── Derived validation ───────────────────────────────────────
  bool get _emailValid  => _emailRegex.hasMatch(_emailCtrl.text.trim());
  bool get _passwordValid => _passwordRegex.hasMatch(_passwordCtrl.text);
  bool get _canSubmit   => _emailValid && _passwordValid;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<SignInBloc>();
    final l = AppLocalizations.of(context);

    return BlocListener<SignInBloc, SignInState>(
      listener: (context, state) {
        if (state is SignInSubmitState && state.state == BaseState.loaded) {
          Navigator.pushAndRemoveUntil(
            context,
            generateRoutes(RouteSettings(name: Navigation.homePage))!,
            (_) => false,
          );
        }
        if (state is SignInSubmitState && state.state == BaseState.error) {
          _showSnackbar(context, l.incorrectEmailOrPassword);
        }
        if (state is SignInNotSignedUpState) {
          Navigator.pushNamed(
            context,
            Navigation.signUpPage,
            arguments: {'email': state.email},
          );
        }
        if (state is SignInGoogleState && state.state == BaseState.loaded) {
          Navigator.pushAndRemoveUntil(
            context,
            generateRoutes(RouteSettings(name: Navigation.homePage))!,
            (_) => false,
          );
        }
        if (state is SignInGoogleState && state.state == BaseState.error) {
          _showSnackbar(
            context,
            state.errorMessage ?? l.googleSignInFailed,
          );
        }
        if (state is SignInAppleState && state.state == BaseState.loaded) {
          Navigator.pushAndRemoveUntil(
            context,
            generateRoutes(RouteSettings(name: Navigation.homePage))!,
            (_) => false,
          );
        }
        if (state is SignInAppleState && state.state == BaseState.error) {
          _showSnackbar(
            context,
            state.errorMessage ?? l.appleSignInFailed,
          );
        }
      },
      child: Scaffold(
        backgroundColor: ColorName.backgroundPrimary,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),
                _buildLogo(),
                const SizedBox(height: 40),
                _buildHeading(),
                const SizedBox(height: 32),
                _buildInputField(
                  label: l.emailLabel,
                  hint: l.emailHint,
                  icon: Icons.mail_outline_rounded,
                  ctrl: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  errorText: _emailCtrl.text.isNotEmpty && !_emailValid
                      ? l.emailError
                      : null,
                ),
                const SizedBox(height: 16),
                _buildInputField(
                  label: l.passwordLabel,
                  hint: '••••••••',
                  icon: Icons.lock_outline_rounded,
                  ctrl: _passwordCtrl,
                  obscure: _obscure,
                  errorText: _passwordCtrl.text.isNotEmpty && !_passwordValid
                      ? l.passwordError
                      : null,
                  suffix: GestureDetector(
                    onTap: () => setState(() => _obscure = !_obscure),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 14),
                      child: Icon(
                        _obscure
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: ColorName.contentSecondary,
                        size: 18,
                      ),
                    ),
                  ),
                ),
                // TODO: implement forgot password flow (backend + UI), then re-enable.
                // const SizedBox(height: 12),
                // Align(
                //   alignment: Alignment.centerRight,
                //   child: GestureDetector(
                //     behavior: HitTestBehavior.opaque,
                //     onTap: () {},
                //     child: Padding(
                //       padding: const EdgeInsets.symmetric(
                //         horizontal: 8,
                //         vertical: 12,
                //       ),
                //       child: Text(
                //         l.forgotPassword,
                //         style: TextStyle(
                //           color: ColorName.accent,
                //           fontSize: 13,
                //           fontWeight: FontWeight.w600,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                const SizedBox(height: 28),
                _buildSignInButton(bloc),
                const SizedBox(height: 20),
                _buildDivider(),
                const SizedBox(height: 20),
                _buildGoogleButton(bloc),
                if (Platform.isIOS) ...[
                  const SizedBox(height: 12),
                  _buildAppleButton(bloc),
                ],
                const SizedBox(height: 32),
                _buildSignUpRow(context),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────
  //  LOGO
  // ─────────────────────────────────────────
  Widget _buildLogo() {
    return Row(
      children: [
        Image.asset(
          'assets/images/916TV_transparent.png',
          width: 80,
          height: 80,
          fit: BoxFit.contain,
        ),
      ],
    );
  }

  // ─────────────────────────────────────────
  //  HEADING
  // ─────────────────────────────────────────
  Widget _buildHeading() {
    final l = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l.welcomeBack,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l.signInSubtitle,
          style: TextStyle(color: ColorName.contentSecondary, fontSize: 14),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────
  //  SIGN IN BUTTON
  // ─────────────────────────────────────────
  Widget _buildSignInButton(SignInBloc bloc) {
    return BlocBuilder<SignInBloc, SignInState>(
      buildWhen: (_, state) => state is SignInSubmitState,
      builder: (context, state) {
        final isLoading = state is SignInSubmitState &&
            state.state == BaseState.loading;
        final isEnabled = _canSubmit && !isLoading;

        return GestureDetector(
          onTap: isEnabled
              ? () => bloc.add(SignInSubmitEvent(
                    email: _emailCtrl.text.trim(),
                    password: _passwordCtrl.text,
                  ))
              : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 52,
            decoration: BoxDecoration(
              color: isEnabled
                  ? ColorName.accent
                  : ColorName.accent.withValues(alpha: .4),
              borderRadius: BorderRadius.circular(14),
            ),
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Center(
                    child: Text(
                      AppLocalizations.of(context).signIn,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }

  // ─────────────────────────────────────────
  //  DIVIDER (OR)
  // ─────────────────────────────────────────
  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Container(height: 1, color: ColorName.surfaceSecondary),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            AppLocalizations.of(context).orDivider,
            style: TextStyle(
              color: ColorName.contentSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Expanded(
          child: Container(height: 1, color: ColorName.surfaceSecondary),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────
  //  GOOGLE BUTTON  (per Google brand guidelines:
  //    https://developers.google.com/identity/branding-guidelines)
  // ─────────────────────────────────────────
  Widget _buildGoogleButton(SignInBloc bloc) {
    return BlocBuilder<SignInBloc, SignInState>(
      buildWhen: (_, state) => state is SignInGoogleState,
      builder: (context, state) {
        final isLoading =
            state is SignInGoogleState && state.state == BaseState.loading;

        return Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          elevation: 1,
          shadowColor: Colors.black.withValues(alpha: 0.15),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: isLoading ? null : () => bloc.add(SignInGoogleEvent()),
            child: SizedBox(
              height: 48,
              child: isLoading
                  ? const Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Color(0xFF1F1F1F),
                          strokeWidth: 2,
                        ),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/google_g_logo.png',
                          width: 20,
                          height: 20,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          AppLocalizations.of(context).continueWithGoogle,
                          style: const TextStyle(
                            color: Color(0xFF1F1F1F),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.25,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }

  // ─────────────────────────────────────────
  //  APPLE BUTTON  (uses the official SignInWithAppleButton widget,
  //    which conforms to Apple's HIG for "Sign in with Apple")
  //  iOS only.
  // ─────────────────────────────────────────
  Widget _buildAppleButton(SignInBloc bloc) {
    return BlocBuilder<SignInBloc, SignInState>(
      buildWhen: (_, state) => state is SignInAppleState,
      builder: (context, state) {
        final isLoading =
            state is SignInAppleState && state.state == BaseState.loading;

        if (isLoading) {
          return Container(
            height: 44,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              ),
            ),
          );
        }

        return SignInWithAppleButton(
          onPressed: () => bloc.add(SignInAppleEvent()),
          text: AppLocalizations.of(context).continueWithApple,
          style: SignInWithAppleButtonStyle.white,
          height: 44,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        );
      },
    );
  }

  // ─────────────────────────────────────────
  //  SIGN UP ROW
  // ─────────────────────────────────────────
  Widget _buildSignUpRow(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Center(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.pushNamed(context, Navigation.signUpPage),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l.dontHaveAccount,
                style: TextStyle(
                  color: ColorName.contentSecondary,
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                l.signUp,
                style: TextStyle(
                  color: ColorName.accent,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────
  //  INPUT FIELD
  // ─────────────────────────────────────────
  Widget _buildInputField({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController ctrl,
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffix,
    String? errorText,
  }) {
    final hasError = errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: ColorName.contentSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 52,
          decoration: BoxDecoration(
            color: ColorName.backgroundSecondary,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: hasError ? Colors.redAccent : ColorName.surfaceSecondary,
            ),
          ),
          child: Row(
            children: [
              const SizedBox(width: 16),
              Icon(
                icon,
                color: hasError ? Colors.redAccent : ColorName.contentSecondary,
                size: 18,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: ctrl,
                  obscureText: obscure,
                  keyboardType: keyboardType,
                  onChanged: (_) => setState(() {}),
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(
                      color: ColorName.contentSecondary,
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
              ?suffix,
            ],
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4),
            child: Text(
              errorText,
              style: const TextStyle(color: Colors.redAccent, fontSize: 12),
            ),
          ),
      ],
    );
  }

  // ─────────────────────────────────────────
  //  SNACKBAR
  // ─────────────────────────────────────────
  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: const TextStyle(fontSize: 12),
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          showCloseIcon: true,
        ),
      );
  }
}