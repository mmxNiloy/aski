class APIInfo{
  static String host = 'blacklabelengineering.pythonanywhere.com';

  // TODO: Define routes here
  /// Params: message -> URI encoded text,
  static String messageAIRoute = '/';
  static String messageParamKey = 'message';
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