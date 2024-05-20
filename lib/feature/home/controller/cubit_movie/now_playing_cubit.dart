import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task_abg/feature/home/model/movie_model.dart';
import 'package:flutter_task_abg/feature/home/model/repository_movie.dart';

part 'now_playing_state.dart';

class NowPlayingCubit extends Cubit<NowPlayingState> {
  NowPlayingCubit() : super(NowPlayingInitialState());

  RepositoryMovie repositoryMovie = RepositoryMovie();

  int currentPage = 1;
  bool isLoading = false;

  Future<void> fetchNowPlayingMovies() async {
    if (isLoading) return;

    try {
      isLoading = true;
      emit(NowPlayingMoviesLoadingState());
      final nowPlayingMoviesResponse =
          await repositoryMovie.fetchNowPlayingMovies(currentPage);
      emit(NowPlayingMoviesLoadedState(
        movies: nowPlayingMoviesResponse.results,
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
}
