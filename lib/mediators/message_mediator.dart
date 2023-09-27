import 'dart:convert';

import 'package:aski/models/rtdb_message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class MessageMediator {
  static Future<String> findOrGenerateChatID(String member1, String member2) async {
    String chatID = '';

    final db = FirebaseFirestore.instance;
    final collRef = db.collection('connections');
    final query = collRef
        .where('member1', isEqualTo: member1)
        .where('member2', isEqualTo: member2);

    final response = await query.get();
    if(response.docs.isNotEmpty && response.docs.first.exists) {
      chatID = response.docs.first.id;
    } else {
      // Member connection data
      Map<String, String> members = {
        'member1': member1,
        'member2': member2,
      };

      // Create a new chat id in firebase rtdb
      final rtdb = FirebaseDatabase.instance;
      final membersRef = rtdb.ref('/members');
      final itemRef = membersRef.push();

      chatID = itemRef.key!;

      // Update the RTDB
      // TODO: Handle errors
      await itemRef.set(members);

      // Update Firestore
      final docRef = collRef.doc(chatID);

      // TODO: Handle errors
      await docRef.set(members);
    }

    return chatID;
  }

  // TODO: Handle message send failure
  static Future<void> storeMessageToRTDB(String chatID, RTDBMessageModel messageModel) async {

    // Notify the RTDB
    FirebaseDatabase database = FirebaseDatabase.instance;
    final mChatRef = database.ref('messages/$chatID');

    int ts = Timestamp.now().millisecondsSinceEpoch;
    final msgRef = mChatRef.push();
    await msgRef.set(messageModel.toJson());

    // Update the metadata in the database
    final chatRef = database.ref('/chats/$chatID');
    await chatRef.set(messageModel.toMetadata());

    return;
  }

  static Future<List<RTDBMessageModel>> getLatestMessages(String chatID, int limit) async {
    List<RTDBMessageModel> messages = [];

    FirebaseDatabase database = FirebaseDatabase.instance;
    final msgRef = database.ref('messages/');
    final chat = msgRef.child(chatID);
    final query = chat
        .orderByChild('timestamp')
        .limitToLast(limit);

    final snapshot = await query.get();
    if(snapshot.exists) {
      Map<String, dynamic> m = json.decode(json.encode(snapshot.value));
      m.forEach((key, value) {
        messages.insert(0, RTDBMessageModel.fromJson(value));
      });
    }

    return messages;
  }

  static Future<void> listenToChatChanges(
    String chatID,
    void Function(RTDBMessageModel) handleDataChange) async {
    DatabaseReference chatRef = FirebaseDatabase.instance.ref('messages/$chatID');
    // get the latest message ref
    final query = chatRef
      .orderByChild('timestamp')
      .limitToLast(1);
    query.onValue.listen((event) {
      final data = event.snapshot.value;

      final m = json.decode(json.encode(data));
      late RTDBMessageModel newMessage;
      m.forEach((key, value) {
        newMessage = RTDBMessageModel.fromJson(value);
      });

      handleDataChange(newMessage);
    });
  }
}