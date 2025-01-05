part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  
  final bool isLoginMode;

  const AuthState(this.isLoginMode);

  @override
  List<Object> get props => [isLoginMode];
}

final class AuthInitial extends AuthState {
  AuthInitial(super.isLoginMode);
}

class AuthError extends AuthState{
  final AppException exception;
  AuthError(super.isLoginMode, this.exception);
}

class AuthLoading extends AuthState{
  AuthLoading(super.isLoginMode);
}

class AuthSuccess extends AuthState{
  AuthSuccess(super.isLoginMode);
}