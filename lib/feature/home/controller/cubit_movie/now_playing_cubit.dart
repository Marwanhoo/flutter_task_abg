import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task_abg/feature/home/model/movie_model.dart';
import 'package:flutter_task_abg/feature/home/model/repository_movie.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'now_playing_state.dart';

class NowPlayingCubit extends Cubit<NowPlayingState> {
  NowPlayingCubit() : super(NowPlayingInitialState());

  RepositoryMovie repositoryMovie = RepositoryMovie();

  int currentPage = 1;
  bool isLoading = false;
  List<MovieModel> movies = [];
  List<MovieModel> watchList = [];

  Future<void> fetchNowPlayingMovies() async {
    if (isLoading) return;

    try {
      isLoading = true;
      emit(NowPlayingMoviesLoadingState());
      final nowPlayingMoviesResponse =
          await repositoryMovie.fetchNowPlayingMovies(currentPage);
      movies.addAll(nowPlayingMoviesResponse.results);
      emit(NowPlayingMoviesLoadedState(
        movies: List.from(movies),
        currentPage: nowPlayingMoviesResponse.page,
        totalPages: nowPlayingMoviesResponse.totalPages,
      ));
      currentPage++;
      isLoading = false;
    } catch (e) {
      isLoading = false;
      emit(NowPlayingMoviesErrorState("Failed to load now playing movies"));
    }
  }



  Future<void> fetchWatchListMovies() async {
    final prefs = await SharedPreferences.getInstance();

    try {

      emit(WatchListMoviesLoadingState());
      final watchListResponse =
          await repositoryMovie.fetchWatchListMovies(prefs.getString('session_id'));
      emit(WatchListMoviesLoadedState(watchListResponse.results));
    } catch (e) {
      isLoading = false;
      emit(WatchListMoviesErrorState(e.toString()));
    }
  }
}
