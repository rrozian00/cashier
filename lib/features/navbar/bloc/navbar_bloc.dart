import 'package:bloc/bloc.dart';
import 'package:cashier/features/user/models/user_model.dart';
import 'package:cashier/features/user/repositories/user_repository.dart';
import 'package:equatable/equatable.dart';

part 'navbar_event.dart';
part 'navbar_state.dart';

class NavbarBloc extends Bloc<NavbarEvent, NavbarState> {
  final userRepo = UserRepository();

  NavbarBloc() : super(NavbarInitial()) {
    on<IndexChanged>((event, emit) {
      final curentState = state as NavbarSuccess;
      emit(curentState.copyWith(selectedIndex: event.index));
    });

    on<NavbarStarted>(
      (event, emit) async {
        emit(NavbarLoading());
        final res = await userRepo.getUserDataFromSupabase();
        res.fold((l) => emit(NavbarError(l.message)), (user) {
          emit(NavbarSuccess(user: user, selectedIndex: 0));
        });
      },
    );
  }
}
