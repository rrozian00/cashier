part of 'edit_profile_bloc.dart';

sealed class EditProfileEvent extends Equatable {
  const EditProfileEvent();

  @override
  List<Object> get props => [];
}

// Event untuk edit
final class EditProfileSubmitted extends EditProfileEvent {
  final UserModel user;
  final String name;
  final String address;
  final String phone;

  const EditProfileSubmitted({
    required this.name,
    required this.address,
    required this.phone,
    required this.user,
  });

  @override
  List<Object> get props => [
        name,
        address,
        phone,
        user,
      ];
}
