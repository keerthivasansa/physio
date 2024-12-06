import 'package:physio/api/auth.dart';
import 'package:rest_api_client/rest_api_client.dart';

class ApiClient {
  late RestApiClient restApiClient;
  late AuthState auth;
  var token = "";

  ApiClient() {
    restApiClient = RestApiClientImpl(
      options: RestApiClientOptions(
          baseUrl: "https://mrmbkxhl-5000.inc1.devtunnels.ms",
          // baseUrl: "https://g8840ckso0gcg8scc4ksk80o.keerthivasan.in",
          cacheEnabled: true,
          overrideBadCertificate: false),
    );

    auth = locator.get<AuthState>();
    auth.addListener(() {
      token = auth.token;
    });
  }

  Future<Result> get(String path, Map<String, dynamic> query) {
    final res = restApiClient.get(path,
        queryParameters: query,
        options: RestApiClientRequestOptions(headers: getHeaders()));
    return res;
  }

  Future<Result> post(String path, dynamic payload) {
    final res = restApiClient.post(path,
        data: payload,
        options: RestApiClientRequestOptions(headers: getHeaders()));
    return res;
  }

  Map<String, String> getHeaders() {
    Map<String, String> headers = {};
    if (token != "") headers["Authorization"] = "Bearer $token";

    return headers;
  }
}
