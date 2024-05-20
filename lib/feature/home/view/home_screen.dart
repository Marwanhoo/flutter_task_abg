import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task_abg/feature/auth/controller/cubit_auth/auth_cubit.dart';
import 'package:flutter_task_abg/feature/auth/controller/cubit_dark/theme_cubit.dart';
import 'package:flutter_task_abg/feature/auth/view/login_screen.dart';
import 'package:flutter_task_abg/feature/home/controller/cubit_movie/now_playing_cubit.dart';
import 'package:flutter_task_abg/feature/home/view/watchlist_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, this.username});

  final String? username;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome ${username ?? "Guest"}"),
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
              if (value == "watchlist") {
                if (username != null) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const WatchListScreen()));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please Log In")),
                  );
                }
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
                const PopupMenuItem(
                  value: "watchlist",
                  child: Row(
                    children: [
                      Icon(Icons.movie),
                      SizedBox(width: 16),
                      Text("Watchlist"),
                    ],
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
  final String? username;

  NowPlayingMoviesView({super.key, required BuildContext context, this.username}) {
    scrollController.addListener(() {
      if (scrollController.position.atEdge &&
          scrollController.position.pixels != 0) {
        context.read<NowPlayingCubit>().fetchNowPlayingMovies();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NowPlayingCubit, NowPlayingState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is NowPlayingInitialState ||
            state is NowPlayingMoviesLoadingState &&
                state is! NowPlayingMoviesLoadedState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is NowPlayingMoviesErrorState) {
          return Center(
            child: Text(state.message),
          );
        } else if (state is NowPlayingMoviesLoadedState) {
          return ListView.separated(
            controller: scrollController,
            itemBuilder: (context, index) {
              final movie = state.movies[index];
              final isDarkTheme =
                  Theme.of(context).brightness == Brightness.dark;

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: isDarkTheme ? Colors.grey[800] : Colors.white10,
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        alignment: Alignment.topRight,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: 200,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Image.network(
                                'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              child: IconButton(
                                onPressed: () {
                                  if (username != null) {
                                    AuthStates state =
                                        BlocProvider.of<AuthCubit>(context).state;
                                    BlocProvider.of<AuthCubit>(context)
                                        .addToWatchlist(movie.id, true);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Please Log In")),
                                    );
                                  }


                                },
                                icon: const Icon(Icons.favorite_border),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        movie.title,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isDarkTheme ? Colors.white : Colors.black,
                            ),
                      ),
                      Text(
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        movie.overview,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color:
                                  isDarkTheme ? Colors.white70 : Colors.black54,
                            ),
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => const Divider(
              indent: 75,
              endIndent: 75,
            ),
            itemCount: state.movies.length,
          );
        }
        return Container();
      },
    );
  }
}
