import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shortflix/app/app_constants.dart';
import 'package:shortflix/core/utils/base_state.dart';
import 'package:shortflix/gen/colors.gen.dart';
import 'package:shortflix/src/models/user_model/user_model.dart';
import 'package:shortflix/src/services/navigation.dart';
import 'package:shortflix/src/services/routes.dart';
import 'package:shortflix/l10n/app_localizations.dart';
import 'package:shortflix/src/ui/pages/language_page/language_page.dart';
import 'package:shortflix/src/ui/pages/profile_page/profile_bloc.dart';
import 'package:shortflix/src/ui/pages/profile_page/profile_event.dart';
import 'package:shortflix/src/ui/pages/profile_page/profile_state.dart';

// ─────────────────────────────────────────
//  PROFILE PAGE
// ─────────────────────────────────────────
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileBloc>(
      create: (_) => ProfileBloc(
        userRepo: GetIt.instance.get(),
        authRepo: GetIt.instance.get(),
      )..add(FetchUserEvent()),
      child: const _ProfileView(),
    );
  }
}

// ─────────────────────────────────────────
//  PROFILE VIEW
// ─────────────────────────────────────────
class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return BlocListener<ProfileBloc, ProfileState>(
      listenWhen: (_, state) =>
          state is LogoutState || state is DeleteAccountState,
      listener: (context, state) {
        if (state is LogoutState && state.state == BaseState.loaded) {
          Navigator.pushAndRemoveUntil(
            context,
            generateRoutes(RouteSettings(name: Navigation.signInPage))!,
            (_) => false,
          );
        }
        if (state is LogoutState && state.state == BaseState.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l.logoutFailed),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
        if (state is DeleteAccountState && state.state == BaseState.loaded) {
          Navigator.pushAndRemoveUntil(
            context,
            generateRoutes(RouteSettings(name: Navigation.signInPage))!,
            (_) => false,
          );
        }
        if (state is DeleteAccountState && state.state == BaseState.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l.deleteAccountFailed),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
      },
      child: Scaffold(
      backgroundColor: ColorName.backgroundPrimary,
      body: SafeArea(
        child: BlocBuilder<ProfileBloc, ProfileState>(
          buildWhen: (_, state) => state is FetchUserState,
          builder: (context, state) {
            final profileBloc = context.read<ProfileBloc>();
            final isLoading =
                state is FetchUserState && state.state == BaseState.loading;
            final user = profileBloc.user;

            Future<void> openEditProfile() async {
              final result = await Navigator.pushNamed(
                context,
                Navigation.editProfilePage,
                arguments: profileBloc.user,
              );
              if (result == true) {
                profileBloc.add(FetchUserEvent());
              }
            }

            return Column(
              children: [
                _buildTopBar(context, l),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _buildProfileHeader(
                        l: l,
                        user: user,
                        isLoading: isLoading,
                        onEditTap: openEditProfile,
                      ),
                      _buildStatsRow(l),
                      const SizedBox(height: 8),
                      _buildSectionTitle(l.sectionAccount),
                      _buildMenuGroup([
                        _MenuItem(
                          icon: Icons.person_outline_rounded,
                          label: l.editProfile,
                          onTap: openEditProfile,
                        ),
                        _MenuItem(
                          icon: Icons.lock_outline_rounded,
                          label: l.privacyAndSecurity,
                          onTap: () => _showComingSoonDialog(context),
                        ),
                        _MenuItem(
                          icon: Icons.language_rounded,
                          label: l.language,
                          trailing: ValueListenableBuilder(
                            valueListenable:
                                Hive.box('default').listenable(keys: [LANGUAGE]),
                            builder: (context, Box box, _) {
                              final code = box.get(LANGUAGE) as String?;
                              return _buildValueLabel(languageLabelFor(
                                  AppLocalizations.of(context), code));
                            },
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              generateRoutes(
                                RouteSettings(name: Navigation.languagePage),
                              )!,
                            );
                          },
                        ),
                      ]),
                      _buildSectionTitle(l.sectionSupport),
                      _buildMenuGroup([
                        _MenuItem(
                          icon: Icons.help_outline_rounded,
                          label: l.helpCenter,
                          onTap: () => _showComingSoonDialog(context),
                        ),
                        _MenuItem(
                          icon: Icons.privacy_tip_outlined,
                          label: l.privacyPolicy,
                          onTap: () {
                            Navigator.push(
                              context,
                              generateRoutes(
                                RouteSettings(
                                    name: Navigation.privacyPolicyPage),
                              )!,
                            );
                          },
                        ),
                        _MenuItem(
                          icon: Icons.info_outline_rounded,
                          label: l.about,
                          onTap: () => _showComingSoonDialog(context),
                        ),
                      ]),
                      const SizedBox(height: 16),
                      _buildLogoutButton(context, profileBloc, l),
                      const SizedBox(height: 24),
                      _buildSectionTitle(l.dangerZone),
                      _buildDeleteAccountButton(context, profileBloc, l),
                      const SizedBox(height: 12),
                      _buildVersionLabel(),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    ),
    );
  }
}

// ─────────────────────────────────────────
//  MODEL
// ─────────────────────────────────────────
class _MenuItem {
  final IconData icon;
  final String label;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    this.trailing,
    this.onTap,
  });
}

