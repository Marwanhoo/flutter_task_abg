import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task_abg/feature/auth/controller/cubit/auth_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key,  this.username});
  final String? username;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
           Text("Hello ${username ?? "Guest"}"),
          ElevatedButton(onPressed: (){
            BlocProvider.of<AuthCubit>(context).logout();
          }, child: const Text("Logout"),),
        ],
      ),
    );
  }
}
