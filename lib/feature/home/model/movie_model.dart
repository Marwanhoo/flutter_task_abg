class MovieModel {
  final String title;
  final String overview;
  final String posterPath;

  MovieModel({required this.title, required this.overview, required this.posterPath});

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      title: json['title'],
      overview: json['overview'],
      posterPath: json['poster_path'],
    );
  }
}

class NowPlayingMoviesResponse {
  final List<MovieModel> results;
  final int page;
  final int totalPages;

  NowPlayingMoviesResponse({
    required this.results,
    required this.page,
    required this.totalPages,
  });

  factory NowPlayingMoviesResponse.fromJson(Map<String, dynamic> json) {
    var list = json['results'] as List;
    List<MovieModel> moviesList = list.map((i) => MovieModel.fromJson(i)).toList();

    return NowPlayingMoviesResponse(
      results: moviesList,
      page: json['page'],
      totalPages: json['total_pages'],
    );
  }
}
