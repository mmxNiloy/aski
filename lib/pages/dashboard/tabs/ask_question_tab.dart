import 'package:aski/components/rich_text_editor.dart';
import 'package:aski/models/posts_model.dart';
import 'package:aski/pages/dashboard/tabs/ask_ai_assistant_tab.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AskQuestionTab extends StatefulWidget {
  const AskQuestionTab({super.key});

  @override
  State<AskQuestionTab> createState() => _AskQuestionTabState();
}

class _AskQuestionTabState extends State<AskQuestionTab> {
  final TextEditingController titleController = TextEditingController();
  String title = '';
  bool isAIQuestion = false;
  bool isPublic = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Title text field
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                    hintText: 'Enter the title here.',
                    labelText: 'Title',
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.black,
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16)),
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Colors.red,
                      ),
                      onPressed: titleController.clear,
                    )),
                minLines: 1,
                maxLines: 3,
                validator: validateTitle,
              ),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
              ),

              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
                child: RichTextEditor(
                  height: MediaQuery.of(context).size.height * 2.0 / 3.0,
                  isFullscreen: true,
                ),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
              ),

              CheckboxListTile(
                  title: const Text('Ask AI Assistant?'),
                  value: isAIQuestion,
                  onChanged: onIsAIQuestionSelectionChange),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
              ),

              CheckboxListTile(
                  title: const Text('Make public?'),
                  value: isPublic,
                  onChanged: onIsPublicSelectionChange),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
              ),

              OutlinedButton(
                  onPressed: submitQuestion, child: const Text('Ask Away!'))
            ],
          ),
        ),
      ),
    ));
  }

  void onIsAIQuestionSelectionChange(bool? value) {
    setState(() {
      isAIQuestion = value!;
    });
    if (value != null) {
      Navigator.pushReplacement(context, MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return const AIAssistantTab();
        },
      ));
    }
  }

  void submitQuestion() async {
    // TODO: Validate the form and post the post(question) to firestore
    if (_formKey.currentState!.validate()) {
      PostsModel mPost = PostsModel(
          title: titleController.value.text,
          message: await RichTextEditorSharedStates.getText(),
          timestamp: Timestamp.now(),
          ownerId: FirebaseAuth.instance.currentUser!.uid,
          visibility: isPublic
              ? PostVisibility.POST_PUBLIC
              : PostVisibility.POST_PRIVATE,
          upvotes: 0,
          downvotes: 0
      );

      debugPrint('Data found, ${mPost.toString()}');

      final db = FirebaseFirestore.instance;

      // Prep for upload
      final docRef = db.collection('posts').withConverter(
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
      return 'Title cannot be empty.';
    }

    return null;
  }

  void onIsPublicSelectionChange(bool? value) {
    setState(() {
      isPublic = value!;
    });
  }
}
