import 'package:aski/constants/server_response_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AIReplyModel {
  final List<Choice> choices;
  final String id;
  final Timestamp created;
  final String model;

  AIReplyModel({required this.choices, required this.id, required this.created, required this.model});

  factory AIReplyModel.fromJSON(Map<String, dynamic> json) {
    final mChoices = json[AIReplyObjectKeys.choicesKey];
    final List<Choice> pChoices = [];

    for(Map<String, dynamic> choice in mChoices) {
      pChoices.add(Choice.fromJson(choice));
    }

    return AIReplyModel(
        choices: pChoices,
        id: json[AIReplyObjectKeys.idKey],
        created: Timestamp.fromMillisecondsSinceEpoch(json[AIReplyObjectKeys.createdKey]),
        model: json[AIReplyObjectKeys.modelKey]
    );
  }

  String getFirstReply() {
    assert(choices.isNotEmpty);
    return choices.first.message.content;
  }
}

class Choice {
  final String finishReason;
  final int index;
  final Message message;

  Choice({required this.finishReason, required this.index, required this.message});

  factory Choice.fromJson(Map<String, dynamic> json) {
    return Choice(
      finishReason: json[AIReplyChoiceObjectKeys.finishReasonKey],
      index: json[AIReplyChoiceObjectKeys.indexKey],
      message: Message.fromJson(json[AIReplyChoiceObjectKeys.messageKey])
    );
  }
}

class Message {
  final String content;
  final String role;
  
  Message({required this.content, required this.role});
  
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
        content: json[AIReplyMessageObjectKeys.contentKey],
        role: json[AIReplyMessageObjectKeys.roleKey]
    );
  }
}