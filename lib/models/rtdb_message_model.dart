import 'package:aski/constants/database_constants.dart';

class RTDBMessageModel {
  final String sender;
  final String receiver;
  final String content;
  final int timestamp;

  RTDBMessageModel({
    required this.sender, required this.receiver,
    required this.content, required this.timestamp
  });

  factory RTDBMessageModel.fromJson(Map<String, dynamic> json) {
    return RTDBMessageModel(
        sender: json[MessagesRTDBObject.senderKey], receiver: json[MessagesRTDBObject.receiverKey],
        content: json[MessagesRTDBObject.contentKey], timestamp: json[MessagesRTDBObject.timestampKey]
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json[MessagesRTDBObject.senderKey] = sender;
    json[MessagesRTDBObject.receiverKey] = receiver;
    json[MessagesRTDBObject.contentKey] = content;
    json[MessagesRTDBObject.timestampKey] = timestamp;

    return json;
  }

  Map<String, dynamic> toMetadata() {
    Map<String, dynamic> json = {};
    json[MessagesRTDBObject.senderKey] = sender;
    json[MessagesRTDBObject.lastMessageKey] = content;
    json[MessagesRTDBObject.timestampKey] = timestamp;

    return json;
  }

  bool notEquals(RTDBMessageModel newMessage) {
    return sender != newMessage.sender || receiver != newMessage.receiver
        || content != newMessage.content || timestamp != newMessage.timestamp;
  }

  bool equals(RTDBMessageModel newMessage) {
    return !notEquals(newMessage);
  }

  @override
  String toString() {
    return 'RTDBMessageModel{\nSender: $sender\nReceiver: $receiver\nContent: $content\nTimestamp: $timestamp\n}\n';
  }
}