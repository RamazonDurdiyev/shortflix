import 'package:flutter/material.dart';
import 'package:shortflix/gen/colors.gen.dart';
import 'package:shortflix/src/services/navigation.dart';
import 'package:shortflix/src/services/routes.dart';

// ─────────────────────────────────────────
//  SIGN IN PAGE
// ─────────────────────────────────────────
class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              _buildEmailField(),
              const SizedBox(height: 16),
              _buildPasswordField(),
              const SizedBox(height: 12),
              _buildForgotPassword(),
              const SizedBox(height: 28),
              _buildSignInButton(context),
              const SizedBox(height: 24),
              _buildDivider(),
              const SizedBox(height: 24),
              _buildSocialRow(),
              const SizedBox(height: 32),
              _buildSignUpRow(context),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
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
//  EMAIL FIELD
// ─────────────────────────────────────────
Widget _buildEmailField() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Email',
        style: TextStyle(
          color: ColorName.contentSecondary,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
      const SizedBox(height: 8),
      Container(
        height: 52,
        decoration: BoxDecoration(
          color: ColorName.backgroundSecondary,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: ColorName.surfaceSecondary),
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            Icon(
              Icons.mail_outline_rounded,
              color: ColorName.contentSecondary,
              size: 18,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'you@example.com',
                  hintStyle: TextStyle(
                    color: ColorName.contentSecondary,
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
        ),
      ),
    ],
  );
}

// ─────────────────────────────────────────
//  PASSWORD FIELD
// ─────────────────────────────────────────
Widget _buildPasswordField() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Password',
        style: TextStyle(
          color: ColorName.contentSecondary,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
      const SizedBox(height: 8),
      Container(
        height: 52,
        decoration: BoxDecoration(
          color: ColorName.backgroundSecondary,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: ColorName.surfaceSecondary),
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            Icon(
              Icons.lock_outline_rounded,
              color: ColorName.contentSecondary,
              size: 18,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                obscureText: true,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                  hintText: '••••••••',
                  hintStyle: TextStyle(
                    color: ColorName.contentSecondary,
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.only(right: 14),
                child: Icon(
                  Icons.visibility_off_outlined,
                  color: ColorName.contentSecondary,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

// ─────────────────────────────────────────
//  FORGOT PASSWORD
// ─────────────────────────────────────────
Widget _buildForgotPassword() {
  return Align(
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
  );
}

// ─────────────────────────────────────────
//  SIGN IN BUTTON
// ─────────────────────────────────────────
Widget _buildSignInButton(BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.pushAndRemoveUntil(
        context,
        generateRoutes(RouteSettings(name: Navigation.homePage))!,
        (route) => false,
      );
    },
    child: Container(
      height: 52,
      decoration: BoxDecoration(
        color: ColorName.accent,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Center(
        child: Text(
          'Sign In',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.2,
          ),
        ),
      ),
    ),
  );
}

// ─────────────────────────────────────────
//  DIVIDER
// ─────────────────────────────────────────
Widget _buildDivider() {
  return Row(
    children: [
      Expanded(child: Container(height: 1, color: ColorName.surfaceSecondary)),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Text(
          'or continue with',
          style: TextStyle(color: ColorName.contentSecondary, fontSize: 12),
        ),
      ),
      Expanded(child: Container(height: 1, color: ColorName.surfaceSecondary)),
    ],
  );
}

// ─────────────────────────────────────────
//  SOCIAL ROW
// ─────────────────────────────────────────
Widget _buildSocialRow() {
  return Row(
    children: [
      Expanded(
        child: _buildSocialButton(
          label: 'Google',
          icon: Icons.g_mobiledata_rounded,
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: _buildSocialButton(label: 'Apple', icon: Icons.apple_rounded),
      ),
    ],
  );
}

Widget _buildSocialButton({required String label, required IconData icon}) {
  return GestureDetector(
    onTap: () {},
    child: Container(
      height: 52,
      decoration: BoxDecoration(
        color: ColorName.backgroundSecondary,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ColorName.surfaceSecondary),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 22),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
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
          onTap: () {
            Navigator.push(
              context,
              generateRoutes(RouteSettings(name: Navigation.signUpPage))!,
            );
          },
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
