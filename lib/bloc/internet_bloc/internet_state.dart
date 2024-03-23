part of 'internet_bloc.dart';

sealed class InternetState extends Equatable {
  const InternetState();

  @override
  List<Object> get props => [];
}

final class InternetInitialState extends InternetState {}

final class InternetConnectedState extends InternetState {
  final String message;
  const InternetConnectedState({required this.message});
}

final class InternetNotConnectedState extends InternetState {
  final String message;
  const InternetNotConnectedState({required this.message});
}
