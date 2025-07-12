import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce_store_with_bloc/user_profile/bloc/user_event.dart';
import 'package:e_commerce_store_with_bloc/user_profile/bloc/user_state.dart';
import 'package:e_commerce_store_with_bloc/user_profile/data/repositories/user_repository.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc({required this.userRepository}) : super(UserInitial()) {
    on<FetchUserDetails>(_onFetchUserDetails);
  }

  Future<void> _onFetchUserDetails(
    FetchUserDetails event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    try {
      final user = await userRepository.getUserDetails(event.userId);
      emit(UserLoaded(user: user));
    } catch (e) {
      emit(UserError(message: e.toString()));
    }
  }
}
