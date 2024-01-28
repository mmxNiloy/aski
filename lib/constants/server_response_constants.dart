import 'package:http/http.dart' as http;
import 'dart:convert';

class APIInfo{
  static String host = 'blacklabelengineering.pythonanywhere.com';

  // TODO: Define routes here
  /// Params: message -> URI encoded text,
  static String messageAIRoute = '/';
  static String messageParamKey = 'message';
}

class ChatPDFAPIInfo {
  static const String _addUriEndpoint = 'https://api.chatpdf.com/v1/sources/add-url';
  static const String _chatEndpoint = 'https://api.chatpdf.com/v1/chats/message';
  static const String errSource = 'Unable to fetch source id';
  static const String errContent = 'Unable to fetch content';
  static List<String> apiKeys = [
    'sec_8rk37tTcllYCNfMzDBO10mjj00ywmT0Y',
    'sec_DgeFzD7Ul61XgTGuWHwJM4HhPT6CCrxn'
  ];

  static Future<http.Response> requestSourceId(String apiKey, String pdfLink) {
    return http.post(
      Uri.parse(_addUriEndpoint),
      headers: <String, String>{
        'Content-Type': "application/json",
        'x-api-key': apiKey,
      },
      body: jsonEncode(
        <String, String>{
          'url': pdfLink,
        }
      )
    );
  }

  static Future<http.Response> requestAIResponse(String apiKey, String sourceId, String message) {
    return http.post(
        Uri.parse(_chatEndpoint),
        headers: <String, String>{
          'Content-Type': "application/json",
          'x-api-key': apiKey,
        },
        body: jsonEncode(
            <String, dynamic>{
              'sourceId': sourceId,
              'messages': [
                {
                  'role': 'user',
                  'content': message,
                }
              ]
            }
        )
    );
  }
}

class AIReplyObjectKeys {
  static const choicesKey = 'choices';
  static const idKey = 'id';
  static const createdKey = 'created';
  static const modelKey = 'model';
}

class AIReplyChoiceObjectKeys {
  static const finishReasonKey = 'finish_reason';
  static const indexKey = 'index';
  static const messageKey = 'message';
}

class AIReplyMessageObjectKeys {
  static const String contentKey = 'content';
  static const String roleKey = 'role';
}