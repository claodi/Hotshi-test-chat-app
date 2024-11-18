import 'dart:convert';

import 'package:hotshi/config.dart';
import 'package:hotshi/repositories/api-request.dart';
import 'package:hotshi/models/login_response.dart';

class AuthRepository {
  /// Login repository
  Future getLoginResponse(String? name) async {
    var postBody = jsonEncode({
      "name": "$name",
    });

    String url = ("${AppConfig.BASE_URL}/login");
    final response = await ApiRequest.post(
      url: url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: postBody,
    );

    return (response.statusCode == 200)
        ? LoginResponse.fromJson(jsonDecode(response.body))
        : jsonDecode(response.body);
  }

  // Sign up repository
  Future getSignupResponse(String? name) async {
    var postBody = jsonEncode({
      "name": "$name",
    });

    String url = ("${AppConfig.BASE_URL}/signup");
    final response = await ApiRequest.post(
      url: url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: postBody,
    );

    return (response.statusCode == 200)
        ? LoginResponse.fromJson(jsonDecode(response.body))
        : jsonDecode(response.body);
  }
}
