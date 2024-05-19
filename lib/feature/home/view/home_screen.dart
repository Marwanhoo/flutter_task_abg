import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task_abg/feature/auth/controller/cubit_auth/auth_cubit.dart';
import 'package:flutter_task_abg/feature/auth/controller/cubit_dark/theme_cubit.dart';
import 'package:flutter_task_abg/feature/auth/view/login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, this.username});

  final String? username;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hello ${username ?? "Guest"}"),
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              if (value == "theme") {
                BlocProvider.of<ThemeCubit>(context).changeAppMode();
              }
              if (value == "logout") {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Logout"),
                      content: const Text("Are you sure you want to logout?"),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            BlocProvider.of<AuthCubit>(context).logout();
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (_) => const LoginScreen()),
                                    (route) => false);
                          },
                          child: const Text("Ok"),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("Cancel")),
                      ],
                    );
                  },
                );
              }
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: "theme",
                  child: BlocBuilder<ThemeCubit, ThemeState>(
                    builder: (context, state) {
                      final themeCubit = BlocProvider.of<ThemeCubit>(context);
                      return Row(
                        children: [
                          Icon(themeCubit.themeMode == ThemeMode.light ? Icons.dark_mode : Icons.light_mode),
                          const SizedBox(width: 16),
                          Text(themeCubit.themeMode == ThemeMode.light ? "Dark Mode" : "Light Mode"),
                        ],
                      );
                    },
                  ),
                ),
                if(username != null) const PopupMenuItem(
                  value: "logout",
                  child: Row(
                    children: [
                      Icon(Icons.logout),
                      SizedBox(width: 16),
                      Text("Logout"),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: const Column(
        children: [
        ],
      ),
    );
  }
}
