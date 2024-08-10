import 'package:thecatredis/models/cat_model.dart';

sealed class CatState {}

class EmptyCatState extends CatState {}

class LoadingCatState extends CatState {}

class LoadedCatState extends CatState {
  final List<CatModel> cats;

  LoadedCatState(this.cats);
}

class ErrorCatState extends CatState {
  final String error;

  ErrorCatState(this.error);
}
