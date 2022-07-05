import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:the_movie_app/domain/api_client/api_client.dart';
import 'package:the_movie_app/domain/data_providers/session_data_provider.dart';
import 'package:the_movie_app/models/movie_details.dart';

class MovieDetailsModel extends ChangeNotifier {
  final _apiClient = ApiClient();
  final _sessionDataProvider = SessionDataProvider();
  MovieDetails? movieDetails;
  bool _isFavorite = false;
  late String successAddToFavoritesMessage = '';

  bool get isFavorite => _isFavorite;

  Future<void> getMovieDetails(int movieId) async {
    movieDetails = await _apiClient.getMovieDetails(movieId);
    final sessionId = await _sessionDataProvider.getSessionId();
    if (sessionId != null) {
      _isFavorite = await _apiClient.isFavorit(movieId, sessionId);
    }
    notifyListeners();
  }

  Future<void> toggleFavorite() async {
    final sessionId = await _sessionDataProvider.getSessionId();
    final accountId = await _sessionDataProvider.getAccountId();
    if (sessionId == null || accountId == null) return;
    // Сперва меняем иконку избранного
    _isFavorite = !_isFavorite;
    notifyListeners();
    try {
      successAddToFavoritesMessage = await _apiClient.markAsFavorite(
        accountId: accountId,
        sessionId: 'sessionId',
        mediaType: 'movie',
        mediaId: 453395,
        isFavorite: _isFavorite,
      );
    } on DioError catch (e) {
      final error = e.response?.data['status_message'] as String;
      print(error);
    }
  }

  void setFavorite() {
    _isFavorite = !_isFavorite;
    notifyListeners();
  }
}

class MovieDetailsModelProvider extends InheritedNotifier {
  final MovieDetailsModel model;
  const MovieDetailsModelProvider({
    Key? key,
    required Widget child,
    required this.model,
  }) : super(
          key: key,
          child: child,
          notifier: model,
        );

  static MovieDetailsModelProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<MovieDetailsModelProvider>();
  }

  static MovieDetailsModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<MovieDetailsModelProvider>()
        ?.widget;
    return widget is MovieDetailsModelProvider ? widget : null;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}
