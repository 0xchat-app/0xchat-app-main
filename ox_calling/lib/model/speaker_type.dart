///Title: speaker_type
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2024/1/4 19:56
enum SpeakerType{
  speakerOnBluetooth,
  speakerOn,
  speakerOff,
}

extension SpeakerTypeEx on SpeakerType{
  int get value {
    switch (this) {
      case SpeakerType.speakerOff:
        return 0;
      case SpeakerType.speakerOn:
        return 1;
      case SpeakerType.speakerOnBluetooth:
        return 2;
    }
  }
}