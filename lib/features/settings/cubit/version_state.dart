part of 'version_cubit.dart';

sealed class VersionState extends Equatable {
  const VersionState();

  @override
  List<Object> get props => [];
}

final class VersionInitial extends VersionState {}
