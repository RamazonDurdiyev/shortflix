import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shortflix/core/utils/base_state.dart';
import 'package:shortflix/gen/colors.gen.dart';
import 'package:shortflix/src/models/user_model/user_model.dart';
import 'package:shortflix/src/services/navigation.dart';
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
      create: (_) =>
          ProfileBloc(userRepo: GetIt.instance.get())..add(FetchUserEvent()),
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
    return Scaffold(
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
                _buildTopBar(context),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _buildProfileHeader(
                        user: user,
                        isLoading: isLoading,
                        onEditTap: openEditProfile,
                      ),
                      _buildStatsRow(),
                      const SizedBox(height: 8),
                      _buildSectionTitle('Account'),
                      _buildMenuGroup([
                        _MenuItem(
                          icon: Icons.person_outline_rounded,
                          label: 'Edit Profile',
                          onTap: openEditProfile,
                        ),
                        _MenuItem(
                          icon: Icons.lock_outline_rounded,
                          label: 'Privacy & Security',
                        ),
                        _MenuItem(
                          icon: Icons.language_rounded,
                          label: 'Language',
                          trailing: _buildValueLabel('English'),
                        ),
                      ]),
                      _buildSectionTitle('Support'),
                      _buildMenuGroup([
                        _MenuItem(
                          icon: Icons.help_outline_rounded,
                          label: 'Help Center',
                        ),
                        _MenuItem(
                          icon: Icons.info_outline_rounded,
                          label: 'About',
                        ),
                      ]),
                      const SizedBox(height: 16),
                      _buildLogoutButton(),
                      const SizedBox(height: 8),
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
Widget _buildTopBar(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
    child: Row(
      children: [
        const SizedBox(width: 14),
        const Expanded(
          child: Text(
            'Profile',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.3,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: ColorName.backgroundSecondary,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: ColorName.surfaceSecondary),
            ),
            child: const Icon(
              Icons.settings_outlined,
              color: Colors.white,
              size: 20,
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
  required UserModel? user,
  required bool isLoading,
  required VoidCallback onEditTap,
}) {
  final fullName = user?.fullName ?? (isLoading ? '...' : 'Someone');
  final email = user?.email ?? (isLoading ? '...' : 'someone@email.com');
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
                      'Premium',
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
Widget _buildStatsRow() {
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
        _buildStatItem('48', 'Watched'),
        _buildStatDivider(),
        _buildStatItem('12', 'Watchlist'),
        _buildStatDivider(),
        _buildStatItem('36', 'Liked'),
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
Widget _buildLogoutButton() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: GestureDetector(
      onTap: () {},
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: ColorName.accent.withValues(alpha: .08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: ColorName.accent.withValues(alpha: .3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_rounded, color: ColorName.accent, size: 18),
            const SizedBox(width: 8),
            Text(
              'Log Out',
              style: TextStyle(
                color: ColorName.accent,
                fontSize: 14,
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
//  VERSION LABEL
// ─────────────────────────────────────────
Widget _buildVersionLabel() {
  return Center(
    child: Text(
      'Shortflix v1.0.0',
      style: TextStyle(color: ColorName.contentSecondary, fontSize: 11),
    ),
  );
}
