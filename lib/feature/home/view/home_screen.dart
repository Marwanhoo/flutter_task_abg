import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task_abg/feature/auth/controller/cubit_auth/auth_cubit.dart';
import 'package:flutter_task_abg/feature/auth/controller/cubit_dark/theme_cubit.dart';
import 'package:flutter_task_abg/feature/auth/view/login_screen.dart';
import 'package:flutter_task_abg/feature/home/controller/cubit_movie/now_playing_cubit.dart';

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
                          Icon(themeCubit.themeMode == ThemeMode.light
                              ? Icons.dark_mode
                              : Icons.light_mode),
                          const SizedBox(width: 16),
                          Text(themeCubit.themeMode == ThemeMode.light
                              ? "Dark Mode"
                              : "Light Mode"),
                        ],
                      );
                    },
                  ),
                ),
                if (username != null)
                  const PopupMenuItem(
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
      body: NowPlayingMoviesView(
        context: context,
      ),
    );
  }
}

class NowPlayingMoviesView extends StatelessWidget {
  final ScrollController scrollController = ScrollController();

  NowPlayingMoviesView({super.key, required BuildContext context}) {
    scrollController.addListener(() {
      if (scrollController.position.atEdge &&
          scrollController.position.pixels != 0) {
        context.read<NowPlayingCubit>().fetchNowPlayingMovies();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NowPlayingCubit, NowPlayingState>(
      builder: (context, state) {
        if(state is NowPlayingInitialState || state is NowPlayingMoviesLoadingState && state is! NowPlayingMoviesLoadedState){
          return const Center(child: CircularProgressIndicator(),);
        }else if (state is NowPlayingMoviesErrorState){
          return Center(child: Text(state.message),);
        }else if(state is NowPlayingMoviesLoadedState){
          return ListView.builder(
            controller: scrollController,
            itemBuilder: (context, index) {
              final movie = state.movies[index];
              return ListTile(
                leading: Image.network('https://image.tmdb.org/t/p/w500${movie.posterPath}'),
                title: Text(movie.title),
                subtitle: Text(movie.overview),
              );
            },
            itemCount: state.movies.length,
          );
        }
        return Container();
      },
    );
  }
}
