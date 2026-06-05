part of 'navbar_bloc.dart';

sealed class NavbarState extends Equatable {
  const NavbarState();

  @override
  List<Object> get props => [];
}

final class NavbarInitial extends NavbarState {}

final class NavbarLoading extends NavbarState {}

final class NavbarError extends NavbarState {
  final String message;
  const NavbarError(this.message);

  @override
  List<Object> get props => [message];
}

final class NavbarSuccess extends NavbarState {
  final UserModel user;
  final int selectedIndex;
  const NavbarSuccess({
    required this.user,
    required this.selectedIndex,
  });
  NavbarSuccess copyWith({
    int? selectedIndex,
    UserModel? user,
  }) {
    return NavbarSuccess(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      user: user ?? this.user,
    );
  }

  @override
  List<Object> get props => [user, selectedIndex];
}
