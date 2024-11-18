import 'dart:convert';

import 'package:hotshi/config.dart';
import 'package:hotshi/repositories/api-request.dart';
import 'package:hotshi/models/message_response.dart';
import 'package:hotshi/models/message_liste_response.dart';
import '../shared_value_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessageRepository {
  // Create message repository
  Future createMessaeResponse(String? msg) async {
    var postBody = jsonEncode({
      "content": "$msg",
    });

    String url = ("${AppConfig.BASE_URL}/message");
    final response = await ApiRequest.post(
      url: url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer ${access_token.$}",
      },
      body: postBody,
    );

    return (response.statusCode == 200)
        ? MessageResponse.fromJson(jsonDecode(response.body))
        : jsonDecode(response.body);
  }

  // Get message list
  Future getMessageResponse() async {
    String url = ("${AppConfig.BASE_URL}/message");
    final response = await ApiRequest.get(url: url, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer ${access_token.$}",
    });

    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('messages_liste', response.body);
      return MessageListeResponse.fromJson(jsonDecode(response.body));
    } else {
      jsonDecode(response.body);
    }
  }
}
