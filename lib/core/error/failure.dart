abstract class Failure {
  const Failure([List properties = const <dynamic>[]]);
}

class ServerFailure extends Failure {
  final String? message;

  const ServerFailure(this.message);

  @override
  bool operator ==(Object other) =>
      other is ServerFailure && other.message == message;

  @override
  int get hashCode => message.hashCode;
}

class NoDataFailure extends Failure {
  @override
  bool operator ==(Object other) => other is NoDataFailure;

  @override
  int get hashCode => 0;
}

class CacheFailure extends Failure {
  @override
  bool operator ==(Object other) => other is CacheFailure;

  @override
  int get hashCode => 0;
}

class ParsingFailure extends Failure {
  final String message;

  ParsingFailure(this.message);

  @override
  String toString() => 'ParsingFailure: $message';
}

class NetworkFailure extends Failure {
  @override
  String toString() => 'NetworkFailure: No internet connection';
}

class NotFoundFailure extends Failure {
  final String message;

  NotFoundFailure(this.message);

  @override
  String toString() => 'ParsingFailure: $message';
}
