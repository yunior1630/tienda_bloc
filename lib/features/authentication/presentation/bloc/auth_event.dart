import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SignInWithGoogleEvent extends AuthEvent {}

class SignInWithEmailEvent extends AuthEvent {
  final String email;
  final String password;

  SignInWithEmailEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class SignInWithPinEvent extends AuthEvent {
  final String pin;

  SignInWithPinEvent({required this.pin});

  @override
  List<Object?> get props => [pin];
}

class SignOutEvent extends AuthEvent {}

class CheckAuthEvent extends AuthEvent {}
