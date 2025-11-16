import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wheather_app/blocs/home_bloc/home_event.dart';
import 'package:wheather_app/blocs/home_bloc/home_state.dart';
import 'package:wheather_app/models/wheather_model.dart';
import 'package:wheather_app/services/wheather_service.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  TextEditingController controller = TextEditingController();
  WheatherModel? wheatherModel;

  HomeBloc() : super(InitState()) {
    on<InitEvent>((event, emit) async {
      emit(LoadingState());
      await Future.delayed(Duration(seconds: 2));
      emit(UpdateUIState());
    });

    on<SearchWheatherEvent>((event, emit) async {
      emit(ItemLoadingState());
      Future.delayed(Duration(seconds: 1));
      try {
        if (controller.text.isNotEmpty) {
          wheatherModel = await WheatherService.getWheather(
            cityName: controller.text.trim(),
          );
          controller.text = "";
          if (wheatherModel?.name?.isEmpty ?? true) {
            emit(FailureState(message: "Weather not found"));
          }
        } else {
          emit(FailureState(message: "Please enter city name"));
        }
      } catch (e) {
        log("Error: ${e.toString()}");
        emit(FailureState(message: "Something went wrong"));
      }
      emit(UpdateUIState());
    });
  }
}
