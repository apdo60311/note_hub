part of 'register_bloc.dart';

sealed class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class RegisterRequested extends RegisterEvent {
  final User user;
  final String password;
  final File? imageFile;

  const RegisterRequested(
      {required this.user, required this.password, this.imageFile});
}
