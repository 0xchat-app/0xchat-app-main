import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_decrypted_image_provider.dart';

import '../state/inherited_chat_theme.dart';
import '../state/inherited_user.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import 'voice_message/voice_message.dart';

class AudioMessagePage extends StatefulWidget {

  final String audioSrc;
  final types.AudioMessage message;
  final Function(types.AudioMessage message)? onPlay;

  const AudioMessagePage({
    super.key,
    required this.audioSrc,
    required this.message,
    this.onPlay,
  });

  @override
  State<AudioMessagePage> createState() => _AudioMessagePageState();
}

class _AudioMessagePageState extends State<AudioMessagePage> {

  final Completer<File> fileCompleter = Completer();

  @override
  void initState() {
    super.initState();
    initializedFile();
  }

  Future initializedFile() async {
    final sourceFile = File(widget.audioSrc);
    if (widget.message.fileEncryptionType == types.EncryptionType.none) {
      fileCompleter.complete(sourceFile);
    } else {
      final decryptedFile = await DecryptedCacheManager.decryptFile(sourceFile, widget.message.author.id);
      fileCompleter.complete(decryptedFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = InheritedChatTheme.of(context).theme;
    final user = InheritedUser.of(context).user;
    final color = user.id == widget.message.author.id
        ? Colors.transparent
        : ThemeColor.color180;
    return VoiceMessage(
      // audioSrc: widget.audioSrc,
      meBgColor:color,
      duration: widget.message.duration,
      audioFile: fileCompleter.future,
      played: false, // To show played badge or not.
      me: true, // Set message side.
      onPlay: () {
        if(widget.onPlay != null){
          widget.onPlay!(widget.message);
        }
      }, // Do something when voice played.
    );
  }
}
