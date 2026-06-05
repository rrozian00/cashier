part of 'navbar_bloc.dart';

sealed class NavbarEvent extends Equatable {
  const NavbarEvent();

  @override
  List<Object> get props => [];
}

final class IndexChanged extends NavbarEvent {
  final int index;
  const IndexChanged(this.index);

  @override
  List<Object> get props => [index];
}

final class NavbarStarted extends NavbarEvent {}
