import 'package:flutter_application_api_bloc/features/home/data/repository/home_repository_implement.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepositoryImplement repository;

  HomeCubit({required this.repository}) : super(HomeInitialState());
  static HomeCubit get(context) => BlocProvider.of(context);

  Future<void> fetchUserData(String userId) async {
    emit(HomeLoadingState());
    try {
      final user = await repository.getUserData(userId);
      emit(HomeLoadedState(user));
    } catch (e) {
      emit(HomeErrorState(e.toString()));
    }
  }
}
