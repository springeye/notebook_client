import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:notebook/network/restclient.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

final logger = Logger();
void main() {
  setUp(() async {});

  tearDown(() async {});
  group("Network Tests", () {
    test("Test Login", () async {
      final dio = Dio(); // Provide a dio instance
      dio.interceptors.add(PrettyDioLogger());
      final client = RestClient(dio, baseUrl: "http://192.168.50.50:5000/");
      //https://httpbin.org/status/201
      var res = await client.testGet();
      expect(res.response.statusCode, 201);
    });
  });
}
