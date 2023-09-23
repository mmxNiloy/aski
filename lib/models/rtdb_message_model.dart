class RTDBMessageModel {
  final String sender;
  final String receiver;
  final String content;
  final int timestamp;

  static const String _senderKey = 'sender';
  static const String _receiverKey = 'receiver';
  static const String _contentKey = 'content';
  static const String _lastMessageKey = 'last_message';
  static const String _timestampKey = 'timestamp';

  RTDBMessageModel({
    required this.sender, required this.receiver,
    required this.content, required this.timestamp
  });

  factory RTDBMessageModel.fromJson(Map<String, dynamic> json) {
    return RTDBMessageModel(
        sender: json[_senderKey], receiver: json[_receiverKey],
        content: json[_contentKey], timestamp: json[_timestampKey]
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json[_senderKey] = sender;
    json[_receiverKey] = receiver;
    json[_contentKey] = content;
    json[_timestampKey] = timestamp;

    return json;
  }

  Map<String, dynamic> toMetadata() {
    Map<String, dynamic> json = {};
    json[_senderKey] = sender;
    json[_lastMessageKey] = content;
    json[_timestampKey] = timestamp;

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