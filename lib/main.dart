import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task_abg/feature/auth/controller/cubit_auth/auth_cubit.dart';
import 'package:flutter_task_abg/feature/auth/controller/cubit_auth/my_bloc_observer.dart';
import 'package:flutter_task_abg/feature/auth/controller/cubit_dark/theme_cubit.dart';
import 'package:flutter_task_abg/feature/auth/view/login_screen.dart';
import 'package:flutter_task_abg/feature/home/view/home_screen.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubit()..checkAuthentication(),
        ),
        BlocProvider(
          create: (context) => ThemeCubit()..loadThemeMode(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.light,
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.dark,
            ),
            themeMode: (state is AppChangeModeState)
                ? state.themeMode
                : ThemeMode.light,
            home: BlocBuilder<AuthCubit, AuthStates>(
              builder: (context, state) {
                if (state is AuthenticatedState) {
                  return HomeScreen(
                    username: state.username,
                  );
                } else {
                  return const LoginScreen();
                }
              },
            ),
          );
        },
      ),
    );
  }
}
