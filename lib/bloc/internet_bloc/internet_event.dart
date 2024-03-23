part of 'internet_bloc.dart';

sealed class InternetEvent extends Equatable {
  const InternetEvent();

  @override
  List<Object> get props => [];
}

class InternetInitialEvent extends InternetEvent {}

class InternetConnectedEvent extends InternetEvent {}

class InternetNotConnectedEvent extends InternetEvent {}
