import 'package:flutter/material.dart';
import 'package:shortflix/gen/colors.gen.dart';

// ─────────────────────────────────────────
//  SIGN UP PAGE
// ─────────────────────────────────────────
class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

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
              const SizedBox(height: 24),
              _buildTopBar(context),
              const SizedBox(height: 32),
              _buildHeading(),
              const SizedBox(height: 32),
              _buildFullNameField(),
              const SizedBox(height: 16),
              _buildEmailField(),
              const SizedBox(height: 16),
              _buildPasswordField(),
              const SizedBox(height: 16),
              _buildConfirmPasswordField(),
              const SizedBox(height: 20),
              _buildTermsRow(),
              const SizedBox(height: 28),
              _buildSignUpButton(),
              const SizedBox(height: 24),
              _buildDivider(),
              const SizedBox(height: 24),
              _buildSocialRow(),
              const SizedBox(height: 32),
              _buildSignInRow(context),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
//  TOP BAR
// ─────────────────────────────────────────
Widget _buildTopBar(BuildContext context) {
  return Row(
    children: [
      GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: ColorName.backgroundSecondary,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: ColorName.surfaceSecondary),
          ),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 16,
          ),
        ),
      ),
      const SizedBox(width: 14),
      Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: ColorName.accent,
              borderRadius: BorderRadius.circular(7),
            ),
            child: const Center(
              child: Text(
                'N',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'Shortflix',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.3,
            ),
          ),
        ],
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
        'Create account',
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
        'Join millions watching on Shortflix',
        style: TextStyle(
          color: ColorName.contentSecondary,
          fontSize: 14,
        ),
      ),
    ],
  );
}

// ─────────────────────────────────────────
//  INPUT FIELD BUILDER
// ─────────────────────────────────────────
Widget _buildInputField({
  required String label,
  required String hint,
  required IconData icon,
  bool obscure = false,
  TextInputType keyboardType = TextInputType.text,
  Widget? suffix,
}) {
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
            Icon(icon, color: ColorName.contentSecondary, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                obscureText: obscure,
                keyboardType: keyboardType,
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
            const SizedBox(width: 4),
          ],
        ),
      ),
    ],
  );
}

// ─────────────────────────────────────────
//  FIELDS
// ─────────────────────────────────────────
Widget _buildFullNameField() => _buildInputField(
      label: 'Full Name',
      hint: 'John Doe',
      icon: Icons.person_outline_rounded,
    );

Widget _buildEmailField() => _buildInputField(
      label: 'Email',
      hint: 'you@example.com',
      icon: Icons.mail_outline_rounded,
      keyboardType: TextInputType.emailAddress,
    );

Widget _buildPasswordField() => _buildInputField(
      label: 'Password',
      hint: '••••••••',
      icon: Icons.lock_outline_rounded,
      obscure: true,
      suffix: GestureDetector(
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
    );

Widget _buildConfirmPasswordField() => _buildInputField(
      label: 'Confirm Password',
      hint: '••••••••',
      icon: Icons.lock_outline_rounded,
      obscure: true,
      suffix: GestureDetector(
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
    );

// ─────────────────────────────────────────
//  TERMS ROW
// ─────────────────────────────────────────
Widget _buildTermsRow() {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: 20,
        height: 20,
        margin: const EdgeInsets.only(top: 1),
        decoration: BoxDecoration(
          color: ColorName.accent.withValues(alpha: .15),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: ColorName.accent.withValues(alpha: .5)),
        ),
        child: Icon(
          Icons.check_rounded,
          color: ColorName.accent,
          size: 13,
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: RichText(
          text: TextSpan(
            style: TextStyle(
              color: ColorName.contentSecondary,
              fontSize: 13,
              height: 1.4,
            ),
            children: [
              const TextSpan(text: 'I agree to the '),
              TextSpan(
                text: 'Terms of Service',
                style: TextStyle(
                  color: ColorName.accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const TextSpan(text: ' and '),
              TextSpan(
                text: 'Privacy Policy',
                style: TextStyle(
                  color: ColorName.accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

// ─────────────────────────────────────────
//  SIGN UP BUTTON
// ─────────────────────────────────────────
Widget _buildSignUpButton() {
  return GestureDetector(
    onTap: () {},
    child: Container(
      height: 52,
      decoration: BoxDecoration(
        color: ColorName.accent,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Center(
        child: Text(
          'Create Account',
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
          'or sign up with',
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
      Expanded(child: _buildSocialButton(label: 'Google', icon: Icons.g_mobiledata_rounded)),
      const SizedBox(width: 12),
      Expanded(child: _buildSocialButton(label: 'Apple', icon: Icons.apple_rounded)),
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
//  SIGN IN ROW
// ─────────────────────────────────────────
Widget _buildSignInRow(BuildContext context) {
  return Center(
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Already have an account? ',
          style: TextStyle(
            color: ColorName.contentSecondary,
            fontSize: 13,
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Text(
            'Sign In',
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