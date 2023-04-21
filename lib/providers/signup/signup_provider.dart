import 'package:flutter/foundation.dart';

import '../../models/custom_error.dart';
import '../../repository/auth_repository.dart';
import 'Signup_state.dart';

class SignupProvider with ChangeNotifier {
  SignupState state = SignupState.initial();
  SignupState get _state => state;

  final AuthRepository authRepository;
  SignupProvider({
    required this.authRepository,
  });

  Future<void> Signup({
    required String name,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(SignupStatus: SignupStatus.submitting);

    notifyListeners();

    try {
      await authRepository.signup(name: name, email: email, password: password);
      state = state.copyWith(SignupStatus: SignupStatus.success);
      notifyListeners();
    } on CustomError catch (e) {
      state = state.copyWith(SignupStatus: SignupStatus.error, error: e);
      notifyListeners();
      rethrow;
    }
  }
}
