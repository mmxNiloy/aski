import 'dart:convert';

import 'package:aski/constants/server_response_constants.dart';
import 'package:aski/models/ai_reply_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class AIMessageMediator {
  static Future<AIReplyModel> askAI(String message) async {
    // Encode message to uri
    String msg = Uri.encodeComponent(message);
    
    // request uri
    final rUri = Uri.http(
        APIInfo.host,   // Host
        APIInfo.messageAIRoute,                                          // Route
        {APIInfo.messageParamKey: msg}                              // Query params, Map<String, dynamic>
    );

    final response = await http.get(rUri);

    // Successful fetch
    if (response.statusCode == 200) {
      final hash = json.decode(response.body) as Map<String, dynamic>;
      return AIReplyModel.fromJSON(hash);
    }
    
    // On failure, send a placeholder error reply to avoid exceptions
    return AIReplyModel(
        choices: [Choice(message: Message(content: 'An error occurred.', role: 'assistant', ), finishReason: 'error', index: 0)],
        id: 'error',
        created: Timestamp.now(),
        model: 'error'
    );
  }
}