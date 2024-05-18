import 'package:bloc/bloc.dart';
import 'package:flutter_task_abg/feature/auth/model/repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(AuthInitialState());

  final TMDBRepository repository = TMDBRepository();

  Future<void> authenticate(String username, String password) async {
    try {
      emit(AuthLoadingState());

      final requestTokenResponse = await repository.createRequestToken();
      final validateTokenResponse = await repository.validateRequestToken(username, password, requestTokenResponse.requestToken);

      if (!validateTokenResponse.success) {
        emit(AuthErrorState(validateTokenResponse.statusMessage));
        return;
      }

      final createSessionResponse = await repository.createSession(requestTokenResponse.requestToken);

      final accountDetailsResponse = await repository.getAccountDetails(createSessionResponse.sessionId);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('session_id', createSessionResponse.sessionId);
      await prefs.setInt('account_id', accountDetailsResponse.id);

      emit(AuthenticatedState(createSessionResponse.sessionId, accountDetailsResponse.id));
    } catch (e) {
      emit(AuthErrorState(e.toString()));
    }
  }

  Future<void> checkAuthentication() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionId = prefs.getString('session_id');
    final accountId = prefs.getInt('account_id');

    if (sessionId != null && accountId != null) {
      emit(AuthenticatedState(sessionId, accountId));
    } else {
      emit(AuthInitialState());
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('session_id');
    await prefs.remove('account_id');
    emit(AuthInitialState());
  }

}