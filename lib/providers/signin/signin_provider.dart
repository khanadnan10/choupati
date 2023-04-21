import 'package:flutter/foundation.dart';
import 'package:kaza_app/providers/signin/signin_state.dart';

import '../../models/custom_error.dart';
import '../../repository/auth_repository.dart';

class SigninProvider with ChangeNotifier {
  SigninState state = SigninState.initial();

  SigninState get _state => state;

  final AuthRepository authRepository;
  SigninProvider({
    required this.authRepository,
  });

  Future<void> signin({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(signinStatus: SigninStatus.submitting);

    notifyListeners();

    try {
      await authRepository.signin(email: email, password: password);
      state = state.copyWith(signinStatus: SigninStatus.success);
      notifyListeners();
    } on CustomError catch (e) {
      state = state.copyWith(signinStatus: SigninStatus.error, error: e);
      notifyListeners();
      rethrow;
    }
  }
}
