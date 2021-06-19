import 'dart:convert';
//import 'dart:io';
import 'dart:async';
import 'package:http/http.dart';

class BarqatTA {
  static const String URL =
      'https://centralindia.api.cognitive.microsoft.com/text/analytics/v2.1/entities';
  static const String CONTENT_TYPE = 'application/json';
  static const String ACCEPT = 'application/json';
  static const String SUBSCRIPTION_KEY = '';//add key here
  BarqatTA._();
  static final BarqatTA ta = BarqatTA._();
  Future<void> postResponse(String id, String language, String text) async {
    String url = URL;
    Map<String, dynamic> map = {
      "documents": [
        {
          "id": "$id",
          "language": "$language",
          "text": "$text",
        }
      ]
    };

    print(await apiRequest(url, map));
  }

/*Future<String> apiRequest(String url, Map jsonMap) async {
  HttpClient httpClient = new HttpClient();
  HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
  request.headers.set('Content-Type', 'application/json');
  request.headers.set('Accept', 'application/json');
  request.headers
      .set('Ocp-Apim-Subscription-Key', '9b5da21f9a0d45419f54b687f6513df4');
  //request.add(utf8.encode(json.encode(jsonMap)));
  //request.add(jsonEncode(jsonMap));

  HttpClientResponse response = await request.close();
  // todo - you should check the response.statusCode
  String reply = await response.transform(utf8.decoder).join();
  httpClient.close();
  return reply;
}*/
  Future<Map<String, dynamic>> apiRequest(
      String url, Map<String, dynamic> map) async {
    Map<String, String> headers = {
      'Content-Type': CONTENT_TYPE,
      'Accept': ACCEPT,
      'Ocp-Apim-Subscription-Key': SUBSCRIPTION_KEY,
    };
    String jsonMap = jsonEncode(map);
    Response response = await post(url, body: jsonMap, headers: headers);
    Map<String, dynamic> tokenJson = json.decode(response.body);
    return tokenJson;
  }

  /* Map<String, dynamic> parseJwtPayLoad(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('invalid token');
    }

    final payload = _decodeBase64(parts[1]);
    final payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('invalid payload');
    }
    return payloadMap;
  }

  String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');

    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string!"');
    }

    return utf8.decode(base64Url.decode(output));
  }*/ //S
}