// ─────────────────────────────────────────
//  TOP BAR
// ─────────────────────────────────────────
Widget _buildTopBar(BuildContext context, AppLocalizations l) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
    child: Row(
      children: [
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            l.profile,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.3,
            ),
          ),
        ),
       
      ],
    ),
  );
}

// ─────────────────────────────────────────
//  PROFILE HEADER
// ─────────────────────────────────────────
Widget _buildProfileHeader({
  required AppLocalizations l,
  required UserModel? user,
  required bool isLoading,
  required VoidCallback onEditTap,
}) {
  final fullName = user?.fullName ?? (isLoading ? '...' : l.profileFallbackName);
  final email = user?.email ?? (isLoading ? '...' : l.profileFallbackEmail);
  final initial =
      (fullName.isNotEmpty ? fullName.trim()[0] : 'S').toUpperCase();
  final avatarUrl = user?.avatar;

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
    child: Row(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [ColorName.accent, ColorName.accentDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            image: (avatarUrl != null && avatarUrl.isNotEmpty)
                ? DecorationImage(
                    image: NetworkImage(avatarUrl),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: (avatarUrl == null || avatarUrl.isEmpty)
              ? Center(
                  child: Text(
                    initial,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : null,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                fullName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                email,
                style: TextStyle(
                  color: ColorName.contentSecondary,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: ColorName.accent.withValues(alpha: .15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: ColorName.accent.withValues(alpha: .4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star_rounded, color: ColorName.accent, size: 12),
                    const SizedBox(width: 4),
                    Text(
                      l.premium,
                      style: TextStyle(
                        color: ColorName.accent,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: onEditTap,
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: ColorName.backgroundSecondary,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: ColorName.surfaceSecondary),
            ),
            child: Icon(
              Icons.edit_outlined,
              color: ColorName.contentSecondary,
              size: 16,
            ),
          ),
        ),
      ],
    ),
  );
}

// ─────────────────────────────────────────
//  STATS ROW
// ─────────────────────────────────────────
Widget _buildStatsRow(AppLocalizations l) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 20),
    padding: const EdgeInsets.symmetric(vertical: 16),
    decoration: BoxDecoration(
      color: ColorName.backgroundSecondary,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: ColorName.surfaceSecondary),
    ),
    child: Row(
      children: [
        _buildStatItem('48', l.statWatched),
        _buildStatDivider(),
        _buildStatItem('12', l.statWatchlist),
        _buildStatDivider(),
        _buildStatItem('36', l.statLiked),
      ],
    ),
  );
}

Widget _buildStatItem(String value, String label) {
  return Expanded(
    child: Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(color: ColorName.contentSecondary, fontSize: 12),
        ),
      ],
    ),
  );
}

Widget _buildStatDivider() {
  return Container(width: 1, height: 32, color: ColorName.surfaceSecondary);
}

// ─────────────────────────────────────────
//  SECTION TITLE
// ─────────────────────────────────────────
Widget _buildSectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
    child: Row(
      children: [
        Container(
          width: 4,
          height: 16,
          decoration: BoxDecoration(
            color: ColorName.accent,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            color: ColorName.contentSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
        ),
      ],
    ),
  );
}

// ─────────────────────────────────────────
//  MENU GROUP
// ─────────────────────────────────────────
Widget _buildMenuGroup(List<_MenuItem> items) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 20),
    decoration: BoxDecoration(
      color: ColorName.backgroundSecondary,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: ColorName.surfaceSecondary),
    ),
    child: Column(
      children: List.generate(items.length, (index) {
        final item = items[index];
        final isLast = index == items.length - 1;
        return Column(
          children: [
            _buildMenuItem(item),
            if (!isLast)
              Container(
                height: 1,
                margin: const EdgeInsets.only(left: 56),
                color: ColorName.surfaceSecondary,
              ),
          ],
        );
      }),
    ),
  );
}

