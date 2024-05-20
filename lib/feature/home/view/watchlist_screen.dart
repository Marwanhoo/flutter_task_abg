import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task_abg/feature/auth/controller/cubit_auth/auth_cubit.dart';
import 'package:flutter_task_abg/feature/home/controller/cubit_movie/now_playing_cubit.dart';

class WatchListScreen extends StatefulWidget {
  const WatchListScreen({super.key});

  @override
  State<WatchListScreen> createState() => _WatchListScreenState();
}

class _WatchListScreenState extends State<WatchListScreen> {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<NowPlayingCubit>(context).fetchWatchListMovies();
    return Scaffold(
      appBar: AppBar(
        title: const Text("WatchList"),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
              BlocProvider.of<NowPlayingCubit>(context).fetchNowPlayingMovies();
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: BlocConsumer<NowPlayingCubit, NowPlayingState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is WatchListMoviesLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is WatchListMoviesErrorState) {
            return Center(
              child: Text(state.error),
            );
          } else if (state is WatchListMoviesLoadedState) {
            return GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10,
                mainAxisExtent: 300,
              ),
              itemBuilder: (context, index) {
                final movie = state.movies[index];
                return Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Stack(
                          alignment: Alignment.topRight,
                          children: [
                            SizedBox(
                              width: double.infinity,
                              height: 300,
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
                                child: IconButton(onPressed: (){
                                  BlocProvider.of<AuthCubit>(context).addToWatchlist(movie.id, false);
                                  setState(() {
                                    BlocProvider.of<NowPlayingCubit>(context).fetchWatchListMovies();

                                  });
                                }, icon:const Icon(Icons.delete,color: Colors.red,)),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(16),
                              bottomLeft: Radius.circular(16),
                            ),
                            color: Colors.black.withOpacity(0.8),
                          ),

                          child: Text(
                            textAlign: TextAlign.center,
                            movie.title,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),

                  ],
                );
              },
              itemCount: state.movies.length,
            );
          }
          return Container();
        },
      ),
    );
  }
}
