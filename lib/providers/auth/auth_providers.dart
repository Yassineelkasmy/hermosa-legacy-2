import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hermosa/application/auth/auth_event.dart';
import 'package:hermosa/application/auth/auth_form/auth_form_state.dart';
import 'package:hermosa/application/auth/auth_form/auth_form_controller.dart';
import 'package:hermosa/application/auth/auth_state.dart';
import 'package:hermosa/application/auth/auth_controller.dart';
import 'package:hermosa/domain/auth/user.dart';
import 'package:hermosa/infrastructure/auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final firebaseAuthFacadeProvider =
    Provider.autoDispose<FireBaseAuthFacade>((ref) {
  final firebaseAuth = FirebaseAuth.instance;
  final googleSignIn = GoogleSignIn();
  final fireBaseAuthFacade = FireBaseAuthFacade(
    firebaseAuth,
    googleSignIn,
  );
  return fireBaseAuthFacade;
});

final authtProvider =
    StateNotifierProvider.autoDispose<AuthController, AuthState>((ref) {
  final fireBaseAuthFacade = ref.watch(firebaseAuthFacadeProvider);

  AuthController authController = AuthController(fireBaseAuthFacade);
  return authController..mapEventToState(const AuthEvent.authCheckRequested());
});

final authFormProvider =
    StateNotifierProvider.autoDispose<AuthFormController, AuthFormState>(
  (ref) {
    final fireBaseAuthFacade = ref.watch(firebaseAuthFacadeProvider);
    final authController = ref.watch(authtProvider.notifier);
    final authFormController = AuthFormController(
      fireBaseAuthFacade,
      authController,
    );
    return authFormController;
  },
);

final userProvider = Provider.autoDispose<User?>((ref) {
  final authState = ref.watch(authtProvider);
  return authState.maybeMap(
    authenticated: (authenticated) => authenticated.user,
    orElse: () => null,
  );
});
