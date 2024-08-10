import 'package:thecatredis/models/cat_model.dart';

sealed class FavoritosState {}

class EmptyFavoritosState extends FavoritosState {}

class LoadingFavoritosState extends FavoritosState {}

class LoadedFavoritosState extends FavoritosState {
  final List<CatModel> favoritos;

  LoadedFavoritosState(this.favoritos);
}

class ErrorFavoritosState extends FavoritosState {
  final String error;

  ErrorFavoritosState(this.error);
}
