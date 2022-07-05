import 'package:flutter/material.dart';
import 'package:the_movie_app/domain/api_client/api_client.dart';
import 'package:the_movie_app/domain/data_providers/session_data_provider.dart';
import 'package:the_movie_app/models/movie.dart';
import 'package:the_movie_app/ui/navigation/main_navigation.dart';

class FavoriteMovies extends StatefulWidget {
  const FavoriteMovies({Key? key}) : super(key: key);

  @override
  State<FavoriteMovies> createState() => _FavoriteMoviesState();
}

class _FavoriteMoviesState extends State<FavoriteMovies> {
  List<Movie> favoriteMovies = [];
  late int accountId;

  void getFavoriteMovies() async {
    final sessionId = await SessionDataProvider().getSessionId();
    accountId = await ApiClient().getAccountId(sessionId ?? '');
    final movi = await ApiClient()
        .getFavoriteMovies(sessionId: sessionId ?? '', accountId: accountId);
    favoriteMovies.addAll(movi);
  }

  @override
  void initState() {
    super.initState();
    getFavoriteMovies();
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   getFavoriteMovies();
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: favoriteMovies.map((e) {
        return Row(
          children: [
            Text(
              e.title,
              style: const TextStyle(color: Colors.red),
            ),
            Image(
              width: 50,
              image: NetworkImage(
                ApiClient().imgUrl(e.backdropPath ?? ''),
              ),
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    MainNavigationRouteNames.movieDetails,
                    arguments: e.id,
                  );
                },
                child: const Text('datax'))
          ],
        );
      }).toList(),
    );
  }
}
