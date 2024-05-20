part of 'now_playing_cubit.dart';

@immutable
abstract  class NowPlayingState {}

final class NowPlayingInitialState extends NowPlayingState {}
class NowPlayingMoviesLoadingState extends NowPlayingState {}
class NowPlayingMoviesLoadedState extends NowPlayingState {
  final List<MovieModel> movies;
  final int currentPage;
  final int totalPages;

   NowPlayingMoviesLoadedState({
    required this.movies,
    required this.currentPage,
    required this.totalPages,
  });

}

class NowPlayingMoviesErrorState extends NowPlayingState {
  final String message;

   NowPlayingMoviesErrorState(this.message);

}

