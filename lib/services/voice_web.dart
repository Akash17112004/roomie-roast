// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;

Future<bool> speakWebText(String text) async {
  final synth = html.window.speechSynthesis;
  if (synth == null) {
    return false;
  }

  if (text.trim().isEmpty) {
    return false;
  }

  synth.cancel();
  final utterance = html.SpeechSynthesisUtterance(text.trim())
    ..lang = 'en-US'
    ..rate = 0.95
    ..pitch = 1.0
    ..volume = 1.0;

  synth.speak(utterance);
  return true;
}

Future<void> stopWebText() async {
  html.window.speechSynthesis?.cancel();
}
