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
              final isDarkMode = themeState.themeMode == ThemeMode.dark;
              return ListTile(
                leading: const Icon(Icons.brightness_6),
                title: const Text('Toggle Theme'),
                trailing: Switch(
                  value: isDarkMode,
                  onChanged: (bool value) {
                    context.read<ThemeBloc>().add(ToggleTheme(value));
                  },
                  activeColor: Theme.of(context).colorScheme.primary,
                  inactiveThumbColor: Colors.grey,
                  inactiveTrackColor: Colors.grey[300],
                ),
                onTap: () {
                  // Tapping the list tile also toggles the switch
                  context.read<ThemeBloc>().add(ToggleTheme(!isDarkMode));
                },
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
