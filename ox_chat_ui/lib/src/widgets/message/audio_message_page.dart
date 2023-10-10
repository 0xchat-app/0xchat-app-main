import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/utils/theme_color.dart';

import '../state/inherited_user.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import 'voice_message/voice_message.dart';

class AudioMessagePage extends StatefulWidget {

  final types.AudioMessage message;
  final Function(types.AudioMessage message)? fetchAudioFile;
  final Function(types.AudioMessage message)? onPlay;

  const AudioMessagePage({
    super.key,
    required this.message,
    this.fetchAudioFile,
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

  void initializedFile() {
    if (widget.message.audioFile == null || widget.message.duration == null) {
      widget.fetchAudioFile?.call(widget.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = InheritedUser.of(context).user;
    final isMe = user.id == widget.message.author.id;
    return VoiceMessage(
      meBgColor: Colors.transparent,
      contactBgColor: ThemeColor.color180,
      duration: widget.message.duration,
      audioFile: widget.message.audioFile,
      me: isMe, // Set message side.
      onPlay: () {
        widget.onPlay?.call(widget.message);
      }, // Do something when voice played.
    );
  }
}
