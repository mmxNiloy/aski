import 'dart:math';

import 'package:aski/components/rich_text_editor.dart';
import 'package:aski/constants/database_constants.dart';
import 'package:aski/models/posts_model.dart';
import 'package:aski/pages/dashboard/tabs/ask_ai_assistant_tab.dart';
import 'package:aski/pages/dashboard/tabs/pdf_ai_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AskQuestionTab extends StatefulWidget {
  const AskQuestionTab({super.key});

  @override
  State<AskQuestionTab> createState() => _AskQuestionTabState();
}

class _AskQuestionTabState extends State<AskQuestionTab> with SingleTickerProviderStateMixin {
  final TextEditingController titleController = TextEditingController();
  String _title = '';
  bool isAIQuestion = false;
  bool isPublic = false;
  final GlobalKey<FormState> _fkPost = GlobalKey<FormState>();
  
  // Radiam menu _animCtrRadialMenu and animations
  late AnimationController _animCtrRadialMenu;
  late Animation<double> scale;
  late Animation<double> translation;
  late Animation<double> rotation;

  @override
  void initState() {
    super.initState();
    _animCtrRadialMenu = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500)
    );

    rotation  = Tween<double>(
        begin: 180.0,
        end: 360.0,
    ).animate(
      CurvedAnimation(
        parent: _animCtrRadialMenu,
        curve: const Interval(
          0.3, 0.9,
          curve: Curves.decelerate,
        ),
      ),
    );

    translation = Tween<double>(
      begin: 0,
      end: 100
    ).animate(
      CurvedAnimation(
        parent: _animCtrRadialMenu,
        curve: Curves.linear
      )
    );

    scale = Tween<double>(
        begin: 1.5,
        end: 0
    ).animate(
        CurvedAnimation(
            parent: _animCtrRadialMenu,
            curve: Curves.fastOutSlowIn
        )
    );
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    _animCtrRadialMenu.dispose();
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
                Text('Next'),
                Icon(Icons.chevron_right)
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
                  if(value == null || value.isEmpty) return 'Title cannot be empty';
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
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: const InputDecoration.collapsed(
                      hintText: 'Body (optional)',
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  IconButton(
                      onPressed: (){},
                      icon: const Icon(Icons.link)
                  ),
                  IconButton(
                      onPressed: (){},
                      icon: const Icon(Icons.image)
                  ),
                  IconButton(
                      onPressed: (){},
                      icon: const Icon(Icons.ondemand_video)
                  ),
                  IconButton(
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PDFAIPage()
                          )
                        );
                      },
                      icon: const Icon(Icons.picture_as_pdf)
                  ),
                  const Expanded(
                    child: SizedBox(),
                  ),
                  OutlinedButton(
                      onPressed: _handleAskAI,
                      child: const Row(
                        children: [
                          Icon(Icons.rocket_launch),
                          Text('Ask AI')
                        ],
                      )
                  )
                ],
              ),
              // Radial menu
              // AnimatedBuilder(
              //     animation: _animCtrRadialMenu,
              //     builder: (context, builder) => Transform.rotate(
              //       angle: radians(rotation.value),
              //       child: Stack(
              //         alignment: Alignment.bottomRight,
              //         children: [
              //           _buildButton(
              //               270,
              //               translation,
              //               child: FloatingActionButton.small(
              //                   backgroundColor: Colors.blue,
              //                   child: const Icon(Icons.link),
              //                   onPressed: (){
              //                     debugPrint('Hello from link button');
              //                   }
              //               )
              //           ),
              //           _buildButton(
              //               225,
              //               translation,
              //               child: FloatingActionButton.small(
              //                   backgroundColor: Colors.green,
              //                   child: const Icon(Icons.image),
              //                   onPressed: (){
              //                     debugPrint('Hello from image button');
              //                   }
              //               )
              //           ),
              //           _buildButton(
              //               180,
              //               translation,
              //               child: FloatingActionButton.small(
              //               backgroundColor: Colors.yellow,
              //               child: const Icon(Icons.ondemand_video),
              //               onPressed: (){
              //                 debugPrint('Hello from video button');
              //               }
              //           )
              //           ),
              //           _buildButton(
              //               135,
              //               translation,
              //               child: FloatingActionButton.small(
              //               backgroundColor: Colors.orange,
              //               child: const Icon(Icons.rocket_launch),
              //               onPressed: (){
              //                 debugPrint('Hello from ask button');
              //               }
              //           )
              //           ),
              //           _buildButton(
              //               90,
              //               translation,
              //               child: FloatingActionButton.small(
              //             backgroundColor: Colors.red,
              //             onPressed: (){
              //               debugPrint('Hello from post button');
              //             },
              //             tooltip: 'Post',
              //             child: const Icon(Icons.post_add),
              //           )
              //           ),
              //           Transform.scale(
              //             scale: scale.value - 1.5, // subtract the beginning value to run the opposite animation
              //             child: FloatingActionButton.small(
              //                 shape: const CircleBorder(),
              //                 onPressed: _closeRadialMenu,
              //                 backgroundColor: Colors.red,
              //                 child: const Icon(Icons.close)
              //             ),
              //           ),
              //           Transform.scale(
              //             scale: scale.value,
              //             child: FloatingActionButton.small(
              //                 shape: const CircleBorder(),
              //                 onPressed: _openRadialMenu,
              //                 child: const Icon(Icons.more_vert)
              //             ),
              //           ),
              //         ],
              //       ),
              //     )
              // ),

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
      return 'Title cannot be empty.';
    }

    return null;
  }

  void onIsPublicSelectionChange(bool? value) {
    setState(() {
      isPublic = value!;
    });
  }

  void _handlePost() {

  }

  void _handleAskAI() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AskAIAssistantTab()
        )
    );
  }

  _openRadialMenu() {
    _animCtrRadialMenu.forward();
  }

  _closeRadialMenu() {
    _animCtrRadialMenu.reverse();
  }

  double radians(double deg) {
    return (deg / 180.0) * pi;
  }

  Widget _buildButton(double angle, Animation<double> translation, { required Widget child }) {
    final double rad = radians(angle);
    return Transform(
        transform: Matrix4.identity()..translate(
            (translation.value) * cos(rad),
            (translation.value) * sin(rad)
        ),

        child: child
    );
  }
}
