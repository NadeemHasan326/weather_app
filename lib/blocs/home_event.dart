import 'package:flutter/material.dart';

abstract class HomeEvent {}

class InitEvent extends HomeEvent {
  BuildContext context;
  InitEvent({required this.context});
}

class SearchWheatherEvent extends HomeEvent {
  BuildContext context;
  SearchWheatherEvent({required this.context});
}
