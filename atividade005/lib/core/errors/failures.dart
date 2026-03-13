sealed class Failure {
  const Failure(this.message);
  final String message;

  @override
  String toString() => '$runtimeType(message: $message)';
}

final class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

final class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

final class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}
