import 'package:e_commerce_store_with_bloc/core/routes/app_routes.dart';
import 'package:e_commerce_store_with_bloc/core/theme/theme_bloc/theme_bloc.dart';
import 'package:e_commerce_store_with_bloc/core/theme/theme_bloc/theme_event.dart';
import 'package:e_commerce_store_with_bloc/core/theme/theme_bloc/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce_store_with_bloc/auth/bloc/auth_bloc.dart';
import 'package:e_commerce_store_with_bloc/auth/bloc/auth_event.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'E-Commerce App',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your Shopping Destination',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                      ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.userProfile);
            },
          ),
          BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, themeState) {
              // Helper to get the display name for the current theme mode
              String getThemeModeDisplayName(ThemeMode mode) {
                switch (mode) {
                  case ThemeMode.system:
                    return 'System';
                  case ThemeMode.light:
                    return 'Light';
                  case ThemeMode.dark:
                    return 'Dark';
                }
              }

              return ListTile(
                leading: const Icon(Icons.brightness_6),
                title: const Text('Theme Mode'),
                subtitle: Text(getThemeModeDisplayName(themeState.themeMode)),
                trailing: PopupMenuButton<ThemeMode>(
                  icon: const Icon(Icons.arrow_forward_ios),
                  onSelected: (ThemeMode selectedMode) {
                    context.read<ThemeBloc>().add(ToggleTheme(selectedMode));
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<ThemeMode>>[
                    PopupMenuItem<ThemeMode>(
                      value: ThemeMode.system,
                      child: Text('System'),
                    ),
                    PopupMenuItem<ThemeMode>(
                      value: ThemeMode.light,
                      child: Text('Light'),
                    ),
                    PopupMenuItem<ThemeMode>(
                      value: ThemeMode.dark,
                      child: Text('Dark'),
                    ),
                  ],
                ),
                onTap: () {},
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              Navigator.pop(context);
              BlocProvider.of<AuthBloc>(context).add(AuthLogoutRequested());
              Navigator.pushNamedAndRemoveUntil(
                  context, AppRoutes.login, (route) => false);
            },
          ),
        ],
      ),
    );
  }
}
