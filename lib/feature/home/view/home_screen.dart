import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task_abg/feature/auth/controller/cubit_auth/auth_cubit.dart';
import 'package:flutter_task_abg/feature/auth/view/login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, this.username});

  final String? username;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Text("Hello ${username ?? "Guest"}"),
          if(username != null) ElevatedButton(
            onPressed: () {
              //BlocProvider.of<AuthCubit>(context).logout();
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Logout"),
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
            },
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }
}
