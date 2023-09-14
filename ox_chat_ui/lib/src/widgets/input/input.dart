import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';

import '../../models/giphy_image.dart';
import '../../models/input_clear_mode.dart';
import '../../models/send_button_visibility_mode.dart';
import '../../util.dart';
import '../giphy/giphy_picker.dart';
import '../state/inherited_chat_theme.dart';
import '../state/inherited_l10n.dart';
import 'attachment_button.dart';
import 'input_more_page.dart';
import 'input_text_field_controller.dart';
import 'input_voice_page.dart';
import 'send_button.dart';


/// A class that represents bottom bar widget with a text field, attachment and
/// send buttons inside. By default hides send button when text field is empty.
class Input extends StatefulWidget {
  /// Creates [Input] widget.
  const Input({
    super.key,
    required this.items,
    this.isAttachmentUploading,
    this.onAttachmentPressed,
    required this.onSendPressed,
    this.options = const InputOptions(),
    this.onVoiceSend,
    this.textFieldHasFocus,
    this.onGifSend,
    this.inputBottomView,
  });

  /// Whether attachment is uploading. Will replace attachment button with a
  /// [CircularProgressIndicator]. Since we don't have libraries for
  /// managing media in dependencies we have no way of knowing if
  /// something is uploading so you need to set this manually.
  final bool? isAttachmentUploading;

  /// See [AttachmentButton.onPressed].
  final VoidCallback? onAttachmentPressed;

  /// Will be called on [SendButton] tap. Has [types.PartialText] which can
  /// be transformed to [types.TextMessage] and added to the messages list.
  final void Function(types.PartialText) onSendPressed;

  ///Send a voice message
  final void Function(String path, Duration duration)? onVoiceSend;

  final VoidCallback? textFieldHasFocus;

  /// Customisation options for the [Input].
  final InputOptions options;

  final List<InputMoreItem> items;

  ///Send a gif message
  final void Function(GiphyImage giphyImage)? onGifSend;

  final Widget? inputBottomView;

  @override
  State<Input> createState() => InputState();
}

/// [Input] widget state.
class InputState extends State<Input>{

  final _itemSpacing = Adapt.px(12);

  InputType inputType = InputType.inputTypeDefault;
  late final _inputFocusNode = FocusNode(
    onKeyEvent: (node, event) {
      if (event.physicalKey == PhysicalKeyboardKey.enter &&
          !HardwareKeyboard.instance.physicalKeysPressed.any(
            (el) => <PhysicalKeyboardKey>{
              PhysicalKeyboardKey.shiftLeft,
              PhysicalKeyboardKey.shiftRight,
            }.contains(el),
          )) {
        if (event is KeyDownEvent) {
          _handleSendPressed();
        }
        return KeyEventResult.handled;
      } else {
        return KeyEventResult.ignored;
      }
    },
  );
  bool _sendButtonVisible = false;
  late TextEditingController _textController;

  bool safeAreaBottomInsetsInit = false;
  double safeAreaBottomInsets = 0.0;

  void dissMissMoreView(){
      inputType = InputType.inputTypeDefault;
      setState(() {});
  }

