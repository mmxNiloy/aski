import 'package:cloud_firestore/cloud_firestore.dart';

class AIReplyModel {
  final List<Choice> choices;
  final String id;
  final Timestamp created;
  final String model;

  static const _choicesKey = 'choices';
  static const _idKey = 'id';
  static const _createdKey = 'created';
  static const _modelKey = 'model';

  AIReplyModel({required this.choices, required this.id, required this.created, required this.model});

  factory AIReplyModel.fromJSON(Map<String, dynamic> json) {
    final mChoices = json[_choicesKey];
    final List<Choice> pChoices = [];

    for(Map<String, dynamic> choice in mChoices) {
      pChoices.add(Choice.fromJson(choice));
    }

    return AIReplyModel(
        choices: pChoices,
        id: json[_idKey],
        created: Timestamp.fromMillisecondsSinceEpoch(json[_createdKey]),
        model: json[_modelKey]
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

  static const _finishReasonKey = 'finish_reason';
  static const _indexKey = 'index';
  static const _messageKey = 'message';

  Choice({required this.finishReason, required this.index, required this.message});

  factory Choice.fromJson(Map<String, dynamic> json) {
    return Choice(
      finishReason: json[_finishReasonKey],
      index: json[_indexKey],
      message: Message.fromJson(json[_messageKey])
    );
  }
}

class Message {
  final String content;
  final String role;

  static const String _contentKey = 'content';
  static const String _roleKey = 'role';
  
  Message({required this.content, required this.role});
  
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
        content: json[_contentKey],
        role: json[_roleKey]
    );
  }
}