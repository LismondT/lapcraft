// import 'dart:async';
//
// import 'package:dartz/dartz.dart';
// import 'package:lapcraft/features/profile/data/datasource/remote/auth_remote_datasource.dart';
//
// import '../../../../../core/error/failure.dart';
// import '../../models/login_request.dart';
// import '../../models/login_response.dart';
// import '../../models/user_model.dart';
//
// class AuthMockDatasource implements AuthRemoteDatasource {
//   final List<UserModel> _users = [
//     UserModel(
//       id: '1',
//       name: 'Иван Петров',
//       email: 'ivan@example.com',
//       addresses: [
//         'ул. Ленина, д. 10, кв. 25',
//         'пр. Мира, д. 45, кв. 12'
//       ],
//       phone: '+7 (912) 345-67-89',
//     ),
//     UserModel(
//       id: '2',
//       name: 'Мария Сидорова',
//       email: 'maria@example.com',
//       addresses: [
//         'ул. Центральная, д. 5, кв. 8'
//       ],
//       phone: '+7 (923) 456-78-90',
//     ),
//   ];
//
//   final Map<String, String> _userCredentials = {
//     'ivan@example.com': 'password123',
//     'maria@example.com': 'password456',
//   };
//
//   final Map<String, String> _tokens = {};
//
//   // Имитация задержки сети
//   Future<void> _simulateNetworkDelay() async {
//     await Future.delayed(const Duration(milliseconds: 500));
//   }
//
//   @override
//   Future<Either<Failure, LoginResponse>> login(LoginRequest request) async {
//     await _simulateNetworkDelay();
//
//     try {
//       final user = _users.firstWhere(
//             (user) => user.email == request.email,
//       );
//
//       final storedPassword = _userCredentials[request.email];
//       if (storedPassword != request.password) {
//         return Left(InvalidCredentialsFailure());
//       }
//
//       final accessToken = 'mock_access_token_${user.id}_${DateTime.now().millisecondsSinceEpoch}';
//       final refreshToken = 'mock_refresh_token_${user.id}_${DateTime.now().millisecondsSinceEpoch}';
//
//       _tokens[user.id] = accessToken;
//
//       final response = LoginResponse(
//         user: user.copyWith(accessToken: accessToken, refreshToken: refreshToken),
//         accessToken: accessToken,
//         refreshToken: refreshToken,
//       );
//
//       return Right(response);
//     } catch (e) {
//       return Left(InvalidCredentialsFailure());
//     }
//   }
//
//   @override
//   Future<Either<Failure, UserModel>> getCurrentUser({String? token}) async {
//     await _simulateNetworkDelay();
//
//     if (token == null) {
//       return Left(UnauthorizedFailure());
//     }
//
//     try {
//       // Ищем пользователя по токену
//       final userId = _tokens.entries
//           .firstWhere((entry) => entry.value == token)
//           .key;
//
//       final user = _users.firstWhere((user) => user.id == userId);
//
//       return Right(user);
//     } catch (e) {
//       return Left(UnauthorizedFailure());
//     }
//   }
//
//   @override
//   Future<Either<Failure, LoginResponse>> refreshToken(String refreshToken) async {
//     await _simulateNetworkDelay();
//
//     try {
//       // В моковой реализации просто генерируем новые токены
//       final userId = '1'; // Упрощенная логика для мока
//       final user = _users.firstWhere((user) => user.id == userId);
//
//       final newAccessToken = 'mock_access_token_${user.id}_${DateTime.now().millisecondsSinceEpoch}';
//       final newRefreshToken = 'mock_refresh_token_${user.id}_${DateTime.now().millisecondsSinceEpoch}';
//
//       _tokens[user.id] = newAccessToken;
//
//       final response = LoginResponse(
//         user: user.copyWith(accessToken: newAccessToken, refreshToken: newRefreshToken),
//         accessToken: newAccessToken,
//         refreshToken: newRefreshToken,
//       );
//
//       return Right(response);
//     } catch (e) {
//       return Left(UnauthorizedFailure());
//     }
//   }
//
//   @override
//   Future<Either<Failure, void>> logout({String? token}) async {
//     await _simulateNetworkDelay();
//
//     if (token != null) {
//       _tokens.removeWhere((key, value) => value == token);
//     }
//
//     return const Right(null);
//   }
//
//   @override
//   Future<bool> isLoggedIn({String? token}) async {
//     await _simulateNetworkDelay();
//
//     if (token == null) return false;
//     return _tokens.containsValue(token);
//   }
//
//   @override
//   Future<Either<Failure, LoginResponse>> register({
//     required String name,
//     required String email,
//     required String password,
//     String? phone,
//   }) async {
//     await _simulateNetworkDelay();
//
//     try {
//       // Проверяем, не занят ли email
//       if (_users.any((user) => user.email == email)) {
//         return Left(EmailAlreadyExistsFailure());
//       }
//
//       // Создаем нового пользователя
//       final newUser = UserModel(
//         id: (_users.length + 1).toString(),
//         name: name,
//         email: email,
//         addresses: [],
//         phone: phone,
//       );
//
//       _users.add(newUser);
//       _userCredentials[email] = password;
//
//       // Генерируем токены
//       final accessToken = 'mock_access_token_${newUser.id}_${DateTime.now().millisecondsSinceEpoch}';
//       final refreshToken = 'mock_refresh_token_${newUser.id}_${DateTime.now().millisecondsSinceEpoch}';
//
//       _tokens[newUser.id] = accessToken;
//
//       final response = LoginResponse(
//         user: newUser.copyWith(accessToken: accessToken, refreshToken: refreshToken),
//         accessToken: accessToken,
//         refreshToken: refreshToken,
//       );
//
//       return Right(response);
//     } catch (e) {
//       return Left(ServerFailure());
//     }
//   }
//
//   void clearData() {
//     _tokens.clear();
//   }
//
//   List<UserModel> get testUsers => List.unmodifiable(_users);
// }