// Flutter Html Editor Enhanced

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:file_picker/file_picker.dart';

class RichTextEditor extends StatefulWidget {
  final double height;
  final bool? isFullscreen;

  const RichTextEditor({super.key, required this.height, this.isFullscreen});

  @override
  State<StatefulWidget> createState() => RichTextEditorState();
}

class RichTextEditorSharedStates {
  static late Function getText;
}

class RichTextEditorState extends State<RichTextEditor> {
  String result = '';
  final HtmlEditorController controller = HtmlEditorController();

  @override
  Widget build(BuildContext context) {
    RichTextEditorSharedStates.getText = controller.getText;

    return GestureDetector(
      onTap: () {
        if (!kIsWeb) {
          controller.clearFocus();
        }
      },
      child: HtmlEditor(
        controller: controller,
        htmlEditorOptions: const HtmlEditorOptions(
          hint: 'Your text here...',
          shouldEnsureVisible: true,
          autoAdjustHeight: false,
          //initialText: "<p>text content initial, if any</p>",
        ),
        htmlToolbarOptions: HtmlToolbarOptions(
          toolbarPosition: ToolbarPosition.aboveEditor, //by default
          toolbarType: ToolbarType.nativeGrid, //by default
          onButtonPressed:
              (ButtonType type, bool? status, Function? updateStatus) {
            debugPrint(
                "button '${describeEnum(type)}' pressed, the current selected status is $status"
            );
            return true;
          },
          onDropdownChanged: (DropdownType type, dynamic changed,
              Function(dynamic)? updateSelectedItem) {
            debugPrint(
                "dropdown '${describeEnum(type)}' changed to $changed"
            );
            return true;
          },
          mediaLinkInsertInterceptor:
              (String url, InsertFileType type) {
            debugPrint(url);
            return true;
          },
          mediaUploadInterceptor:
              (PlatformFile file, InsertFileType type) async {
            debugPrint(file.name); //filename
            debugPrint(file.size as String?); //size in bytes
            debugPrint(file.extension); //file extension (eg jpeg or mp4)
            return true;
          },
        ),
        otherOptions: OtherOptions(
            height: widget.height > 0.0 ? widget.height : MediaQuery.of(context).size.height / 3.0
        ),
        callbacks: Callbacks(onBeforeCommand: (String? currentHtml) {
          debugPrint('html before change is $currentHtml');
        }, onChangeContent: (String? changed) {
          debugPrint('content changed to $changed');
        }, onChangeCodeview: (String? changed) {
          debugPrint('code changed to $changed');
        }, onChangeSelection: (EditorSettings settings) {
          debugPrint('parent element is ${settings.parentElement}');
          debugPrint('font name is ${settings.fontName}');
        }, onDialogShown: () {
          debugPrint('dialog shown');
        }, onEnter: () {
          debugPrint('enter/return pressed');
        }, onFocus: () {
          debugPrint('editor focused');
        }, onBlur: () {
          debugPrint('editor unfocused');
        }, onBlurCodeview: () {
          debugPrint('code view either focused or unfocused');
        }, onInit: () {
          debugPrint('init');

          if(widget.isFullscreen! == true) {
            controller.setFullScreen();
          }
        },
            //this is commented because it overrides the default Summernote handlers
            /*onImageLinkInsert: (String? url) {
                      debugPrint(url ?? "unknown url");
                    },
                    onImageUpload: (FileUpload file) async {
                      debugPrint(file.name);
                      debugPrint(file.size);
                      debugPrint(file.type);
                      debugPrint(file.base64);
                    },*/
            onImageUploadError: (FileUpload? file, String? base64Str,
                UploadError error) {
              debugPrint(describeEnum(error));
              debugPrint(base64Str ?? '');
              if (file != null) {
                debugPrint(file.name);
                debugPrint(file.size as String?);
                debugPrint(file.type);
              }
            }, onKeyDown: (int? keyCode) {
              debugPrint('$keyCode key downed');
              debugPrint(
                  'current character count: ${controller.characterCount}');
            }, onKeyUp: (int? keyCode) {
              debugPrint('$keyCode key released');
            }, onMouseDown: () {
              debugPrint('mouse downed');
            }, onMouseUp: () {
              debugPrint('mouse released');
            }, onNavigationRequestMobile: (String url) {
              debugPrint(url);
              return NavigationActionPolicy.ALLOW;
            }, onPaste: () {
              debugPrint('pasted into editor');
            }, onScroll: () {
              debugPrint('editor scrolled');
            }),
        plugins: [
          SummernoteAtMention(
              getSuggestionsMobile: (String value) {
                var mentions = <String>['test1', 'test2', 'test3'];
                return mentions
                    .where((element) => element.contains(value))
                    .toList();
              },
              mentionsWeb: ['test1', 'test2', 'test3'],
              onSelect: (String value) {
                debugPrint(value);
              }),
        ],
      ),
    );
  }
}