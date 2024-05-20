import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task_abg/feature/home/controller/cubit_movie/now_playing_cubit.dart';

class WatchListScreen extends StatelessWidget {
  const WatchListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<NowPlayingCubit>(context).fetchWatchListMovies();
    return Scaffold(
      appBar: AppBar(
        title: const Text("WatchList"),
        leading: IconButton(onPressed: (){
          Navigator.of(context).pop();
          BlocProvider.of<NowPlayingCubit>(context).fetchNowPlayingMovies();
        }, icon: Icon(Icons.arrow_back)),
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
            return ListView.separated(
              itemBuilder: (context, index) {
                final movie = state.movies[index];

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
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
                                  onPressed: () {},
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
                              ),
                        ),
                        Text(
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          movie.overview,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(),
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
      ),
    );
  }
}
