import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/firebase/firebase_auth_service.dart';
import '../../../../core/firebase/firebase_analytics_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final IFirebaseAuthService _authService;
  final IFirebaseAnalyticsService _analyticsService;

  AuthBloc({
    required IFirebaseAuthService authService,
    required IFirebaseAnalyticsService analyticsService,
  })  : _authService = authService,
        _analyticsService = analyticsService,
        super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<SignInRequested>(_onSignInRequested);
    on<SignOutRequested>(_onSignOutRequested);
    on<BypassSignInRequested>(_onBypassSignInRequested);
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    final user = _authService.currentUser;
    if (user != null || _authService.isBypassed) {
      emit(Authenticated(user));
    } else {
      emit(Unauthenticated());
    }
  }

  Future<void> _onSignInRequested(
    SignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(Authenticating());
    try {
      final userCredential = await _authService.signInWithGoogle();
      final user = userCredential.user;
      if (user != null) {
        await _analyticsService.logLogin();
        emit(Authenticated(user));
      } else {
        emit(const AuthError('Google Sign-In returned null user.'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onBypassSignInRequested(
    BypassSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(Authenticating());
    try {
      await _authService.signInBypass();
      await _analyticsService.logLogin();
      emit(const Authenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignOutRequested(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(Authenticating());
    try {
      await _authService.signOut();
      await _analyticsService.logLogout();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
