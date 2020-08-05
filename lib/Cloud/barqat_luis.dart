import 'dart:convert';
//import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;

class BarqatLUIS {
  //static const String URL =
  //'https://centralindia.api.cognitive.microsoft.com/text/analytics/v2.1/entities';
  static const ENDPOINT =
      'https://barqatluis.cognitiveservices.azure.com'; //the slash after .com is already given in query
  static const APP_ID = 'a9996e19-047b-4241-b044-e58e22147898';
  static const String KEY = 'df26232b0e1d442fbb468af0aecbaadc';
  static const QUERY =
      '$ENDPOINT/luis/prediction/v3.0/apps/$APP_ID/slots/production/predict?subscription-key=$KEY&verbose=false&show-all-intents=false&log=true&query=';
  BarqatLUIS._();
  static final BarqatLUIS luis = BarqatLUIS._();
  Future<String> getResponse(String utterance) async {
    List utterances = utterance.split('.');
    String allEntities = '';
    for (final utterance in utterances) {
      if (utterance.toString().trim().length > 0) {
        String entities =
            await apiRequest(utterance.toString()); //entities as json string
        if (entities != '') {
          if (allEntities != '') {
            allEntities = allEntities + ',' + entities;
          } else {
            allEntities = entities;
          }
        }
      }
    }
    if (allEntities.length > 0) {
      String log = allEntities; //json strings separated by commas
      return log;
    }
    return '';
  }

  Future<String> apiRequest(String utterance) async {
    String request = '$QUERY$utterance';
    var response = await http.get(request);
    Map<String, dynamic> mapJson = json.decode(response.body);
    Map<String, dynamic> prediction = mapJson['prediction'];
    if (prediction['topIntent'] == 'Calendar.logEntry') {
      return json.encode(prediction['entities']); //entities as json string
    } else {
      return '';
    }
  }

  /*Future<String> partResponse(String utterance) async {
    String request = '$QUERY$utterance';
    return await apiRequest(request);
  }*/
}
