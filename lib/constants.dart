import 'package:flutter/services.dart';

final channelMain = MethodChannel('com.dev.noteflow.channel.MAIN');

class StringConstants {
  static const dbTheme = 'Theme';
  static const dbNotes = 'Notes';
  static const dbLabels = 'Labels';
  static const dbFolders = 'Folders';
  static const clearFlag = 'flag.CLEAR';
}

class IntegerConstants {
  static const freeTierLabelLimit = 5;
  static const freeTierFontLimit = 3;
}

class ColorConstants {
  static const noteBackgroundsLight = [
    const Color(0xffffab91),
    const Color(0xffb8b9ff),
    const Color(0xffffcc80),
    const Color(0xffb4f0a9),
    const Color(0xffe6ee9b),
    const Color(0xff7eccff),
    const Color(0xffffa5c4),
    const Color(0xff99e4cf),
    const Color(0xffe5aef5),
    const Color(0xffa2e5f4),
  ];

  static const onNoteBackgroundsLight = [
    const Color(0xffff8863),
    const Color(0xff9496ff),
    const Color(0xffffaf39),
    const Color(0xff7fe56c),
    const Color(0xffcede3b),
    const Color(0xff3cb2ff),
    const Color(0xffff77a6),
    const Color(0xff58d3b1),
    const Color(0xffd885f0),
    const Color(0xff59d1eb),
  ];

  static const noteBackgroundsDark = [
    const Color(0xff422319),
    const Color(0xff282942),
    const Color(0xff4b3715),
    const Color(0xff1f381c),
    const Color(0xff393d19),
    const Color(0xff0e3e55),
    const Color(0xff4b2332),
    const Color(0xff1c3c34),
    const Color(0xff36213d),
    const Color(0xff1e3d44),
  ];

  static const onNoteBackgroundsDark = [
    const Color(0xff603324),
    const Color(0xff3b3d62),
    const Color(0xff6b4e1e),
    const Color(0xff2e532a),
    const Color(0xff545a25),
    const Color(0xff145878),
    const Color(0xff673045),
    const Color(0xff29584c),
    const Color(0xff4d2f57),
    const Color(0xff2a5660),
  ];
}
