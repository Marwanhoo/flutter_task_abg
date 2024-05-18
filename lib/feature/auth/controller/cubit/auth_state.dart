part of 'auth_cubit.dart';

abstract class AuthStates {}

class AuthInitialState extends AuthStates {}

class AuthLoadingState extends AuthStates {}

class AuthenticatedState extends AuthStates {
  final String sessionId;
  final int accountId;

  AuthenticatedState(this.sessionId, this.accountId);
}

class AuthErrorState extends AuthStates {
  final String message;

  AuthErrorState(this.message);
}
