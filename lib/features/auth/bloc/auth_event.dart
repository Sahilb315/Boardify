part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class SignInUserWithGoogleEvent extends AuthEvent {}
