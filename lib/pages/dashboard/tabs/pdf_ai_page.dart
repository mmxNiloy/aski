import 'dart:convert';
import 'dart:io';

import 'package:aski/constants/utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../../../components/chat_bubble.dart';
import '../../../components/typing_indicator.dart';
import '../../../constants/server_response_constants.dart';
import 'package:http/http.dart' as http;

import '../../../models/ai_reply_model.dart';

class PDFAIPage extends StatefulWidget {
  const PDFAIPage({super.key});

  @override
  State<PDFAIPage> createState() => _PDFAIPageState();
}

class _PDFAIPageState extends State<PDFAIPage> {
  final GlobalKey<AnimatedListState> _animListKey = GlobalKey();
  final _tecMsg = TextEditingController();

  PlatformFile? _pdfFile;
  double _completionPct = 0.0;
  bool _isUploading = false;
  String _fileLink = '';
  final List<String> _messages = [];
  final List<ChatRole> _roles = []; // true -> ai, false -> user
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF AI Assistant'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.chevron_left),
        ),
      ),
      
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // File selector
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).dividerColor),
                borderRadius: const BorderRadius.all(Radius.circular(4)),
              ),
              child: Row(
                children: [
                  Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: Text(
                            _pdfFile == null ?
                            'No file Selected' :
                            _pdfFile!.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                  ),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      shape: const RoundedRectangleBorder(),
                    ),
                    onPressed: _handlePDFPicker,
                    child: const Text('Select File'),
                  )
                ],
              ),
            ),
            OutlinedButton(
                onPressed: (_isUploading || _pdfFile == null) ?
                null : // Disable the button when a file is uploading or a file is not selected.
                _uploadFile,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.upload),
                    Text('Upload'),
                  ],
                )
            ),
            // TODO: File upload progress bar
            _renderUploadProgressBar(),
            // Main viewport
            Expanded(
              child: _renderMainViewport(),
            ),
            const SizedBox(height: 7,),
            Divider(
              height: 1,
              color: Theme.of(context).dividerColor,
            ),
            // Chat text box
            TextField(
              enabled: _fileLink.isNotEmpty,
              controller: _tecMsg,
              decoration: InputDecoration(
                suffix: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ),
              minLines: 1,
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() async {
    String msg = _tecMsg.text.trim();
    if(msg.isEmpty) return;

    _tecMsg.clear();

    _roles.insert(0, ChatRole.user);
    _messages.insert(0, msg);
    _animListKey.currentState?.insertItem(_messages.length - 1,
        duration: const Duration(milliseconds: 20));

    _getReply();
  }

  // TODO: Get response from the API
  Future<void> _getReply() async {
    // Encode message to uri
    String msg = Uri.encodeComponent(_messages.first);

    // Release the typing indicator
    _roles.insert(0, ChatRole.loading);
    _messages.insert(0, '');
    _animListKey.currentState?.insertItem(_roles.length - 1,
        duration: const Duration(milliseconds: 20));

    // Fetch a reply from the API

    // response from AI
    String reply = '';

    for(var apiKey in ChatPDFAPIInfo.apiKeys) {
      reply = await _getAIResponse(apiKey, msg);

      if(reply != ChatPDFAPIInfo.errContent && reply != ChatPDFAPIInfo.errSource) {
        break;
      }
    }

    if(reply.isEmpty) {
      reply = 'Unable to fetch a response';
    }

    // Retract the typing indicator
    _animListKey.currentState?.removeItem(
        _roles.length - 1, (context, animation) => TypingIndicator(showIndicator: true, bubbleColor: Theme.of(context).highlightColor,),
        duration: const Duration(milliseconds: 2));
    _roles.removeAt(0);
    _messages.removeAt(0);

    // Push the ai reply
    _roles.insert(0, ChatRole.ai);
    _messages.insert(0, reply);
    _animListKey.currentState?.insertItem(_messages.length - 1,
        duration: const Duration(milliseconds: 20));
  }

  void _uploadFile() async {
    setState(() {
      _isUploading = true;
    });

    final storageRef = FirebaseStorage.instance.ref();
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final pdf = File(_pdfFile!.path!);

    final fileRef = storageRef.child('files/$uid.pdf');
    fileRef.putFile(pdf).snapshotEvents.listen((taskSnapshot) async {
      switch(taskSnapshot.state) {
        case TaskState.running:
          setState(() {
            _completionPct = (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
          });
          break;
        case TaskState.success:
          ScaffoldMessenger.of(context)
              .showSnackBar(
              const SnackBar(content: Text('Upload complete.'))
          );

          String downloadLink = await fileRef.getDownloadURL();
          setState(() {
            _fileLink = downloadLink;
          });

          setState(() {
            _isUploading = false;
          });
          break;
        case TaskState.error:
          ScaffoldMessenger.of(context)
              .showSnackBar(
            const SnackBar(content: Text('Upload failed!'))
          );
          setState(() {
            _isUploading = false;
          });
          break;
        case TaskState.paused:
          debugPrint('Upload paused.');
          break;
        case TaskState.canceled:
          debugPrint('Upload canceled.');
          break;
      }
    });
  }

  void _handlePDFPicker() async {
    FilePickerResult? res = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      allowedExtensions: ['pdf'],
      type: FileType.custom
    );

    if(res == null) return;

    setState(() {
      _pdfFile = res.files.single;
    });
  }

  Widget _renderUploadProgressBar() {
    if(!_isUploading) return const SizedBox();
    return LinearProgressIndicator(
      value: _completionPct,
    );
  }

  Widget _renderMainViewport() {
    if(_fileLink.isEmpty) {
      return const Center(
        child: Text('Upload a file to chat with AI'),
      );
    }

    return Align(
      alignment: Alignment.bottomCenter,
      child: AnimatedList(
        shrinkWrap: true,
        reverse: true,
        key: _animListKey,
        itemBuilder: (context, index, animation) {
          return SlideTransition(
            position: animation.drive(Tween<Offset>(
                begin: const Offset(0, 1), end: Offset.zero)),
            child: _roles[index] == ChatRole.loading
                ? TypingIndicator(showIndicator: true, bubbleColor: Theme.of(context).highlightColor,)
                : ChatBubble(
                content: _messages[index],
                isIncoming: _roles[index] == ChatRole.ai),
          );
        },
      ),
    );
  }

  Future<String> _getAIResponse(String apiKey, String msg) async {
    final req = ChatPDFAPIInfo.requestSourceId(apiKey, _fileLink);


    final response = await req;

    String sourceId = '';

    // Successful fetch of source id
    if (response.statusCode == 200) {
      final hash = json.decode(response.body) as Map<String, dynamic>;
      sourceId = hash['sourceId']!;

      // Send a request to get AI response
      String content = '';
      final reqChat = ChatPDFAPIInfo.requestAIResponse(apiKey, sourceId, msg);
      final responseChat = await reqChat;
      if(responseChat.statusCode == 200) {
        final cHash = json.decode(responseChat.body) as Map<String, dynamic>;
        debugPrint('Response Chat > ${cHash.toString()}');
        content = cHash['content']!;
        return content;
      } else {
        return ChatPDFAPIInfo.errContent;
      }
    } else {
      return ChatPDFAPIInfo.errSource;
    }
  }
}
