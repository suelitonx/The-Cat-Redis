import 'package:flutter/foundation.dart';
import 'package:thecatredis/states/cats_state.dart';

import '../services/cat_service.dart';

class CatsStore extends ValueNotifier<CatState> {
  CatsStore() : super(EmptyCatState());

  final service = CatService();

  Future<void> getImages({bool realAPI = false}) async {
    value = LoadingCatState();

    final (cats, r) = await service.getImages(realAPI: realAPI);

    if (r) {
      value = LoadedCatState(cats);
    } else {
      value = ErrorCatState('Erro ao carregar imagens');
    }
  }
}
