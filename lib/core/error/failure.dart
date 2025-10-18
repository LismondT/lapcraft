abstract class Failure {
  const Failure([List properties = const <dynamic>[]]);
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

class NotFoundFailure extends Failure {
  final String message;

  NotFoundFailure(this.message);

  @override
  String toString() => 'Not Found Failure: $message';
}

class InvalidCredentialsFailure extends Failure {
  @override
  String toString() => 'Неверный email или пароль';
}

class UnauthorizedFailure extends Failure {
  @override
  String toString() => 'Требуется авторизация';
}

class EmailAlreadyExistsFailure extends Failure {
  @override
  String toString() => 'Пользователь с таким email уже существует';
}

class NetworkFailure extends Failure {
  @override
  String toString() => 'Ошибка сети. Проверьте подключение к интернету';
}

class ServerFailure extends Failure {
  @override
  String toString() => 'Ошибка сервера. Попробуйте позже';
}
