import 'package:hotshi/helpers.dart';
import 'package:http/http.dart' as http;

class ApiRequest {
  static Future<http.Response> get(
      {required String url, Map<String, String>? headers}) async {
    Uri uri = Uri.parse(url);
    Map<String, String>? headerMap = commonHeader;
    if (headers != null) {
      headerMap.addAll(headers);
    }
    var response = await http.get(uri, headers: headerMap);
    return response;
  }

  static Future<http.Response> post(
      {required String url,
      Map<String, String>? headers,
      required String body}) async {
    Uri uri = Uri.parse(url);
    Map<String, String>? headerMap = commonHeader;
    if (headers != null) {
      headerMap.addAll(headers);
    }
    var response = await http.post(uri, headers: headerMap, body: body);
    return response;
  }

  static Future<http.Response> delete(
      {required String url, Map<String, String>? headers}) async {
    Uri uri = Uri.parse(url);
    Map<String, String>? headerMap = commonHeader;
    if (headers != null) {
      headerMap.addAll(headers);
    }
    var response = await http.delete(uri, headers: headerMap);
    return response;
  }
}