Widget _buildMenuItem(_MenuItem item) {
  return GestureDetector(
    onTap: item.onTap ?? () {},
    behavior: HitTestBehavior.opaque,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: (ColorName.contentSecondary).withValues(alpha: .1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(item.icon, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              item.label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (item.trailing != null) ...[
            item.trailing!,
            const SizedBox(width: 8),
          ],
          Icon(
            Icons.arrow_forward_ios_rounded,
            color: ColorName.contentSecondary,
            size: 14,
          ),
        ],
      ),
    ),
  );
}

Widget _buildValueLabel(String value) {
  return Text(
    value,
    style: TextStyle(color: ColorName.contentSecondary, fontSize: 13),
  );
}

// ─────────────────────────────────────────
//  LOGOUT BUTTON
// ─────────────────────────────────────────
Widget _buildLogoutButton(
    BuildContext context, ProfileBloc profileBloc, AppLocalizations l) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: BlocBuilder<ProfileBloc, ProfileState>(
      buildWhen: (_, state) => state is LogoutState,
      builder: (context, state) {
        final isLoading =
            state is LogoutState && state.state == BaseState.loading;

        return GestureDetector(
          onTap: isLoading
              ? null
              : () async {
                  final confirmed = await _confirmLogout(context);
                  if (confirmed == true) {
                    profileBloc.add(LogoutEvent());
                  }
                },
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: ColorName.accent.withValues(alpha: .08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: ColorName.accent.withValues(alpha: .3)),
            ),
            child: isLoading
                ? Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: ColorName.accent,
                        strokeWidth: 2,
                      ),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.logout_rounded,
                        color: ColorName.accent,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        l.logOut,
                        style: TextStyle(
                          color: ColorName.accent,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    ),
  );
}

Future<bool?> _confirmLogout(BuildContext context) {
  final l = AppLocalizations.of(context);
  return showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: ColorName.backgroundSecondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(
        l.logoutConfirmTitle,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      content: Text(
        l.logoutConfirmMessage,
        style: TextStyle(color: ColorName.contentSecondary, fontSize: 13),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(
            l.cancel,
            style: TextStyle(color: ColorName.contentSecondary),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(
            l.logOut,
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

// ─────────────────────────────────────────
//  DELETE ACCOUNT BUTTON
// ─────────────────────────────────────────
Widget _buildDeleteAccountButton(
    BuildContext context, ProfileBloc profileBloc, AppLocalizations l) {
  const danger = Color(0xFFE5484D);
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: BlocBuilder<ProfileBloc, ProfileState>(
      buildWhen: (_, state) => state is DeleteAccountState,
      builder: (context, state) {
        final isLoading = state is DeleteAccountState &&
            state.state == BaseState.loading;

        return GestureDetector(
          onTap: isLoading
              ? null
              : () async {
                  final confirmed = await _confirmDeleteAccount(context);
                  if (confirmed == true) {
                    profileBloc.add(DeleteAccountEvent());
                  }
                },
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: danger.withValues(alpha: .08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: danger.withValues(alpha: .35)),
            ),
            child: isLoading
                ? const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: danger,
                        strokeWidth: 2,
                      ),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.delete_forever_rounded,
                        color: danger,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        l.deleteAccount,
                        style: const TextStyle(
                          color: danger,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    ),
  );
}

Future<bool?> _confirmDeleteAccount(BuildContext context) {
  const danger = Color(0xFFE5484D);
  final l = AppLocalizations.of(context);
  return showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: ColorName.backgroundSecondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(
        l.deleteAccountConfirmTitle,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      content: Text(
        l.deleteAccountConfirmMessage,
        style: TextStyle(color: ColorName.contentSecondary, fontSize: 13),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(
            l.cancel,
            style: TextStyle(color: ColorName.contentSecondary),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(
            l.deleteAccount,
            style: const TextStyle(
              color: danger,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}

// ─────────────────────────────────────────
//  VERSION LABEL
// ─────────────────────────────────────────
Widget _buildVersionLabel() {
  return Center(
    child: Text(
      '916TV v1.0.0',
      style: TextStyle(color: ColorName.contentSecondary, fontSize: 11),
    ),
  );
}

// ─────────────────────────────────────────
//  COMING SOON DIALOG
// ─────────────────────────────────────────
void _showComingSoonDialog(BuildContext context) {
  final l = AppLocalizations.of(context);
  showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: ColorName.backgroundSecondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(
        l.comingSoonTitle,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      content: Text(
        l.comingSoonMessage,
        style: TextStyle(color: ColorName.contentSecondary, fontSize: 13),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: Text(
            l.gotIt,
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
