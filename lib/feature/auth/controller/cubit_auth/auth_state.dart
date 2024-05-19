part of 'auth_cubit.dart';

abstract class AuthStates {}

class AuthInitialState extends AuthStates {}

class AuthLoadingState extends AuthStates {}

class AuthenticatedState extends AuthStates {
  final String sessionId;
  final int accountId;
  final String username;

  AuthenticatedState(this.sessionId, this.accountId, this.username);
}

class AuthErrorState extends AuthStates {
  final String message;

  AuthErrorState(this.message);
}
