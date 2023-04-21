import '../../models/custom_error.dart';

enum SigninStatus {
  initial,
  submitting,
  success,
  error,
}

class SigninState {
  final SigninStatus signinStatus;
  final CustomError error;
  SigninState({
    required this.signinStatus,
    required this.error,
  });

  factory SigninState.initial() {
    return SigninState(
        signinStatus: SigninStatus.initial, error: CustomError());
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SigninState &&
        other.signinStatus == signinStatus &&
        other.error == error;
  }

  @override
  int get hashCode => signinStatus.hashCode ^ error.hashCode;

  @override
  String toString() =>
      'SigninState(signinStatus: $signinStatus, error: $error)';

  SigninState copyWith({
    SigninStatus? signinStatus,
    CustomError? error,
  }) {
    return SigninState(
      signinStatus: signinStatus ?? this.signinStatus,
      error: error ?? this.error,
    );
  }
}
