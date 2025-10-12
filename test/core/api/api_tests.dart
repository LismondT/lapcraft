
import 'package:flutter_test/flutter_test.dart';
import 'package:lapcraft/core/api/api.dart';

void main() async {

  final DioClient client = DioClient();

  group('Api', () {
    test('BaseUrl is not null or empty', () {
      expect(DioClient.baseUrl, 'https://localhost:5000/');
    });

    test('GET/Products return ProductsResponse', () {

    });
  });
}