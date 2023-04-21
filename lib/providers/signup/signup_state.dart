import '../../models/custom_error.dart';

enum SignupStatus { initial, submitting, success, error }

class SignupState {
  final SignupStatus signupStatus;
  final CustomError error;
  SignupState({
    required this.signupStatus,
    required this.error,
  });

  factory SignupState.initial() {
    return SignupState(
        signupStatus: SignupStatus.initial, error: CustomError());
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SignupState &&
        other.signupStatus == SignupStatus &&
        other.error == error;
  }

  @override
  int get hashCode => signupStatus.hashCode ^ error.hashCode;

  @override
  String toString() =>
      'SignupState(SignupStatus: $SignupStatus, error: $error)';

  SignupState copyWith({
    SignupStatus? SignupStatus,
    CustomError? error,
  }) {
    return SignupState(
      signupStatus: SignupStatus ?? this.signupStatus,
      error: error ?? this.error,
    );
  }
}
