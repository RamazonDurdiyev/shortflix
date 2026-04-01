import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shortflix/core/utils/base_state.dart';
import 'package:shortflix/gen/colors.gen.dart';
import 'package:shortflix/src/services/navigation.dart';
import 'package:shortflix/src/services/routes.dart';
import 'package:shortflix/src/ui/pages/sign_in_page/sign_in_bloc.dart';
import 'package:shortflix/src/ui/pages/sign_in_page/sign_in_event.dart';
import 'package:shortflix/src/ui/pages/sign_in_page/sign_in_state.dart';

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
          _showSnackbar(context, 'Incorrect email or password');
        }
        if (state is SignInNotSignedUpState) {
          Navigator.pushNamed(
            context,
            Navigation.signUpPage,
            arguments: {'email': state.email},
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
                  label: 'Email',
                  hint: 'you@example.com',
                  icon: Icons.mail_outline_rounded,
                  ctrl: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  errorText: _emailCtrl.text.isNotEmpty && !_emailValid
                      ? 'Enter a valid email'
                      : null,
                ),
                const SizedBox(height: 16),
                _buildInputField(
                  label: 'Password',
                  hint: '••••••••',
                  icon: Icons.lock_outline_rounded,
                  ctrl: _passwordCtrl,
                  obscure: _obscure,
                  errorText: _passwordCtrl.text.isNotEmpty && !_passwordValid
                      ? 'Password must be at least 6 characters'
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
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {},
                    child: Text(
                      'Forgot password?',
                      style: TextStyle(
                        color: ColorName.accent,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                _buildSignInButton(bloc),
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
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: ColorName.accent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Center(
            child: Text(
              'N',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        const Text(
          'Shortflix',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────
  //  HEADING
  // ─────────────────────────────────────────
  Widget _buildHeading() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Welcome back',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Sign in to continue watching',
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
                : const Center(
                    child: Text(
                      'Sign In',
                      style: TextStyle(
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
  //  SIGN UP ROW
  // ─────────────────────────────────────────
  Widget _buildSignUpRow(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Don't have an account? ",
            style: TextStyle(color: ColorName.contentSecondary, fontSize: 13),
          ),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, Navigation.signUpPage),
            child: Text(
              'Sign Up',
              style: TextStyle(
                color: ColorName.accent,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}