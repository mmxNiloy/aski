class AIReplyModel {
  final List<String> choices;
  final String id;
  final int created;
  final String model;

  AIReplyModel({required this.choices, required this.id, required this.created, required this.model});

  factory AIReplyModel.fromJSON(Map<String, dynamic> json) {
    final mChoices = json['choices'];
    final List<String> pChoices = [];

    for(Map<String, dynamic> choice in mChoices) {
      final msg = choice['message'];
      pChoices.add(msg['content'] as String);
    }

    return AIReplyModel(
        choices: pChoices,
        id: json['id'],
        created: json['created'],
        model: json['model']
    );
  }
}