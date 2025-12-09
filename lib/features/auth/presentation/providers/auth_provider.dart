import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vriddhiapps/features/auth/data/models/user_model.dart';
import 'package:vriddhiapps/features/auth/data/services/auth_service.dart';

final authServiceProvider = Provider((ref) {
  return AuthService();
});

/// Provides the current user
final currentUserProvider = FutureProvider<User?>((ref) async {
  final authService = ref.watch(authServiceProvider);
  await authService.initializeAuthBox();
  return authService.getCurrentUser();
});

/// Sign up state notifier
class SignUpNotifier extends StateNotifier<AsyncValue<void>> {
  final AuthService _authService;

  SignUpNotifier(this._authService) : super(const AsyncValue.data(null));

  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _authService.signUp(
        email: email,
        password: password,
        fullName: fullName,
        phoneNumber: phoneNumber,
      );
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

final signUpProvider = StateNotifierProvider<SignUpNotifier, AsyncValue<void>>((ref) {
  return SignUpNotifier(ref.watch(authServiceProvider));
});

/// Sign in state notifier
class SignInNotifier extends StateNotifier<AsyncValue<User?>> {
  final AuthService _authService;

  SignInNotifier(this._authService) : super(const AsyncValue.data(null));

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    try {
      final user = await _authService.signIn(email: email, password: password);
      state = AsyncValue.data(user);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

final signInProvider = StateNotifierProvider<SignInNotifier, AsyncValue<User?>>((ref) {
  return SignInNotifier(ref.watch(authServiceProvider));
});

/// Sign out action
final signOutProvider = FutureProvider<void>((ref) async {
  final authService = ref.watch(authServiceProvider);
  await authService.signOut();
});

/// Skip authentication action
final skipAuthProvider = FutureProvider<void>((ref) async {
  final authService = ref.watch(authServiceProvider);
  await authService.skipAuthentication();
});

/// Check if user is authenticated
final isAuthenticatedProvider = FutureProvider<bool>((ref) async {
  final authService = ref.watch(authServiceProvider);
  await authService.initializeAuthBox();
  return authService.isUserAuthenticated();
});
