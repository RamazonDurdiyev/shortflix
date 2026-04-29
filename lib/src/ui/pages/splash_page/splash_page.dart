import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shortflix/gen/colors.gen.dart';
import 'package:shortflix/l10n/app_localizations.dart';
import 'package:shortflix/src/services/navigation.dart';
import 'package:shortflix/src/services/routes.dart';
import 'package:shortflix/src/ui/pages/splash_page/splash_cubit.dart';
import 'package:shortflix/src/ui/pages/splash_page/splash_state.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _scaleAnim = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();

    // trigger check after widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SplashCubit>().init();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        if (state is SplashGoHome) {
          Navigator.pushAndRemoveUntil(
            context,
            generateRoutes(RouteSettings(name: Navigation.homePage))!,
            (_) => false,
          );
        }

        if (state is SplashGoSignIn) {
          Navigator.pushAndRemoveUntil(
            context,
            generateRoutes(RouteSettings(name: Navigation.signInPage))!,
            (_) => false,
          );
        }

        if (state is SplashNoNetwork) {
          _showNoNetworkDialog(context);
        }
      },
      child: Scaffold(
        backgroundColor: ColorName.backgroundPrimary,
        body: Center(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: ScaleTransition(
              scale: _scaleAnim,
              child: Image.asset(
                'assets/images/916TV_transparent.png',
                width: 240,
                height: 240,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showNoNetworkDialog(BuildContext context) {
    final l = AppLocalizations.of(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: ColorName.backgroundSecondary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          l.noConnection,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Text(
          l.checkInternetConnection,
          style: TextStyle(color: ColorName.contentSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<SplashCubit>().init();
            },
            child: Text(
              l.retry,
              style: TextStyle(
                color: ColorName.accent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}