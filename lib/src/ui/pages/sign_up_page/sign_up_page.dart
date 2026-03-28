import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shortflix/core/utils/base_state.dart';
import 'package:shortflix/gen/colors.gen.dart';
import 'package:shortflix/src/services/navigation.dart';
import 'package:shortflix/src/ui/pages/sign_up_page/sign_up_bloc.dart';
import 'package:shortflix/src/ui/pages/sign_up_page/sign_up_event.dart';
import 'package:shortflix/src/ui/pages/sign_up_page/sign_up_state.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _fullNameCtrl = TextEditingController();
  final _emailCtrl    = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscure       = true;
  DateTime? _selectedDate;

  // ── Regex ────────────────────────────────────────────────────
  static final _emailRegex    = RegExp(r'^[\w.+-]+@[\w-]+\.[a-zA-Z]{2,}$');
  static final _passwordRegex = RegExp(r'^.{6,}$');
  static final _fullNameRegex = RegExp(r'^.{2,}$');

  // ── Validators ───────────────────────────────────────────────
  bool get _fullNameValid => _fullNameRegex.hasMatch(_fullNameCtrl.text.trim());
  bool get _emailValid    => _emailRegex.hasMatch(_emailCtrl.text.trim());
  bool get _passwordValid => _passwordRegex.hasMatch(_passwordCtrl.text);

  bool get _canSubmit =>
      _fullNameValid && _emailValid && _passwordValid && _selectedDate != null;

  // ── ISO 8601 UTC ─────────────────────────────────────────────
  String get _birthDateIso {
    if (_selectedDate == null) return '';
    return DateTime.utc(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
    ).toIso8601String();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map?;
      if (args != null && args['email'] != null) {
        setState(() => _emailCtrl.text = args['email'] as String);
      }
    });
  }

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 18, now.month, now.day),
      firstDate: DateTime(1900),
      lastDate: DateTime(now.year - 5),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.dark(
            primary: ColorName.accent,
            surface: ColorName.backgroundSecondary,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<SignUpBloc>();

    return BlocListener<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if (state is SignUpSubmitState && state.state == BaseState.loaded) {
          // register succeeded — backend already sent OTP → go to confirmation
          Navigator.pushNamed(
            context,
            Navigation.confirmationPage,
            arguments: {'email': state.email},
          );
        }
        if (state is SignUpSubmitState && state.state == BaseState.error) {
          _showSnackbar(context, 'Sign up failed. Please try again.');
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
                const SizedBox(height: 24),
                _buildTopBar(context),
                const SizedBox(height: 32),
                _buildHeading(),
                const SizedBox(height: 32),

                _buildInputField(
                  label: 'Full Name',
                  hint: 'John Doe',
                  icon: Icons.person_outline_rounded,
                  ctrl: _fullNameCtrl,
                  onChanged: (_) => setState(() {}),
                  errorText: _fullNameCtrl.text.isNotEmpty && !_fullNameValid
                      ? 'Enter your full name'
                      : null,
                ),
                const SizedBox(height: 16),

                _buildInputField(
                  label: 'Email',
                  hint: 'you@example.com',
                  icon: Icons.mail_outline_rounded,
                  ctrl: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (_) => setState(() {}),
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
                  onChanged: (_) => setState(() {}),
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
                const SizedBox(height: 16),

                _buildDateField(),
                const SizedBox(height: 28),

                _buildSubmitButton(bloc),
                const SizedBox(height: 32),
                _buildSignInRow(context),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
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
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
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
          style: TextStyle(color: ColorName.contentSecondary, fontSize: 14),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────
  //  DATE FIELD
  // ─────────────────────────────────────────
  Widget _buildDateField() {
    final hasDate = _selectedDate != null;
    final label = hasDate
        ? '${_selectedDate!.day.toString().padLeft(2, '0')}.'
            '${_selectedDate!.month.toString().padLeft(2, '0')}.'
            '${_selectedDate!.year}'
        : 'Select date of birth';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date of Birth',
          style: TextStyle(
            color: ColorName.contentSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickDate,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 52,
            decoration: BoxDecoration(
              color: ColorName.backgroundSecondary,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: hasDate ? ColorName.accent : ColorName.surfaceSecondary,
              ),
            ),
            child: Row(
              children: [
                const SizedBox(width: 16),
                Icon(
                  Icons.cake_outlined,
                  color: hasDate ? ColorName.accent : ColorName.contentSecondary,
                  size: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: hasDate ? Colors.white : ColorName.contentSecondary,
                      fontSize: 14,
                    ),
                  ),
                ),
                if (hasDate)
                  Padding(
                    padding: const EdgeInsets.only(right: 14),
                    child: Text(
                      'Change',
                      style: TextStyle(
                        color: ColorName.accent,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
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

  // ─────────────────────────────────────────
  //  SUBMIT BUTTON
  // ─────────────────────────────────────────
  Widget _buildSubmitButton(SignUpBloc bloc) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        final isLoading =
            state is SignUpSubmitState && state.state == BaseState.loading;
        final isEnabled = _canSubmit && !isLoading;

        return GestureDetector(
          onTap: isEnabled
              ? () => bloc.add(SignUpSubmitEvent(
                    fullName: _fullNameCtrl.text.trim(),
                    email: _emailCtrl.text.trim(),
                    password: _passwordCtrl.text,
                    birthDateIso: _birthDateIso,
                  ))
              : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 52,
            decoration: BoxDecoration(
              color: isEnabled
                  ? ColorName.accent
                  : ColorName.accent.withOpacity(0.4),
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
                      'Create Account',
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
  //  SIGN IN ROW
  // ─────────────────────────────────────────
  Widget _buildSignInRow(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Already have an account? ',
            style: TextStyle(color: ColorName.contentSecondary, fontSize: 13),
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
    ValueChanged<String>? onChanged,
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
                  onChanged: onChanged,
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
              if (suffix != null) suffix,
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