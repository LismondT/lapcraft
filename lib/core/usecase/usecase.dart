
import 'package:dartz/dartz.dart';
import 'package:lapcraft/core/core.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams {}