import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shortflix/core/utils/base_state.dart';
import 'package:shortflix/gen/colors.gen.dart';
import 'package:shortflix/l10n/app_localizations.dart';
import 'package:shortflix/src/services/navigation.dart';
import 'package:shortflix/src/services/routes.dart';
import 'package:shortflix/src/ui/pages/confirmation_page/confirmation_bloc.dart';
import 'package:shortflix/src/ui/pages/confirmation_page/confirmation_event.dart';
import 'package:shortflix/src/ui/pages/confirmation_page/confirmation_state.dart';

class ConfirmationPage extends StatefulWidget {
  const ConfirmationPage({super.key});

  @override
  State<ConfirmationPage> createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage> {
  // 6 separate controllers — one per digit box
  final List<TextEditingController> _ctrls =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focuses =
      List.generate(6, (_) => FocusNode());

  String _email = '';

@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    setState(() {
      _email = (args?['email'] as String?) ?? '';
    });
  });
}

  @override
  void dispose() {
    for (final c in _ctrls) {
      c.dispose();
    }
    for (final f in _focuses) {
      f.dispose();
    }
    super.dispose();
  }

  String get _fullCode => _ctrls.map((c) => c.text).join();

  void _onDigitChanged(int index, String value) {
    if (value.length == 1 && index < 5) {
      _focuses[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focuses[index - 1].requestFocus();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ConfirmationBloc>();
    final l = AppLocalizations.of(context);

    return BlocListener<ConfirmationBloc, ConfirmationState>(
      listener: (context, state) {
        if (state is ConfirmationSubmitState && state.state == BaseState.loaded) {
          Navigator.pushAndRemoveUntil(
            context,
            generateRoutes(RouteSettings(name: Navigation.homePage))!,
            (_) => false,
          );
        }
        if (state is ConfirmationSubmitState && state.state == BaseState.error) {
          _showSnackbar(context, l.invalidCode);
        }
        if (state is ConfirmationResendState && state.state == BaseState.loaded) {
          _showSnackbar(context, l.codeResent, success: true);
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
                const SizedBox(height: 40),
                _buildHeading(),
                const SizedBox(height: 40),
                _buildCodeBoxes(),
                const SizedBox(height: 32),
                _buildVerifyButton(bloc),
                const SizedBox(height: 20),
                _buildResendRow(bloc),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

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
      ],
    );
  }

  Widget _buildHeading() {
    final l = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icon
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: ColorName.accent.withValues(alpha: .1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(Icons.mark_email_read_outlined, color: ColorName.accent, size: 28),
        ),
        const SizedBox(height: 20),
        Text(
          l.checkYourEmail,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 10),
        RichText(
          text: TextSpan(
            style: TextStyle(
              color: ColorName.contentSecondary,
              fontSize: 14,
              height: 1.5,
            ),
            children: [
              TextSpan(text: l.sentCodeTo),
              TextSpan(
                text: _email.isEmpty ? l.yourEmailFallback : _email,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCodeBoxes() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(6, (index) {
        return SizedBox(
          width: 48,
          height: 56,
          child: Container(
            decoration: BoxDecoration(
              color: ColorName.backgroundSecondary,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _ctrls[index].text.isNotEmpty
                    ? ColorName.accent
                    : ColorName.surfaceSecondary,
                width: 1.5,
              ),
            ),
            child: Center(
              child: TextField(
                controller: _ctrls[index],
                focusNode: _focuses[index],
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 1,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  counterText: '',
                ),
                onChanged: (v) => _onDigitChanged(index, v),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildVerifyButton(ConfirmationBloc bloc) {
    return BlocBuilder<ConfirmationBloc, ConfirmationState>(
      buildWhen: (_, state) => state is ConfirmationSubmitState,
      builder: (context, state) {
        final isLoading = state is ConfirmationSubmitState && state.state == BaseState.loading;
        final canSubmit = _fullCode.length == 6;

        return GestureDetector(
          onTap: isLoading || !canSubmit
              ? null
              : () => bloc.add(ConfirmationSubmitEvent(
                    email: _email,
                    code: _fullCode,
                  )),
          child: Container(
            height: 52,
            decoration: BoxDecoration(
              color: isLoading || !canSubmit
                  ? ColorName.accent.withValues(alpha: .4)
                  : ColorName.accent,
              borderRadius: BorderRadius.circular(14),
            ),
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                : Center(
                    child: Text(
                      AppLocalizations.of(context).verify,
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

  Widget _buildResendRow(ConfirmationBloc bloc) {
    return BlocBuilder<ConfirmationBloc, ConfirmationState>(
      buildWhen: (_, state) => state is ConfirmationResendState,
      builder: (context, state) {
        final l = AppLocalizations.of(context);
        final isLoading = state is ConfirmationResendState && state.state == BaseState.loading;

        return Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l.didntReceiveCode,
                style: TextStyle(color: ColorName.contentSecondary, fontSize: 13),
              ),
              GestureDetector(
                onTap: isLoading
                    ? null
                    : () => bloc.add(ConfirmationResendEvent(email: _email)),
                child: isLoading
                    ? SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          color: ColorName.accent,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        l.resend,
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
      },
    );
  }

  void _showSnackbar(BuildContext context, String message, {bool success = false}) {
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