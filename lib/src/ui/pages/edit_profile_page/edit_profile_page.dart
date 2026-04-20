import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shortflix/core/utils/base_state.dart';
import 'package:shortflix/gen/colors.gen.dart';
import 'package:shortflix/l10n/app_localizations.dart';
import 'package:shortflix/src/models/user_model/user_model.dart';
import 'package:shortflix/src/ui/pages/edit_profile_page/edit_profile_bloc.dart';
import 'package:shortflix/src/ui/pages/edit_profile_page/edit_profile_event.dart';
import 'package:shortflix/src/ui/pages/edit_profile_page/edit_profile_state.dart';

class EditProfilePage extends StatefulWidget {
  final UserModel? user;

  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _fullNameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  DateTime? _selectedDate;

  // ── Regex ────────────────────────────────────────────────────
  static final _fullNameRegex = RegExp(r'^.{2,}$');
  static final _phoneRegex = RegExp(r'^\+?[0-9]{7,15}$');

  // ── Validators ───────────────────────────────────────────────
  bool get _fullNameValid => _fullNameRegex.hasMatch(_fullNameCtrl.text.trim());
  bool get _phoneValid => _phoneRegex.hasMatch(_phoneCtrl.text.trim());
  bool get _dateValid => _selectedDate != null;

  bool get _canSubmit => _fullNameValid && _phoneValid && _dateValid;