  @override
  void didUpdateWidget(covariant Input oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.options.sendButtonVisibilityMode !=
        oldWidget.options.sendButtonVisibilityMode) {
      _handleSendButtonVisibilityModeChange();
    }
  }

  @override
  void dispose() {
    _inputFocusNode.dispose();
    _textController.dispose();
    // WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!safeAreaBottomInsetsInit) {
      safeAreaBottomInsetsInit = true;
      safeAreaBottomInsets = MediaQuery.of(context).padding.bottom;
    }
    return GestureDetector(
      onTap: () => _inputFocusNode.requestFocus(),
      child: _inputBuilder(),
    );
  }

  @override
  void initState() {
    super.initState();
    _inputFocusNode.addListener(() {
      if (_inputFocusNode.hasFocus) {
        //Gain focus
        final textFieldHasFocus = widget.textFieldHasFocus;
        if (textFieldHasFocus != null) {
          textFieldHasFocus();
        }

        // Prevents inexplicable 'moreview' not put away bug
        setState(() {
          inputType = InputType.inputTypeText;
        });
      } else {
        // _inputFocusNode.unfocus();
      }
    });
    // WidgetsBinding.instance.addObserver(this);
    _textController =
        widget.options.textEditingController ?? InputTextFieldController();
    _handleSendButtonVisibilityModeChange();
  }


  Widget getInputWidget(EdgeInsets buttonPadding,EdgeInsetsGeometry textPadding) =>
      Column(
        children: [
          defaultInputWidget(buttonPadding, textPadding),
          widget.inputBottomView ?? SizedBox(),
          getMyMoreView(),
        ],
      );


  Widget getMyMoreView() {
    Widget? contentWidget;
    if (inputType == InputType.inputTypeMore) {
      contentWidget = InputMorePage(items: widget.items,);
    } else if (inputType == InputType.inputTypeEmoji) {
      contentWidget = GiphyPicker(
          onSelected: (value) {
            if (widget.onGifSend != null) {
              widget.onGifSend!(value);
            }
          },
          textController:_textController
      );
    } else if (inputType == InputType.inputTypeVoice){
      contentWidget = InputVoicePage(onPressed: (_path, duration) {
        if(widget.onVoiceSend != null){
          widget.onVoiceSend!(_path, duration);
        }
      }, onCancel: () { },);
    }

    final animationDuration = Duration(milliseconds: 200);
    if (contentWidget != null) {
      return AnimatedContainer(
        duration: animationDuration,
        curve: Curves.ease,
        height: 260 + safeAreaBottomInsets, // Dynamic height adjustment
        child: contentWidget,
        onEnd: () {
          _inputFocusNode.unfocus();
        },
      );
    } else {
      return AnimatedContainer(
        duration: animationDuration,
        curve: Curves.easeInOut,
        height: 0 + safeAreaBottomInsets, // Dynamic height adjustment
        child:Container(),
        onEnd: () {
          if(inputType == InputType.inputTypeText){
            _inputFocusNode.requestFocus();
          }
        },
      );
    }
  }

  Widget defaultInputWidget(EdgeInsets buttonPadding, EdgeInsetsGeometry textPadding) => Container(
    decoration: BoxDecoration(
      color: ThemeColor.color190,
      borderRadius: BorderRadius.circular(12),
    ),
    margin: EdgeInsets.only(bottom: Adapt.px(10)),
    padding: EdgeInsets.symmetric(vertical: Adapt.px(8),),
    child: Row(
      textDirection: TextDirection.ltr,
      children: [
        _buildMoreButton(),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: ThemeColor.color180,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(vertical: Adapt.px(8),),
            child: Row(
              children: [
                Expanded(
                  child: _buildInputTextField().setPadding(EdgeInsets.only(left: _itemSpacing),),
                ),
                _buildEmojiButton(),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 200),
          firstChild: _buildSendButton(),
          secondChild: _buildVoiceButton(),
          crossFadeState: _sendButtonVisible ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        ),
      ],
    ),
  );

  Widget _buildVoiceButton() =>
      AttachmentButton(
        isLoading: widget.isAttachmentUploading ?? false,
        // onPressed: widget.onAttachmentPressed,
        onPressed: (){
          setState(() {
            inputType = InputType.inputTypeVoice;
          });
        },
        padding: EdgeInsets.symmetric(horizontal: _itemSpacing),
      );

  Widget _buildInputTextField() =>
      TextField(
        enabled: widget.options.enabled,
        autocorrect: widget.options.autocorrect,
        enableSuggestions: widget.options.enableSuggestions,
        controller: _textController,
        cursorColor: InheritedChatTheme.of(context)
            .theme
            .inputTextCursorColor,
        decoration: InheritedChatTheme.of(context)
            .theme
            .inputTextDecoration
            .copyWith(
          hintStyle: InheritedChatTheme.of(context)
              .theme
              .inputTextStyle
              .copyWith(
            color: InheritedChatTheme.of(context)
                .theme
                .inputTextColor
                .withOpacity(0.5),
          ),
          hintText:
          InheritedL10n.of(context).l10n.inputPlaceholder,
        ),
        focusNode: _inputFocusNode,
        keyboardType: widget.options.keyboardType,
        maxLines: 5,
        minLines: 1,
        onChanged: widget.options.onTextChanged,
        onTap: (){
          widget.options.onTextFieldTap;

          setState(() {
            inputType = InputType.inputTypeText;
          });
        },
        style: InheritedChatTheme.of(context)
            .theme
            .inputTextStyle
            .copyWith(
          color: InheritedChatTheme.of(context)
              .theme
              .inputTextColor,
        ),
        textCapitalization: TextCapitalization.sentences,
      );

  Widget _buildSendButton() =>
      SendButton(
        onPressed: _handleSendPressed,
        padding: EdgeInsets.symmetric(horizontal: _itemSpacing),
      );

  Widget _buildEmojiButton() =>
      IconButton(
        constraints: const BoxConstraints(
          minHeight: 24,
          minWidth: 24,
        ),
        icon:
        Image.asset(
          'assets/images/chat_emoti_icon.png',
          // color: InheritedChatTheme.of(context).theme.inputTextColor,
          package: 'ox_chat_ui',
        ),
        onPressed: (){
          setState(() {
            inputType = InputType.inputTypeEmoji;
            if (_inputFocusNode.hasFocus) {
              _inputFocusNode.unfocus();
            }
          });
        },
        splashRadius: 24,
        padding: EdgeInsets.symmetric(horizontal: _itemSpacing),
        tooltip: InheritedL10n.of(context).l10n.sendButtonAccessibilityLabel,
      );

  Widget _buildMoreButton() =>
      IconButton(
        constraints: const BoxConstraints(
          minHeight: 24,
          minWidth: 24,
        ),
        icon:
        Image.asset(
          'assets/images/chat_more_icon.png',
          // color: InheritedChatTheme.of(context).theme.inputTextColor,
          package: 'ox_chat_ui',
        ),
        onPressed: () {
          setState(() {
            inputType = InputType.inputTypeMore;
            _inputFocusNode.unfocus();
          });
        },
        splashRadius: 24,
        padding: EdgeInsets.symmetric(horizontal: _itemSpacing),
        tooltip: InheritedL10n.of(context).l10n.sendButtonAccessibilityLabel,
      );


  void _handleSendButtonVisibilityModeChange() {
    _textController.removeListener(_handleTextControllerChange);
    if (widget.options.sendButtonVisibilityMode ==
        SendButtonVisibilityMode.hidden) {
      _sendButtonVisible = false;
    } else if (widget.options.sendButtonVisibilityMode ==
        SendButtonVisibilityMode.editing) {
      _sendButtonVisible = _textController.text.trim() != '';
      _textController.addListener(_handleTextControllerChange);
    } else {
      _sendButtonVisible = true;
    }
  }

  void _handleSendPressed() {
    final trimmedText = _textController.text.trim();
    if (trimmedText != '') {
      final partialText = types.PartialText(text: trimmedText);
      widget.onSendPressed(partialText);

      if (widget.options.inputClearMode == InputClearMode.always) {
        _textController.clear();
        final onTextChanged = widget.options.onTextChanged;
        if (onTextChanged != null) onTextChanged(_textController.text);
      }
    }
  }

  void _handleTextControllerChange() {
    setState(() {
      _sendButtonVisible = _textController.text.trim() != '';
    });
  }

  Widget _inputBuilder() {
    final buttonPadding = InheritedChatTheme.of(context)
        .theme
        .inputPadding
        .copyWith(left: Adapt.px(12), right: Adapt.px(12));
    final textPadding = InheritedChatTheme.of(context)
        .theme
        .inputPadding;
    final query = MediaQuery.of(context);
    var bottomInset = isMobile ? query.viewInsets.bottom : 0.0;
    bottomInset -= safeAreaBottomInsets;
    bottomInset = max(0.0, bottomInset);
    return Focus(
      autofocus: true,
      child: Material(
        color: Colors.transparent,
        child: Container(
          decoration:
              InheritedChatTheme.of(context).theme.inputContainerDecoration,
          padding: EdgeInsets.only(bottom: bottomInset),
          child: getInputWidget(buttonPadding, textPadding),
      ),
        ),
    );
  }
}

