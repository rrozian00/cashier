part of 'register_bloc.dart';

sealed class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object?> get props => [];
}

// Event untuk register
final class RegisterRequestedEvent extends RegisterEvent {
  final UserModel user;
  final String password;

  const RegisterRequestedEvent({
    required this.user,
    required this.password,
  });

  @override
  List<Object?> get props => [user, password];
}

// Event untuk edit
final class EditRequestedEvent extends RegisterEvent {
  final String name;
  final String address;
  final String phone;

  const EditRequestedEvent({
    required this.name,
    required this.address,
    required this.phone,
  });

  @override
  List<Object?> get props => [
        name,
        address,
        phone,
      ];
}
