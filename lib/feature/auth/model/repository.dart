import 'dart:convert';

import 'package:flutter_task_abg/feature/auth/model/model.dart';
import 'package:http/http.dart' as http;

class TMDBRepository {
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String apiKey = '0a63c2aed01c0d9c339a62a89d81a200';

  Future<RequestTokenResponseModel> createRequestToken() async {
    final response = await http
        .get(Uri.parse('$baseUrl/authentication/token/new?api_key=$apiKey'));
    if (response.statusCode == 200) {
      return RequestTokenResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create request token');
    }
  }


  Future<ValidateTokenResponseModel> validateRequestToken(String username, String password, String requestToken) async {
    final response = await http.post(
      Uri.parse('$baseUrl/authentication/token/validate_with_login?api_key=$apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
        'request_token': requestToken,
      }),
    );
    if (response.statusCode == 200) {
      return ValidateTokenResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to validate request token');
      //return ValidateTokenResponseModel.fromJson(jsonDecode(response.body));
    }
  }

  Future<CreateSessionResponseModel> createSession(String requestToken) async {
    final response = await http.post(
      Uri.parse('$baseUrl/authentication/session/new?api_key=$apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'request_token': requestToken}),
    );
    if (response.statusCode == 200) {
      return CreateSessionResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create session');
    }
  }

  Future<AccountDetailsResponseModel> getAccountDetails(String sessionId) async {
    final response = await http.get(Uri.parse('$baseUrl/account?api_key=$apiKey&session_id=$sessionId'));
    if (response.statusCode == 200) {
      return AccountDetailsResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get account details');
    }
  }


  Future<NowPlayingMoviesResponseModel> fetchNowPlayingMovies(int page) async {
    final response = await http.get(Uri.parse('$baseUrl/movie/now_playing?api_key=$apiKey&page=$page'));
    if (response.statusCode == 200) {
      return NowPlayingMoviesResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load now playing movies');
    }
  }



  Future<WatchlistResponseModel> addToWatchlist(int accountId, String sessionId, int movieId,bool watchlist) async {
    final response = await http.post(
      Uri.parse('$baseUrl/account/$accountId/watchlist?session_id=$sessionId&api_key=$apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'media_type': 'movie',
        'media_id': movieId,
        'watchlist': watchlist,
      }),
    );

    if (response.statusCode == 200) {
      return WatchlistResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update watchlist');
    }
  }
}