  // ── Date "YYYY-MM-DD" ────────────────────────────────────────
  String get _dateOfBirth {
    if (_selectedDate == null) return '';
    final y = _selectedDate!.year.toString().padLeft(4, '0');
    final m = _selectedDate!.month.toString().padLeft(2, '0');
    final d = _selectedDate!.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  @override
  void initState() {
    super.initState();
    _prefill();
  }

  void _prefill() {
    final u = widget.user;
    if (u == null) return;
    _fullNameCtrl.text = u.fullName ?? '';
    _phoneCtrl.text = u.phone ?? '';
    final parsed = _tryParseDate(u.dateOfBirth);
    if (parsed != null) _selectedDate = parsed;
  }

  DateTime? _tryParseDate(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    try {
      return DateTime.parse(raw);
    } catch (_) {
      return null;
    }
  }

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate:
          _selectedDate ?? DateTime(now.year - 18, now.month, now.day),
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
    final bloc = context.read<EditProfileBloc>();
    final l = AppLocalizations.of(context);

    return BlocListener<EditProfileBloc, EditProfileState>(
      listener: (context, state) {
        if (state is UpdateUserState && state.state == BaseState.loaded) {
          _showSnackbar(context, l.profileUpdated, success: true);
          Navigator.of(context).pop(true);
        }
        if (state is UpdateUserState && state.state == BaseState.error) {
          _showSnackbar(context, l.profileUpdateFailed);
        }
        if (state is PickImageState && state.state == BaseState.error) {
          _showSnackbar(context, l.pickImageFailed);
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
                _buildTopBar(context, l),
                const SizedBox(height: 24),

                _buildAvatarPicker(bloc, l),
                const SizedBox(height: 24),

                _buildInputField(
                  label: l.fullName,
                  hint: l.fullNameHint,
                  icon: Icons.person_outline_rounded,
                  ctrl: _fullNameCtrl,
                  onChanged: (_) => setState(() {}),
                  errorText: _fullNameCtrl.text.isNotEmpty && !_fullNameValid
                      ? l.fullNameError
                      : null,
                ),
                const SizedBox(height: 16),

                _buildInputField(
                  label: l.phone,
                  hint: l.phoneHint,
                  icon: Icons.phone_outlined,
                  ctrl: _phoneCtrl,
                  keyboardType: TextInputType.phone,
                  onChanged: (_) => setState(() {}),
                  errorText: _phoneCtrl.text.isNotEmpty && !_phoneValid
                      ? l.phoneError
                      : null,
                ),
                const SizedBox(height: 16),

                _buildDateField(l),
                const SizedBox(height: 28),

                _buildSubmitButton(bloc, l),
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
  Widget _buildTopBar(BuildContext context, AppLocalizations l) {
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
        Text(
          l.editProfileTitle,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────
  //  AVATAR PICKER
  // ─────────────────────────────────────────
  Widget _buildAvatarPicker(EditProfileBloc bloc, AppLocalizations l) {
    return BlocBuilder<EditProfileBloc, EditProfileState>(
      buildWhen: (_, state) => state is PickImageState,
      builder: (context, state) {
        final isPicking =
            state is PickImageState && state.state == BaseState.loading;
        final pickedPath = bloc.imagePath;
        final remoteUrl = widget.user?.avatar;

        ImageProvider? provider;
        if (pickedPath != null) {
          provider = FileImage(File(pickedPath));
        } else if (remoteUrl != null && remoteUrl.isNotEmpty) {
          provider = NetworkImage(remoteUrl);
        }

        return Center(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: 104,
                    height: 104,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [ColorName.accent, ColorName.accentDark],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: ColorName.surfaceSecondary,
                        width: 2,
                      ),
                      image: provider != null
                          ? DecorationImage(image: provider, fit: BoxFit.cover)
                          : null,
                    ),
                    child: provider == null
                        ? const Center(
                            child: Icon(
                              Icons.person_rounded,
                              color: Colors.white,
                              size: 48,
                            ),
                          )
                        : null,
                  ),
                  if (isPicking)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: .4),
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: GestureDetector(
                      onTap: isPicking ? null : () => bloc.add(PickImageEvent()),
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: ColorName.accent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: ColorName.backgroundPrimary,
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.camera_alt_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: isPicking ? null : () => bloc.add(PickImageEvent()),
                child: Text(
                  pickedPath != null ? l.changePhoto : l.uploadPhoto,
                  style: TextStyle(
                    color: ColorName.accent,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ─────────────────────────────────────────
  //  DATE FIELD
  // ─────────────────────────────────────────
  Widget _buildDateField(AppLocalizations l) {
    final hasDate = _selectedDate != null;
    final label = hasDate
        ? '${_selectedDate!.day.toString().padLeft(2, '0')}.'
            '${_selectedDate!.month.toString().padLeft(2, '0')}.'
            '${_selectedDate!.year}'
        : l.selectDateOfBirth;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l.dateOfBirth,
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
                  color:
                      hasDate ? ColorName.accent : ColorName.contentSecondary,
                  size: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color:
                          hasDate ? Colors.white : ColorName.contentSecondary,
                      fontSize: 14,
                    ),
                  ),
                ),
                if (hasDate)
                  Padding(
                    padding: const EdgeInsets.only(right: 14),
                    child: Text(
                      l.change,
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
  Widget _buildSubmitButton(EditProfileBloc bloc, AppLocalizations l) {
    return BlocBuilder<EditProfileBloc, EditProfileState>(
      builder: (context, state) {
        final isLoading =
            state is UpdateUserState && state.state == BaseState.loading;
        final isEnabled = _canSubmit && !isLoading;

        return GestureDetector(
          onTap: isEnabled
              ? () => bloc.add(
                    UpdateUserEvent(
                      fullName: _fullNameCtrl.text.trim(),
                      phone: _phoneCtrl.text.trim(),
                      currentAvatar: widget.user?.avatar ?? '',
                      dateOfBirth: _dateOfBirth,
                    ),
                  )
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
                      l.saveChanges,
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
  //  INPUT FIELD
  // ─────────────────────────────────────────
  Widget _buildInputField({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController ctrl,
    TextInputType keyboardType = TextInputType.text,
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
                color:
                    hasError ? Colors.redAccent : ColorName.contentSecondary,
                size: 18,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: ctrl,
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
  void _showSnackbar(BuildContext context, String message,
      {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: success ? ColorName.accent : Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
