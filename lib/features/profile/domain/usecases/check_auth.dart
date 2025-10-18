import 'package:lapcraft/features/profile/domain/repositories/auth_repository.dart';

class CheckAuth {
  final AuthRepository repository;

  CheckAuth(this.repository);

  Future<bool> call() {
    return repository.isLoggedIn();
  }
}
