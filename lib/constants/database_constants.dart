// Changes in database has to be registered here.
// Changes in this file reflects the whole app.

class UsersCollection {
  static const String name = 'users';
  static const String fNameKey = 'first_name';
  static const String lNameKey = 'last_name';
  static const String pPicUriKey = 'profile_pic_uri';
  static const String uidKey = 'uid';
}

class PostsCollection {
  static const String name = 'posts';

  static const String titleKey = 'title';
  static const String messageKey = 'message';
  static const String timestampKey = 'timestamp';
  static const String ownerIdKey = 'owner_id';
  static const String visibilityKey = 'visibility';
  static const String upVotesKey = 'upvotes';
  static const String downVotesKey = 'downvotes';

  // Preset or expected possible values
  static const String visibilityPublic = 'public';
  static const String visibilityPrivate = 'private';
}

class ConnectionsCollection {
  static const String name = 'connections';
  static const String member1Key = 'member1';
  static const String member2Key = 'member2';
}

/// This sub-collection belongs to documents in posts collection
class PostVotersSubCollection {
  static const String name = 'voters';
  static const String voteTypeKey = 'vote_type';

  // Preset or expected possible values
  static const String voteTypeEmpty = 'empty';
  static const String voteTypeUpVote = 'upvote';
  static const String voteTypeDownVote = 'downvote';
}

class ChatsRTDBObject {
  static const String name = 'chats';

  static const String lastMessageKey = 'last_message';
  static const String sender = 'sender';
  static const String timestamp = 'timestamp';
}

class MembersRTDBObject {
  static const String name = 'members';

  static const String member1Key = 'member1';
  static const String member2Key = 'member2';
}

class MessagesRTDBObject {
  static const String name = 'messages';

  static const String senderKey = 'sender';
  static const String receiverKey = 'receiver';
  static const String contentKey = 'content';
  static const String lastMessageKey = 'last_message';
  static const String timestampKey = 'timestamp';
}