@immutable
class InputOptions {
  const InputOptions(
     {

    this.inputClearMode = InputClearMode.always,
    this.keyboardType = TextInputType.multiline,
    this.onTextChanged,
    this.onTextFieldTap,
    this.sendButtonVisibilityMode = SendButtonVisibilityMode.editing,
    this.textEditingController,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.enabled = true,
  });

  /// Controls the [Input] clear behavior. Defaults to [InputClearMode.always].
  final InputClearMode inputClearMode;
  
  /// Controls the [Input] keyboard type. Defaults to [TextInputType.multiline].
  final TextInputType keyboardType;

  /// Will be called whenever the text inside [TextField] changes.
  final void Function(String)? onTextChanged;



  /// Will be called on [TextField] tap.
  final VoidCallback? onTextFieldTap;

  /// Controls the visibility behavior of the [SendButton] based on the
  /// [TextField] state inside the [Input] widget.
  /// Defaults to [SendButtonVisibilityMode.editing].
  final SendButtonVisibilityMode sendButtonVisibilityMode;

  /// Custom [TextEditingController]. If not provided, defaults to the
  /// [InputTextFieldController], which extends [TextEditingController] and has
  /// additional fatures like markdown support. If you want to keep additional
  /// features but still need some methods from the default [TextEditingController],
  /// you can create your own [InputTextFieldController] (imported from this lib)
  /// and pass it here.
  final TextEditingController? textEditingController;

  /// Controls the [TextInput] autocorrect behavior. Defaults to [true].
  final bool autocorrect;

  /// Controls the [TextInput] enableSuggestions behavior. Defaults to [true].
  final bool enableSuggestions;

  /// Controls the [TextInput] enabled behavior. Defaults to [true].
  final bool enabled;
}


enum InputType {
  inputTypeDefault,
  inputTypeText,
  inputTypeEmoji,
  inputTypeMore,
  inputTypeVoice,
}