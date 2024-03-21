// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:trello_clone/features/auth/repo/auth_repo.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthInitial()) {
    on<SignInUserWithGoogleEvent>(signInUserWithGoogleEvent);
  }

  final AuthRepo authRepo = AuthRepo();

  FutureOr<void> signInUserWithGoogleEvent(
      SignInUserWithGoogleEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoadingActionState());
    final result = await authRepo.signInUserWithGoogle();
    if (result is GoogleAuthSuccessfulActionState) {

      emit(GoogleAuthSuccessfulActionState(
        userCredential: result.userCredential,
      ));
    } else if (result is GoogleAuthFailureActionState) {
      emit(GoogleAuthFailureActionState(message: result.message));
    }
  }
}
