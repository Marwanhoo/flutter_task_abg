import 'dart:convert';
import 'package:flutter_task_abg/feature/home/model/movie_model.dart';
import 'package:http/http.dart' as http;

class RepositoryMovie {
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String apiKey = '0a63c2aed01c0d9c339a62a89d81a200';

  Future<NowPlayingMoviesResponse> fetchNowPlayingMovies(int page) async {
    final response = await http.get(Uri.parse('$baseUrl/movie/now_playing?api_key=$apiKey&page=$page'));
    if (response.statusCode == 200) {
      return NowPlayingMoviesResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load now playing movies');
    }
  }
}
