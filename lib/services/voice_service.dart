import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'voice_web_stub.dart' if (dart.library.html) 'voice_web.dart'
    as web_voice;

class VoiceService {
  VoiceService._();

  static final VoiceService instance = VoiceService._();
  final FlutterTts _tts = FlutterTts();
  bool _ready = false;

  Future<void> _ensureReady() async {
    if (_ready) {
      return;
    }

    final languages = await _tts.getLanguages;
    final hasEnUs = languages is List && languages.contains('en-US');
    final hasEnIn = languages is List && languages.contains('en-IN');
    if (hasEnUs) {
      await _tts.setLanguage('en-US');
    } else if (hasEnIn) {
      await _tts.setLanguage('en-IN');
    }
    await _tts.awaitSpeakCompletion(true);
    await _tts.setSpeechRate(0.47);
    await _tts.setPitch(1.0);
    await _tts.setVolume(1.0);
    _ready = true;
  }

  Future<bool> speak(String text) async {
    if (text.trim().isEmpty) {
      return false;
    }

    if (kIsWeb) {
      return web_voice.speakWebText(text);
    }

    try {
      await _ensureReady();
      await _tts.stop();
      final result = await _tts.speak(text.trim());
      return result == null || result == 1 || result == true;
    } catch (_) {
      return false;
    }
  }

  Future<void> stop() async {
    if (kIsWeb) {
      await web_voice.stopWebText();
      return;
    }
    await _tts.stop();
  }
}
