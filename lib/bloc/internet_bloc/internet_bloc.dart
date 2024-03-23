import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

part 'internet_event.dart';
part 'internet_state.dart';

class InternetBloc extends Bloc<InternetEvent, InternetState> {
  InternetBloc() : super(InternetInitialState()) {
    on<InternetInitialEvent>(_internetInitial);
    on<InternetConnectedEvent>(_internetConnected);
    on<InternetNotConnectedEvent>(_internetDisConnected);
  }

  void _internetInitial(event, emit) {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.wifi ||
          result == ConnectivityResult.mobile ||
          result == ConnectivityResult.ethernet) {
        add(InternetConnectedEvent());
      } else {
        add(InternetNotConnectedEvent());
      }
    });
  }

  void _internetConnected(event, emit) {
    emit(const InternetConnectedState(message: "Internet Connected"));
  }

  void _internetDisConnected(event, emit) {
    emit(const InternetNotConnectedState(message: "Internet Not Connected"));
  }
}
