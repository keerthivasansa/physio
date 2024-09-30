import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:physio/api/client.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

enum AuthResult { doc, patient, fail }

class AuthState extends ChangeNotifier {
  String token = "";
  final storage = FlutterSecureStorage();

  AuthState() {
    init();
  }

  void init() async {
    final _token = await storage.read(key: "accessToken");
    if (_token != null) {
      token = _token;
      notifyListeners();
    }
  }

  Future<AuthResult> login(String id, String password) async {
    final body = {"id": id, "password": password};
    final client = locator.get<ApiClient>();
    final res = await client.post("/auth/login", body);
    if (res.isError) return AuthResult.fail;
    token = res.data['token'];
    handleToken(token);
    print("token received");
    final isDoc = res.data['isDoctor'] == true ? "OK" : "NO";

    // cache auth state
    await storage.write(key: "accessToken", value: token);
    await storage.write(key: "isDoctor", value: isDoc);

    return res.data['isDoctor'] ? AuthResult.doc : AuthResult.patient;
  }

  Future<void> logout() async {
    token = "";
    await storage.delete(key: "accessToken");
    await storage.delete(key: "isDoctor");
    notifyListeners();
  }

  void handleToken(String token) {
    // storage.write(key: "accessToken", value: token);
    notifyListeners();
  }
}
