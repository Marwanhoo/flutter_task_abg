import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task_abg/feature/auth/controller/cubit/auth_cubit.dart';
import 'package:flutter_task_abg/feature/auth/controller/cubit/my_bloc_observer.dart';
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
          create: (context) =>
          AuthCubit()
            ..checkAuthentication(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          useMaterial3: true,
        ),
        home: BlocBuilder<AuthCubit, AuthStates>(
          builder: (context, state) {
            if(state is AuthenticatedState){
              return  HomeScreen(username: state.username,);
            }else{
              return const LoginScreen();
            }

          },
        ),
      ),
    );
  }
}
