import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'restclient.g.dart';

@RestApi()
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET("https://httpbin.org/status/201")
  Future<HttpResponse<String>> testGet();
}
