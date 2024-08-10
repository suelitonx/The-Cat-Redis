import 'package:flutter/material.dart';
import 'package:thecatredis/states/favoritos_state.dart';

import '../models/cat_model.dart';
import '../services/favoritos_service.dart';

class FavoritosStore extends ValueNotifier<FavoritosState> {
  FavoritosStore() : super(EmptyFavoritosState());

  final service = FavoritosService();

  Future<void> getFavoritos() async {
    value = LoadingFavoritosState();

    final (r, l, m) = await service.getAll();

    if (r) {
      value = LoadedFavoritosState(l);
    } else {
      value = ErrorFavoritosState(m);
    }
  }

  Future<(bool r, String m)> adicionarFavorito(CatModel cat) async {
    final result = await service.addCat(cat);

    if (result.$1) {
      final currentState = value;
      if (currentState is LoadedFavoritosState) {
        final favoritos = currentState.favoritos;
        favoritos.add(cat);
        value = LoadedFavoritosState(favoritos);
      }
    }

    return result;
  }

  Future<(bool r, String m)> removerFavorito(CatModel cat) async {
    final currentState = value;
    if (currentState is LoadedFavoritosState) {
      final favoritos = currentState.favoritos;

      final (r, m) = await service.removeCat(cat);

      if (r) {
        favoritos.remove(cat);
        value = LoadedFavoritosState(favoritos);
      }

      return (r, m);
    }
    return (false, 'Favoritos não carregados.');
  }
}
