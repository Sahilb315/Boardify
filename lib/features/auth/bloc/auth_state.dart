part of 'auth_bloc.dart';

@immutable
sealed class AuthState {
  const AuthState();
}

abstract class AuthActionState extends AuthState {
  const AuthActionState();
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

class GoogleAuthSuccessfulActionState extends AuthActionState {
  final UserCredential? userCredential;
  const GoogleAuthSuccessfulActionState({required this.userCredential});
}

class GoogleAuthFailureActionState extends AuthActionState {
  final String message;
  const GoogleAuthFailureActionState({
    required this.message,
  });
}

class AuthLoadingActionState extends AuthActionState {
  const AuthLoadingActionState();
}
