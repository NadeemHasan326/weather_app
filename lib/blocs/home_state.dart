abstract class HomeState {}

class InitState extends HomeState {}

class LoadingState extends HomeState {}

class ItemLoadingState extends HomeState {}

class SuccessfullState extends HomeState {}

class UpdateUIState extends HomeState {}

class FailureState extends HomeState {
  String message;
  FailureState({required this.message});
}
