import 'dart:io';
import 'dart:math';

import 'package:aski/components/rich_text_editor.dart';
import 'package:aski/constants/database_constants.dart';
import 'package:aski/models/posts_model.dart';
import 'package:aski/pages/dashboard/tabs/ask_ai_assistant_tab.dart';
import 'package:aski/pages/dashboard/tabs/pdf_ai_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class AskQuestionTab extends StatefulWidget {
  const AskQuestionTab({super.key});

  @override
  State<AskQuestionTab> createState() => _AskQuestionTabState();
}

class _AskQuestionTabState extends State<AskQuestionTab>
    with SingleTickerProviderStateMixin {
  final TextEditingController titleController = TextEditingController();
  List<File> _images = [];
  List<String> _imgRefs = [];
  String _title = '';
  String _content = "";
  bool isAIQuestion = false;
  bool isPublic = false;
  final GlobalKey<FormState> _fkPost = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
        actions: [
          TextButton(
            onPressed: _handlePost,
            child: const Row(
              children: [
                Text('Post'),
                Icon(Icons.post_add_rounded),
              ],
            ),
          )
        ],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.chevron_left),
        ),
      ),
      body: Form(
        key: _fkPost,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
          child: Column(
            children: [
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Title cannot be empty.";
                  }

                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _title = value;
                  });
                },
                style: Theme.of(context).textTheme.headlineMedium,
                decoration: const InputDecoration(
                  hintText: 'Title',
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        _content = value;
                      });
                    },
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: const InputDecoration.collapsed(
                      hintText: "What's on your mind?",
                    ),
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: _images.map((imgFile) {
                      return SizedBox(
                          height: 128, width: 128, child: Image.file(imgFile));
                    }).toList(),
                  ),
                ),
              ),
              Row(
                children: [
                  IconButton(onPressed: () {}, icon: const Icon(Icons.link)),
                  IconButton(
                      onPressed: () {
                        handleImagePicker();
                      },
                      icon: const Icon(Icons.image)),
                  IconButton(
                      onPressed: () {}, icon: const Icon(Icons.ondemand_video)),
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PDFAIPage()));
                      },
                      icon: const Icon(Icons.picture_as_pdf)),
                  const Expanded(
                    child: SizedBox(),
                  ),
                  OutlinedButton(
                      onPressed: _handleAskAI,
                      child: const Row(
                        children: [Icon(Icons.rocket_launch), Text('Ask AI')],
                      ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void submitQuestion() async {
    // TODO: Validate the form and post the post(question) to firestore
    if (_fkPost.currentState!.validate()) {
      PostsModel mPost = PostsModel(
        title: titleController.value.text,
        content: await RichTextEditorSharedStates.getText(),
        timestamp: Timestamp.now(),
        ownerId: FirebaseAuth.instance.currentUser!.uid,
        upvotes: 0,
        downvotes: 0,
        imgRefs: [], //TODO: refer to an array of image references
      );

      debugPrint('Data found, ${mPost.toString()}');

      final db = FirebaseFirestore.instance;

      // Prep for upload
      final docRef = db.collection(PostsCollection.name).withConverter(
          fromFirestore: PostsModel.fromFirestore,
          toFirestore: (PostsModel post, options) => post.toFirestore());

      // Wait for upload to finish
      final res = await docRef.add(mPost);
      debugPrint('Added data, docID: ${res.id}');
      // TODO: Redirect to home tab.
    }
  }

  String? validateTitle(String? value) {
    if (value == null || value.isEmpty) {
      return "Title cannot be empty.";
    }

    return null;
  }

  void onIsPublicSelectionChange(bool? value) {
    setState(() {
      isPublic = value!;
    });
  }

  Future<String> uploadImage(File img) async {
    final storageRef = FirebaseStorage.instance.ref();
    final fileRef =
        storageRef.child("images/${DateTime.now().millisecondsSinceEpoch}");
    await fileRef.putFile(img);
    String link = await fileRef.getDownloadURL();
    return link;
  }

  Future<void> _handlePost() async {
    if (!_fkPost.currentState!.validate()) {
      return;
    }
    User user = FirebaseAuth.instance.currentUser!;
    List<String> links = [];
    if (_images.isNotEmpty) {
      for (File img in _images) {
        links.add(await uploadImage(img));
      }
    }
    PostsModel model = PostsModel(
        title: _title,
        content: _content,
        ownerId: user.uid,
        timestamp: Timestamp.now(),
        upvotes: 0,
        downvotes: 0,
        imgRefs: links);
    final dbRef = FirebaseFirestore.instance;
    final collRef = dbRef.collection(PostsCollection.name);
    await collRef.add(model.toFirestore());
  }

  Future<void> handleImagePicker() async {
    try {
      XFile? img = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (img == null) return;

      File? imgFile = File(img.path);
      List<File> temp = _images;
      temp.add(imgFile);
      setState(() {
        _images = temp;
      });
    } on PlatformException catch (e) {
      debugPrint('Signup page > Image picker > ${e.message}');
      return;
    }
  }

  void _handleAskAI() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const AskAIAssistantTab()));
  }
}
