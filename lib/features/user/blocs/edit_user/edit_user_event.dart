part of 'edit_user_bloc.dart';

sealed class EditUserEvent extends Equatable {
  const EditUserEvent();

  @override
  List<Object> get props => [];
}

// Event untuk edit
final class EditRequestedEvent extends EditUserEvent {
  final String id;
  final String name;
  final String address;
  final String phone;

  const EditRequestedEvent({
    required this.name,
    required this.address,
    required this.phone,
    required this.id,
  });

  @override
  List<Object> get props => [
        name,
        address,
        phone,
        id,
      ];
}
