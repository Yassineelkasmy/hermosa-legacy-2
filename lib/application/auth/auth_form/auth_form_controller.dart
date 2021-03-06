import 'package:dartz/dartz.dart';
import 'package:hermosa/application/auth/auth_event.dart';
import 'package:hermosa/application/auth/auth_form/auth_form_event.dart';
import 'package:hermosa/application/auth/auth_form/auth_form_state.dart';
import 'package:hermosa/application/auth/auth_controller.dart';
import 'package:hermosa/domain/auth/i_auth_facade.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AuthFormController extends StateNotifier<AuthFormState> {
  AuthFormController(this._authFacade, this._authStateController)
      : super(AuthFormState.initial());
  final IAuthFacade _authFacade;
  final AuthController _authStateController;
  void checkAuthState() {
    _authStateController.mapEventToState(const AuthEvent.authCheckRequested());
  }

  Future mapEventToState(AuthFormEvent event) {
    return event.map(
      signInWithGooglePresseed: (_) async {
        state = state.copyWith(
          isSubmitting: true,
        );
        final authFailureOrSuccess = await _authFacade.signInWithGoogle();
        state = state.copyWith(
          authFailureOrSuccessOption: optionOf(authFailureOrSuccess),
          isSubmitting: false,
        );
        checkAuthState();
      },
      signInWithFacebookPressed: (_) async {
        checkAuthState();
        throw UnimplementedError();
      },
      signOutPressed: (_) async {
        await _authFacade.signOut();
        checkAuthState();
      },
    );
  }
}
